package reflex.display
{
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.EventPhase;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import reflex.graphics.IDrawable;
  import reflex.layouts.ILayout;
  import reflex.skins.ISkin;
  import reflex.utilities.listen;
  
  use namespace rx_internal;
  
  // Default property that MXML sets when you define children MXML nodes.
  [DefaultProperty("children")]
  
  [Event(name="childrenChanged", type="flash.events.Event")]
  [Event(name="layoutChanged", type="flash.events.Event")]
  
  /**
   * @alpha
   */
  public class Container extends ReflexDisplay implements IContainer
  {
    DisplayPhases;
    
    public function Container()
    {
      addEventListener(Event.ADDED, onAdded);
      
      addEventListener(DisplayPhases.NOTIFY, listen(onNotifyPhase), false, 50);
      addEventListener(DisplayPhases.CHILDREN, listen(onChildrenPhase), false, 50);
      addEventListener(DisplayPhases.MEASURE, listen(onMeasurePhase), false, 50);
      addEventListener(DisplayPhases.LAYOUT, listen(onLayoutPhase), false, 50);
    }
    
    private function onAdded(event:Event):void
    {
      if(event.eventPhase != EventPhase.AT_TARGET)
        return;
      
      removeEventListener(Event.ADDED, onAdded);
    }
    
    private var _children:Array = [];
    rx_internal var childrenChanged:Boolean = false;
    
    [Bindable(event="childrenChanged")]
    [ArrayElementType("Object")]
    
    public function get children():Array
    {
      return _children;
    }
    
    public function set children(values:Array):void
    {
      while(numChildren)
        removeChildAt(0);
      
      _children = [].concat(values);
      
      invalidateNotifications('childrenChanged');
      invalidateChildren();
    }
    
    private var _layout:ILayout;
    
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
      
      invalidateNotifications('layoutChanged');
      invalidateSize();
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
    
    override public function setSize(newWidth:Number, newHeight:Number):void
    {
      var changed:Boolean = (newWidth != _width) || (newHeight != _height);
      
      super.setSize(newWidth, newHeight);
      
      if(changed)
        invalidateLayout();
    }
    
    protected var invalidatedProperties:Object = {};
    
    public function invalidateNotifications(changedNotification:String = null):void
    {
//      trace('Container invalidateNotifications');
      
      if(changedNotification)
        invalidatedProperties[changedNotification] = true;
      
      DisplayPhases.invalidateNotifications(this);
    }
    /**
     * Synchronizes dispatching the binding events so that anyone who cares
     * (such as Behaviors) will update and calculate only once per frame.
     * @alpha
     */
    protected function onNotifyPhase():void
    {
//      trace('Container notify phase');
      
      for(var changedNotification:String in invalidatedProperties)
      {
        dispatchEvent(new Event(changedNotification));
        delete invalidatedProperties[changedNotification];
      }
    }
    
    public function invalidateChildren():void
    {
//      trace('Container invalidateChildren');
      
      DisplayPhases.invalidateChildren(this);
    }
    
    protected function onChildrenPhase():void
    {
//      trace('Container children phase');
      
      var copy:Array = children.concat();
      var child:Object;
      
      while(copy.length)
      {
        child = copy.shift();
        if(child is DisplayObject)
          addChild(DisplayObject(child));
        else if(child is IDrawable)
          IDrawable(child).target = this;
        else if(child is ISkin)
          ISkin(child).target = this;
      }
    }
    
    public function invalidateSize():void
    {
//      trace('Container invalidateSize');
      
      DisplayPhases.invalidateSize(this);
    }
    
    protected function onMeasurePhase():void
    {
//      trace('Container measure phase');
      
      // Don't bother measuring if we've got an explicitWidth and explicitHeight -- it's not allowed to change.
      if(!isNaN(explicitWidth) && !isNaN(explicitHeight))
      {
        _width = explicitWidth;
        _height = explicitHeight;
        return;
      }
      
      if(isNaN(percentWidth) && !isNaN(explicitWidth))
        _width = explicitWidth;
      if(isNaN(percentHeight) && !isNaN(explicitHeight))
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
//      trace('Container invalidateLayout');
      
      DisplayPhases.invalidateLayout(this);
    }
    
    protected function onLayoutPhase():void
    {
//      trace('Container layout phase');
      
      graphics.clear();
      
      if(!layout)
        return;
      
      layout.update(children);
    }
  }
}