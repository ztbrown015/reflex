package reflex.graphics
{
  import flash.display.Graphics;
  import flash.display.Sprite;
  import flash.events.EventDispatcher;
  
  import mx.events.PropertyChangeEvent;
  import mx.events.PropertyChangeEventKind;
  
  import reflex.display.DisplayPhases;
  import reflex.display.IMeasurable;
  import reflex.display.IMovable;
  import reflex.styles.IStyleAware;
  import reflex.styles.StyleAwareActor;
  import reflex.utilities.listen;
  
  [Style(name="left", type="Number")]
  [Style(name="right", type="Number")]
  [Style(name="top", type="Number")]
  [Style(name="bottom", type="Number")]
  [Style(name="horizontalCenter", type="Number")]
  [Style(name="verticalCenter", type="Number")]
  [Style(name="dock", type="Boolean", enumeration="true,false")]
  
  [Style(name="vAlign", type="String", enumeration="top,middle,bottom")]
  [Style(name="hAlign", type="String", enumeration="left,center,right")]
  
  [Style(name="marginLeft", type="Number")]
  [Style(name="marginRight", type="Number")]
  [Style(name="marginTop", type="Number")]
  [Style(name="marginBottom", type="Number")]
  
  public class Graphic extends StyleAwareActor implements IDrawable, IMeasurable, IMovable, IStyleAware
  {
    public function Graphic(target:Sprite = null)
    {
      addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
      addEventListener('stylesChanged', onPropertyChange);
      
      this.target = target;
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
//      trace('Graphic renderGraphic');
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
    public var width:Number = 0;
    
    [PercentProxy("percentHeight")]
    [Bindable]
    public var height:Number = 0;
    
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