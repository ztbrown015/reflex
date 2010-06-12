package reflex.layouts
{
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  
  [LayoutProperty(name="x", measure="true")]
  [LayoutProperty(name="y", measure="true")]
  [LayoutProperty(name="width", measure="true")]
  [LayoutProperty(name="height", measure="true")]
  
  /**
   * @alpha
   **/
  public class XYLayout extends Layout implements ILayout
  {
    override public function measure(children:Array):Point
    {
      var point:Point = new Point(0, 0);
      for each(var item:Object in children)
      {
        point.x = Math.max(point.x, item.x + Utility.resolve(<>ILayoutUtility.resolveWidth</>, item));
        point.y = Math.max(point.y, item.y + Utility.resolve(<>ILayoutUtility.resolveHeight</>, item));
      }
      
      return point;
    }
    
    override public function update(children:Array, rectangle:Rectangle):void
    {
    }
  }
}