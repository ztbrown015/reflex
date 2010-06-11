package reflex.display
{
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.EventPhase;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import flight.events.ListEvent;
  import flight.events.ListEventKind;
  import flight.list.ArrayList;
  import flight.list.IList;
  
  import reflex.events.InvalidationEvent;
  import reflex.layouts.ILayout;
  import reflex.measurement.resolveHeight;
  import reflex.measurement.resolveWidth;
  
  [Event(name="initialize", type="reflex.events.InvalidationEvent")]
  
  [DefaultProperty("children")]
  
  /**
   * @alpha
   */
  public class Container extends ReflexDisplay implements IContainer
  {
    static public const CREATE:String = "create";
    static public const INITIALIZE:String = "initialize";
    static public const MEASURE:String = "measure";
    static public const LAYOUT:String = "layout";
    
//    InvalidationEvent.registerPhase(CREATE, 0, true);
//    InvalidationEvent.registerPhase(INITIALIZE, 1, true);
//    InvalidationEvent.registerPhase(MEASURE, 2, true);
//    InvalidationEvent.registerPhase(LAYOUT, 3, false);
    
    public function Container()
    {
      addEventListener(Event.ADDED, onAdded);
      //TODO: Add this back in later.
//      addEventListener(MEASURE, onMeasure);
//      addEventListener(LAYOUT, onLayout);
    }
    
    private var _children:Array;
    
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
    }
    
    private var _layout:ILayout;
    
    public function get layout():ILayout
    {
      return _layout;
    }
    
    public function set layout(value:ILayout):void
    {
      if(layout)
        removeLayout(layout)
      
      _layout = value;
      
      if(layout)
        applyLayout(layout);
      
      //TODO: Add this back in later.
//      InvalidationEvent.invalidate(this, MEASURE);
//      InvalidationEvent.invalidate(this, LAYOUT);
    }
    
    protected function applyLayout(layout:ILayout):void
    {
      layout.target = this;
    }
    
    protected function removeLayout(layout:ILayout):void
    {
      layout.target = null;
    }
    
    private function onAdded(event:Event):void
    {
      if(event.eventPhase != EventPhase.AT_TARGET)
        return;
      
      removeEventListener(Event.ADDED, onAdded);
      
      //TODO: Add this back in later.
//      InvalidationEvent.invalidate(this, CREATE);
//      InvalidationEvent.invalidate(this, INITIALIZE);
    }
  }
}