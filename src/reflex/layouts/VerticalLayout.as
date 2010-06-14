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
  public class VerticalLayout extends AlgorithmicLayout
  {
    override public function measure(children:Array):Point
    {
      super.measure(children);
      
      if(!children || children.length == 0)
        return super.measure(children);
      
      var width:Number, height:Number;
      var gap:Number = getStyle('gap');
      var point:Point = new Point();
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
        point.x = Math.max(point.x, width + margin.left + margin.right);
        point.y += height + gap + margin.top + margin.bottom;
      }
      
      return point;
    }
    
    override protected function algorithm(children:Array, index:int, position:Number):Number
    {
      var child:Object = children[index];
      var width:Number = Utility.resolve(<>ILayoutUtility.getWidth</>, child);
      var height:Number = Utility.resolve(<>ILayoutUtility.getHeight</>, child);
      
      var dimensions:Point = getDimensions(children, true);
      
      if(index == 0)
        position += excessSpace.y * getVerticalAlign(this);
      
      var margin:Padding = new Padding(
        Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginLeft') || 0,
        0, // ignore marginRight since it's not used in these calculations.
        Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginTop') || 0,
        Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginBottom') || 0
        );
      
      var x:Number = padding.left + margin.left + ((dimensions.x - width) * getHorizontalAlign(this));
      
      Utility.resolve(<>ILayoutUtility.move</>, child, 
        x + ((dimensions.x - width - x - padding.right) * getHorizontalAlign(child)), 
        position + margin.top);
      
//      return position + getStyle('gap') + width + margin.left + margin.right;
      return position + getStyle('gap') + height + margin.top + margin.bottom;
    }
    
    override protected function getDimensions(children:Array = null, withPadding:Boolean = true, usedSpace:Point = null):Point
    {
      if(!target)
        return new Point();
      
      if(!usedSpace)
        usedSpace = new Point()
      
      var gapSpace:Number = getStyle('gap') * (children && children.length ? children.length - 1 : 0);
      
      var size:Point = new Point(target.width, target.height - gapSpace);
      
      if(withPadding)
        size = new Point(target.width - padding.left - padding.right, target.height - gapSpace - padding.top - padding.bottom);
      
      return new Point(size.x, Math.min(size.y, size.y - usedSpace.y));
    }
    
    override protected function getSpacePercent(totalSpace:Point, totalPercent:Point):Point
    {
      return new Point(totalSpace.x * .01, totalSpace.y / totalPercent.y);
    }
  }
}