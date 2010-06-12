package reflex.graphics
{
  import flash.display.Graphics;
  import flash.display.Sprite;
  import flash.events.EventDispatcher;
  
  import mx.events.PropertyChangeEvent;
  
  import reflex.display.DisplayPhases;
  import reflex.display.IMeasurable;
  import reflex.utilities.oneShot;
  
  public class Graphic extends EventDispatcher implements IDrawable, IMeasurable
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
    
    protected function attachTo(target:Sprite):void
    {
      invalidate();
    }
    
    protected function detachFrom(target:Sprite):void
    {
    }
    
    protected var invalidatedFlag:Boolean = false;
    
    public function invalidate():void
    {
      if(!target || invalidatedFlag)
        return;
      
      DisplayPhases.invalidateLayout(target, oneShot(render, this));
      invalidatedFlag = true;
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
    }
    
    private function onPropertyChange(event:PropertyChangeEvent):void
    {
      invalidate();
    }
  }
}