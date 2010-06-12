package reflex.display
{
  import flash.display.Sprite;
  
  
  /**
   * Modifies common DisplayObject properties for improved usability.
   * For instance width and height properties will not be be affected by 
   * graphics API updates.
   * Better naming options are welcome for this class.
   * @alpha
   */
  public class ReflexDisplay extends Sprite implements IMeasurable, IMovable
  {
    protected var _explicitWidth:Number;
    
    public function get explicitWidth():Number
    {
      return _explicitWidth;
    }
    
    protected var _explicitHeight:Number;
    
    public function get explicitHeight():Number
    {
      return _explicitHeight;
    }
    
    protected var _width:Number;
    
    [PercentProxy("percentWidth")]
    
    override public function get width():Number
    {
      return _width;
    }
    
    override public function set width(value:Number):void
    {
      _explicitWidth = value;
    }
    
    protected var _height:Number;
    
    [PercentProxy("percentHeight")]
    
    override public function get height():Number
    {
      return _width;
    }
    
    override public function set height(value:Number):void
    {
      _explicitWidth = value;
    }
    
    protected var _percentWidth:Number;
    
    public function get percentWidth():Number
    {
      return _percentWidth;
    }
    
    public function set percentWidth(value:Number):void
    {
      if(_percentWidth == value)
        return;
      
      _percentWidth = value;
    }
    
    protected var _percentHeight:Number;
    
    public function get percentHeight():Number
    {
      return _percentHeight;
    }
    
    public function set percentHeight(value:Number):void
    {
      if(_percentHeight == value)
        return;
      
      _percentHeight = value;
    }
    
    /**
     * Sets width and height properties without effecting measurement.
     * Use cases include layout and animation/tweening among other things.
     */
    public function setSize(width:Number, height:Number):void
    {
      _width = width;
      _height = height;
    }
    
    public function move(x:Number, y:Number):void
    {
      super.x = x;
      super.y = y;
    }
  }
}