package reflex.layouts
{
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import reflex.measurement.resolveHeight;
  import reflex.measurement.resolveWidth;
  
  
  [LayoutProperty(name="width", measure="true")]
  [LayoutProperty(name="height", measure="true")]
  
  /**
   * @alpha
   **/
  public class HorizontalLayout extends Layout implements ILayout
  {
    
    [Bindable]
    public var gap:Number = 5;
    
    override public function measure(children:Array):Point
    {
      super.measure(children);
      
      var point:Point = new Point(gap, 0);
      var width:Number, height:Number;
      
      for each(var child:Object in children)
      {
        width = resolveWidth(child);
        height = resolveHeight(child);
        point.x += width + gap;
        point.y = Math.max(point.y, height);
      }
      
      return point;
    }
    
    override public function update(children:Array, rectangle:Rectangle):void
    {
      super.update(children, rectangle);
      var position:Number = gap;
      var length:int = children.length;
      var child:Object, width:Number, height:Number;
      
      for(var i:int = 0; i < length; i++)
      {
        child = children[i];
        width = resolveWidth(child);
        height = resolveHeight(child);
        child.x = position;
        child.y = rectangle.height / 2 - height / 2;
        position += width + gap;
      }
    }
  
  }
}