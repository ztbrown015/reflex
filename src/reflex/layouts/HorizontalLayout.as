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
  public class HorizontalLayout extends AlgorithmicLayout
  {
    override public function measure(children:Array):Point
    {
      super.measure(children);
      
      if(!children || children.length == 0)
        return super.measure(children);
      
      var width:Number, height:Number;
      var hGap:Number = getStyle('hGap');
      var point:Point = new Point(hGap, 0);
      
      for each(var child:Object in children)
      {
        width = Utility.resolve(<>ILayoutUtility.getWidth</>, child);
        height = Utility.resolve(<>ILayoutUtility.getHeight</>, child);
        point.x += width + hGap;
        point.y = Math.max(point.y, height);
      }
      
      return point;
    }
    
    override protected function algorithm(children:Array, index:int, position:Number):Number
    {
      var child:Object = children[index];
      var width:Number = Utility.resolve(<>ILayoutUtility.getWidth</>, child);
      var height:Number = Utility.resolve(<>ILayoutUtility.getHeight</>, child);
      
      var dimensions:Point = getDimensions(null, false, children);
      var y:Number = (dimensions.y - height) * verticalAlign;
      
      Utility.resolve(<>ILayoutUtility.move</>, child, position, padding.top + y);
      
      return position + width + getStyle('hGap');
    }
    
    override protected function getDimensions(usedSpace:Point = null, withPadding:Boolean = true, children:Array = null):Point
    {
      if(!target)
        return new Point();
      
      if(!usedSpace)
        usedSpace = new Point();
      
      var gapSpace:Number = getStyle('hGap') * (children && children.length ? children.length - 1 : 0);
      
      if(withPadding)
        return new Point(target.width - padding.left - padding.right - gapSpace,
                         target.height - padding.top - padding.bottom).subtract(usedSpace);
      else
        return new Point(target.width, target.height).subtract(usedSpace);
    }
    
    override protected function getPercentRatio(total:Point, numChildren:Number):Point
    {
      total.x /= (numChildren * 2);
      total.x *= .01;
      total.y = 1;
      
      return total;
    }
  }
}