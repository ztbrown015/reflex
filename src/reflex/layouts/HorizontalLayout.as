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
        point.x += width + gap + margin.left + margin.right;
        point.y = Math.max(point.y, height + margin.top + margin.bottom);
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
        position += excessSpace.x * getHorizontalAlign(this);
      
      var margin:Padding = new Padding(
        Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginLeft') || 0,
        Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginRight') || 0,
        Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginTop') || 0
        // ignore marginBottom since it's not used in these calculations.
        );
      
      var y:Number = padding.top + margin.top + ((dimensions.y - height) * getVerticalAlign(this));
      
      Utility.resolve(<>ILayoutUtility.move</>, child, 
        position + margin.left, 
        y + ((dimensions.y - height - y - padding.bottom) * getVerticalAlign(child)));
      
      return position + getStyle('gap') + width + margin.left + margin.right;
    }
    
    override protected function getDimensions(children:Array = null, withPadding:Boolean = true, usedSpace:Point = null):Point
    {
      if(!target)
        return new Point();
      
      if(!usedSpace)
        usedSpace = new Point()
      
      var gapSpace:Number = getStyle('gap') * (children && children.length ? children.length - 1 : 0);
      
      var size:Point = new Point(target.width - gapSpace, target.height);
      
      if(withPadding)
        size = new Point(target.width - gapSpace - padding.left - padding.right, target.height - padding.top - padding.bottom);
      
      return new Point(Math.min(size.x, size.x - usedSpace.x), size.y);
    }
    
    override protected function getSpacePercent(totalSpace:Point, totalPercent:Point):Point
    {
      return new Point(totalSpace.x / totalPercent.x, totalSpace.y * .01);
    }
  }
}