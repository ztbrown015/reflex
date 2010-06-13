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
      var point:Point = super.measure(children);
      
      for each(var item:Object in children)
      {
        point.x = Math.max(point.x, Utility.resolve(<>ILayoutUtility.getX</>, item) + Utility.resolve(<>ILayoutUtility.getWidth</>, item));
        point.y = Math.max(point.y, Utility.resolve(<>ILayoutUtility.getY</>, item) + Utility.resolve(<>ILayoutUtility.getHeight</>, item));
      }
      
      return point;
    }
    
    override public function update(children:Array):void
    {
      super.update(children);
      
      var rectangle:Rectangle = new Rectangle(target.x, target.y, target.width, target.height);
      
      var index:int = 0;
      var length:int = children.length;
      var child:Object;
      
      for(; index < length; index++)
      {
        child = children[index];
        
        Utility.resolve(<>ILayoutUtility.move</>,
                        child,
                        Utility.resolve(<>ILayoutUtility.getX</>, child),
                        Utility.resolve(<>ILayoutUtility.getY</>, child));
      }
    }
  }
}