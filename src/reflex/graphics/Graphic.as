package reflex.graphics
{
  import flash.display.Graphics;
  import flash.display.Sprite;
  import flash.events.EventDispatcher;
  
  import mx.events.PropertyChangeEvent;
  
  import reflex.display.DisplayPhases;
  import reflex.display.IMeasurable;
  import reflex.display.IMovable;
  import reflex.utilities.listen;
  
  public class Graphic extends EventDispatcher implements IDrawable, IMeasurable, IMovable
  {
    public function Graphic()
    {
      super();
      
      addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
    }
    
    private var _target:Sprite;
    
    public function get target():Sprite
    {
      return _target;
    }
    
    public function set target(value:Sprite):void
    {
      if(_target == value)
        return;
      
      if(target)
        detachFrom(target);
      
      _target = value;
      
      if(target)
        attachTo(target);
    }
    
    private var listener:Function;
    protected function attachTo(target:Sprite):void
    {
      // Graphics need to always listen for the layout event on their targets,
      // because when the their targets validate their layout phase, they clear
      // their graphics context. We get the event and redraw ourselves.
      target.addEventListener(DisplayPhases.LAYOUT, listener = listen(render));
      
      invalidate();
    }
    
    protected function detachFrom(target:Sprite):void
    {
      target.removeEventListener(DisplayPhases.LAYOUT, listener);
    }
    
    protected var invalidatedFlag:Boolean = false;
    
    public function invalidate():void
    {
      if(!target)
        return;
      
      DisplayPhases.invalidateLayout(target);
    }
    
    public function render():void
    {
      if(!target)
      {
        invalidatedFlag = false;
        return;
      }
      
      renderGraphic();
      
      invalidatedFlag = false;
    }
    
    protected function renderGraphic():void
    {
      trace('Graphic renderGraphic');
    }
    
    public function get g():Graphics
    {
      return target ? target.graphics : null;
    }
    
    public function get explicitWidth():Number
    {
      return width;
    }
    
    public function get explicitHeight():Number
    {
      return height
    }
    
    [Bindable]
    public var x:Number = 0;
    
    [Bindable]
    public var y:Number = 0;
    
    [PercentProxy("percentWidth")]
    [Bindable]
    public var width:Number;
    
    [PercentProxy("percentHeight")]
    [Bindable]
    public var height:Number;
    
    [Bindable]
    public  var percentWidth:Number;
    
    [Bindable]
    public var percentHeight:Number;
    
    public function setSize(width:Number, height:Number):void
    {
      this.width = width;
      this.height = height;
      
      invalidate();
    }
    
    public function move(x:Number, y:Number):void
    {
      this.x = x;
      this.y = y;
      
      invalidate();
    }
    
    private function onPropertyChange(event:PropertyChangeEvent):void
    {
      invalidate();
    }
  }
}