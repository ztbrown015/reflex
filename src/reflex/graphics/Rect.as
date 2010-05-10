package reflex.graphics
{
  import flash.display.DisplayObject;
  import flash.display.Graphics;
  import flash.events.IEventDispatcher;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import mx.events.PropertyChangeEvent;
  
  import reflex.events.RenderEvent;
  import reflex.layout.Layout;
  import reflex.utils.GraphicsUtil;
  
  public class Rect extends Graphic
  {
    public function Rect(target:Object = null)
    {
      super(target);
    }
    
    // TODO: create a reflex IFill and IStroke - Flex3 & Flex4 Interfaces are incompatible
    private var _fill:*;
    
    public function get fill():*
    {
      return _fill;
    }
    
    public function set fill(value:*):void
    {
      _fill = value;
      if(_fill is IEventDispatcher)
      {
        // update this to use binding correctly
        (_fill as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
      }
      invalidate();
    }
    
    // TODO: create a reflex IFill and IStroke - Flex3 & Flex4 Interfaces are incompatible
    private var _stroke:*;
    
    public function get stroke():*
    {
      return _stroke;
    }
    
    public function set stroke(value:*):void
    {
      _stroke = value;
      if(_stroke is IEventDispatcher)
      {
        // update this to use binding correctly
        (_stroke as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
      }
      invalidate();
    }
    
    override public function render():void
    {
      super.render();
      
      if(width < 0 || height < 0 || !canvas)
        return;
      
      var rectangle:Rectangle = new Rectangle(0, 0, width, height);
      if(stroke)
        stroke.apply(canvas.graphics, rectangle, new Point());
      if(fill)
        fill.begin(canvas.graphics, rectangle, new Point());
      
      canvas.graphics.drawRect(0, 0, width, height);
      
      if(fill)
        fill.end(canvas.graphics);
    }
    
    private function propertyChangeHandler(event:PropertyChangeEvent):void
    {
      invalidate()
    }
  
  }
}