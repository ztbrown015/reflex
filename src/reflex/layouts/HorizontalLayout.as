package reflex.layouts
{
  import flash.geom.Point;
  
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  import reflex.utilities.styles.IStyleUtility;
  
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
      var margin:Padding;
      
      for each(var child:Object in children)
      {
        margin = new Padding(
          Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginLeft') || 0,
          Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginRight') || 0,
          Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginTop') || 0,
          Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginBottom') || 0
          );
        width = Utility.resolve(<>ILayoutUtility.getWidth</>, child);
        height = Utility.resolve(<>ILayoutUtility.getHeight</>, child);
        point.x += width + hGap + margin.left + margin.right;
        point.y = Math.max(point.y, height + margin.top + margin.bottom);
      }
      
      return point;
    }
    
    override protected function algorithm(children:Array, index:int, position:Number):Number
    {
      var child:Object = children[index];
      var width:Number = Utility.resolve(<>ILayoutUtility.getWidth</>, child);
      var height:Number = Utility.resolve(<>ILayoutUtility.getHeight</>, child);
      
      var dimensions:Point = getDimensions(null, false, children);
      var margin:Padding = new Padding(
        Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginLeft') || 0,
        Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginRight') || 0,
        Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginTop') || 0
        );
      var y:Number = ((dimensions.y - height) * verticalAlign) + margin.top;
      
      Utility.resolve(<>ILayoutUtility.move</>, child, position + margin.left, padding.top + y);
      
      return position + width + getStyle('hGap') + margin.right;
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