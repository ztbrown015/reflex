package reflex.layouts
{
  import flash.geom.Point;
  
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  
  [LayoutProperty(name="width", measure="true")]
  [LayoutProperty(name="height", measure="true")]
  
  /**
   * @alpha
   **/
  public class VerticalLayout extends AlgorithmicLayout
  {
    override public function measure(children:Array):Point
    {
      super.measure(children);
      
      if(!children || children.length == 0)
        return super.measure(children);
      
      var width:Number, height:Number;
      var vGap:Number = getStyle('vGap');
      var point:Point = new Point(vGap, 0);
      
      for each(var child:Object in children)
      {
        width = Utility.resolve(<>ILayoutUtility.getWidth</>, child);
        height = Utility.resolve(<>ILayoutUtility.getHeight</>, child);
        point.x = Math.max(point.x, width);
        point.y += height + vGap;
      }
      
      return point;
    }
    
    override protected function algorithm(children:Array, index:int, position:Number):Number
    {
      var child:Object = children[index];
      var width:Number = Utility.resolve(<>ILayoutUtility.getWidth</>, child);
      var height:Number = Utility.resolve(<>ILayoutUtility.getHeight</>, child);
      
      var dimensions:Point = getDimensions(null, false, children);
      var x:Number = (dimensions.x - width) * horizontalAlign;
      
      Utility.resolve(<>ILayoutUtility.move</>, child, padding.left + x, position);
      
      return position + height + getStyle('vGap');
    }
    
    override protected function getDimensions(usedSpace:Point = null, withPadding:Boolean = true, children:Array = null):Point
    {
      if(!target)
        return new Point();
      
      if(!usedSpace)
        usedSpace = new Point();
      
      var gapSpace:Number = getStyle('vGap') * (children && children.length ? children.length - 1 : 0);
      
      if(withPadding)
        return new Point(target.width - padding.left - padding.right,
                         target.height - padding.top - padding.bottom - gapSpace).subtract(usedSpace);
      else
        return new Point(target.width, target.height).subtract(usedSpace);
    }
    
    override protected function getPercentRatio(total:Point, numChildren:Number):Point
    {
      total.y /= (numChildren * 2);
      total.y *= .01;
      total.x = 1;
      
      return total;
    }
  }
}