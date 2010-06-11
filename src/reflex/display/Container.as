package reflex.display
{
  import flash.events.Event;
  import flash.events.EventPhase;
  import flash.geom.Point;
  
  import reflex.events.InvalidationEvent;
  import reflex.layouts.ILayout;
  import reflex.utilities.Utility;
  import reflex.utilities.invalidation.IInvalidationUtility;
  import reflex.utilities.oneShot;
  
  ////
  // Default property that MXML sets when you define children MXML nodes.
  ////
  [DefaultProperty("children")]
  
  ////
  // Events this class dispatches. Update this list as it grows.
  ////
  [Event(name="childrenChanged", type="Event")]
  [Event(name="layoutChanged", type="Event")]
  
  /**
   * @alpha
   */
  public class Container extends ReflexDisplay implements IContainer, IInvalidating
  {
    public function Container()
    {
      addEventListener(Event.ADDED, onAdded);
    }
    
    private function onAdded(event:Event):void
    {
      if(event.eventPhase != EventPhase.AT_TARGET)
        return;
      
      removeEventListener(Event.ADDED, onAdded);
    }
    
    private var _children:Array;
    private var childrenChanged:Boolean = false;
    
    [Bindable(event="childrenChanged")]
    [ArrayElementType("Object")]
    
    public function get children():Array
    {
      return _children;
    }
    
    public function set children(... values):void
    {
      while(numChildren)
        removeChildAt(0);
      
      _children = [].concat(values);
      
      childrenChanged = true;
      
      invalidateNotifications();
      invalidateChildren();
    }
    
    private var _layout:ILayout;
    private var layoutChanged:Boolean = false;
    
    [Bindable(event="layoutChanged")]
    
    public function get layout():ILayout
    {
      return _layout;
    }
    
    public function set layout(value:ILayout):void
    {
      if(_layout == value)
        return;
      
      if(layout)
        removeLayout(layout)
      
      _layout = value;
      
      if(layout)
        applyLayout(layout);
      
      layoutChanged = true;
      
      invalidateNotifications();
      invalidateLayout();
    }
    
    protected function applyLayout(layout:ILayout):void
    {
      layout.target = this;
    }
    
    protected function removeLayout(layout:ILayout):void
    {
      layout.target = null;
    }
    
    override public function set width(value:Number):void
    {
      super.width = value;
      
      if(_width != value)
        invalidateSize();
    }
    
    override public function set height(value:Number):void
    {
      super.height = value;
      
      if(_height != value)
        invalidateSize();
    }
    
    public function invalidateNotifications():void
    {
      DisplayPhases.invalidateNotifications(this, onNotifyPhase);
    }
    
    /**
     * Synchronizes dispatching the binding events so that anyone who cares
     * (such as Behaviors) will update and calculate only once per frame.
     * @alpha
     */
    protected function onNotifyPhase():void
    {
      if(childrenChanged)
        dispatchEvent(new Event("childrenChanged"));
      childrenChanged = false;
      
      if(layoutChanged)
        dispatchEvent(new Event("layoutChanged"));
      layoutChanged = false;
    }
    
    public function invalidateChildren():void
    {
      DisplayPhases.invalidateChildren(this, onChildrenPhase);
    }
    
    protected function onChildrenPhase():void
    {
      
    }
    
    public function invalidateSize():void
    {
      DisplayPhases.invalidateSize(this, onMeasurePhase);
    }
    
    protected function onMeasurePhase():void
    {
      // Don't bother sizing if we've got an explicitWidth and explicitHeight -- it's not allowed to change.
      if(!isNaN(explicitWidth) && !isNaN(explicitHeight))
      {
        _width = explicitWidth;
        _height = explicitHeight;
        return;
      }
      
      if(isNaN(percentWidth))
        _width = explicitWidth;
      if(isNaN(percentHeight))
        _height = explicitHeight;
      
      if(!layout)
        return;
      
      var size:Point = layout.measure(children);
      
      if(isNaN(explicitWidth) && isNaN(percentWidth))
        _width = size.x;
      if(isNaN(explicitHeight) && isNaN(percentHeight))
        _height = size.y;
    }
    
    public function invalidateLayout():void
    {
      DisplayPhases.invalidateLayout(this, onLayoutPhase);
    }
    
    protected function onLayoutPhase():void
    {
      if(!layout)
        return;
      
      layout.update(children, getBounds(this));
    }
    
    DisplayPhases;
  }
}