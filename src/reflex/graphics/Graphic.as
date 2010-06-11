package reflex.graphics
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.Shape;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  
  import flight.events.PropertyEvent;
  
  import reflex.display.Container;
  import reflex.display.DisplayPhases;
  import reflex.events.InvalidationEvent;
  import reflex.utilities.Utility;
  import reflex.utilities.invalidation.IInvalidationUtility;
  import reflex.utilities.oneShot;

  public class Graphic extends EventDispatcher implements IDrawable
  {
    public function Graphic(target:Object = null)
    {
      this.target = target;
    }
    
    private var _target:Object;
    
    public function get target():Object
    {
      return _target;
    }
    
    public function set target(value:Object):void
    {
      _target = value;
      if(target is DisplayObject)
      {
        invalidate();
      }
      if(target is DisplayObjectContainer)
      {
        if(canvas && canvas.parent && canvas.parent.contains(canvas))
          canvas.parent.removeChild(canvas);
        
        _canvas = createCanvas();
        
        DisplayObjectContainer(target).addChild(canvas);
      }
    }
    
    /**
     * The alpha of the component.
     * @default 1
     */
    protected var _alpha:Number = 1;
    public function get alpha():Number
    {
      return _alpha;
    }
    
    public function set alpha(value:Number):void
    {
      if(value === _alpha)
        return;
      
      if(canvas)
        canvas.alpha = value;
      
      PropertyEvent.change(this, "alpha", _alpha, _alpha = value);
    }
    
    /**
     * The internal drawing canvas of the component.
     * @default null
     */
    protected var _canvas:Shape;
    public function get canvas():Shape
    {
      return _canvas;
    }
    
    protected var _percentHeight:Number = NaN;
    
    public function get percentHeight():Number
    {
      return _percentHeight;
    }
    
    public function set percentHeight(value:Number):void
    {
      if(value === _percentHeight)
        return;
      
      PropertyEvent.change(this, "percentHeight", _percentHeight, _percentHeight = value);
    }
    
    protected var _percentWidth:Number = NaN;
    
    public function get percentWidth():Number
    {
      return _percentWidth;
    }
    
    public function set percentWidth(value:Number):void
    {
      if(value === _percentWidth)
        return;
      
      PropertyEvent.change(this, "percentWidth", _percentWidth, _percentWidth = value);
    }
    
    /**
     * The x of the component.
     * @default 0
     */
    protected var _x:Number = 0;
    public function get x():Number
    {
      return _x;
    }
    
    public function set x(value:Number):void
    {
      if(value === _x)
        return;
      
      if(canvas)
        _canvas.x = value;
      
      PropertyEvent.change(this, "x", _x, _x = value);
    }
    
    /**
     * The y of the component.
     * @default 0
     */
    protected var _y:Number = 0;
    public function get y():Number
    {
      return _y;
    }
    
    public function set y(value:Number):void
    {
      if(value === _y)
        return;
      
      if(canvas)
        _canvas.y = value;
      
      PropertyEvent.change(this, "y", _y, _y = value);
    }
    
    /**
     * The z of the component.
     * @default 0
     */
    protected var _z:Number = 0;
    public function get z():Number
    {
      return _z;
    }
    
    public function set z(value:Number):void
    {
      if(value === _z)
        return;
      
      if(canvas)
        _canvas.z = value;
      
      PropertyEvent.change(this, "z", _z, _z = value);
    }
    
    /**
     * The scaleX of the component.
     * @default 0
     */
    protected var _scaleX:Number = 1;
    public function get scaleX():Number
    {
      return _scaleX;
    }
    
    public function set scaleX(value:Number):void
    {
      if(value === _scaleX)
        return;
      
      if(canvas)
        _canvas.scaleX = value;
      
      PropertyEvent.change(this, "scaleX", _scaleX, _scaleX = value);
    }
    
    /**
     * The scaleY of the component.
     * @default 0
     */
    protected var _scaleY:Number = 1;
    public function get scaleY():Number
    {
      return _scaleY;
    }
    
    public function set scaleY(value:Number):void
    {
      if(value === _scaleY)
        return;
      
      if(canvas)
        _canvas.scaleY = value;
      
      PropertyEvent.change(this, "scaleY", _scaleY, _scaleY = value);
    }
    
    /**
     * The scaleZ of the component.
     * @default 0
     */
    protected var _scaleZ:Number = 1;
    public function get scaleZ():Number
    {
      return _scaleZ;
    }
    
    public function set scaleZ(value:Number):void
    {
      if(value === _scaleZ)
        return;
      
      if(canvas)
        _canvas.scaleZ = value;
      
      PropertyEvent.change(this, "scaleZ", _scaleZ, _scaleZ = value);
    }
    
    /**
     * The width of the component.
     * @default
     */
    protected var _width:Number = 0;
    [PercentProxy("percentWidth")]
    public function get width():Number
    {
      return _width;
    }
    
    public function set width(value:Number):void
    {
      if(value === _width)
        return;
      
      if(canvas)
        _canvas.width = value;
      
      PropertyEvent.change(this, "width", _width, _width = value);
    }
    
    /**
     * The height of the component.
     * @default 0
     */
    protected var _height:Number = 0;
    [PercentProxy("percentHeight")]
    public function get height():Number
    {
      return _height;
    }
    
    public function set height(value:Number):void
    {
      if(value === _height)
        return;
      
      if(canvas)
        _canvas.height = value;
      
      PropertyEvent.change(this, "height", _height, _height = value);
    }
    
    protected var _visible:Boolean = true;
    public function get visible():Boolean
    {
      return _visible;
    }
    
    public function set visible(value:Boolean):void
    {
      if(value === _visible)
        return;
      
      if(canvas)
        canvas.visible = value;
      
      PropertyEvent.change(this, "visible", _visible, _visible = value);
    }
    
    public function invalidate():void
    {
      if(!target)
        return;
      
      Utility.resolve(<>IInvalidationUtility.invalidate</>, target, DisplayPhases.LAYOUT);
      IEventDispatcher(target).addEventListener(DisplayPhases.LAYOUT, oneShot(onRender, target as IEventDispatcher));
    }
    
    private function onRender(event:InvalidationEvent):void
    {
      render();
    }
    
    public function render():void
    {
      if(!canvas)
        return;
      
      canvas.graphics.clear();
    }
    
    protected function createCanvas():Shape
    {
      var shape:Shape = new Shape();
      shape.alpha = alpha;
      shape.x = x;
      shape.y = y;
      shape.z = z;
      shape.scaleX = scaleX;
      shape.scaleY = scaleY;
      shape.scaleZ = scaleZ;
//      shape.width = width;
//      shape.height = height;
      shape.visible = visible;
      return shape;
    }
    
    DisplayPhases;
  }
}