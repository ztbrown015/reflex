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
  public class VerticalLayout extends Layout
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
          styleUtil.getStyle(child, 'marginLeft') || 0,
          styleUtil.getStyle(child, 'marginRight') || 0,
          styleUtil.getStyle(child, 'marginTop') || 0,
          styleUtil.getStyle(child, 'marginBottom') || 0
          );
        
        width = layoutUtil.getWidth(child);
        height = layoutUtil.getHeight(child);
        point.x = Math.max(point.x, width + margin.left + margin.right);
        point.y += height + gap + margin.top + margin.bottom;
      }
      
      return point;
    }
    
    override protected function getLayoutSpace(dimension:String, withPadding:Boolean = false, usedSpace:Number = 0, numChildren:int = 0):Number
    {
      if(dimension != 'y')
        return super.getLayoutSpace(dimension, withPadding, usedSpace, numChildren);
      
      return target.height -
        //  Subtract the amount that the gap takes up.
        (getStyle('gap') * (Math.max(numChildren, 1) - 1)) -
        //  Subtract out the padding, if specified.
        (withPadding ? padding.top + padding.bottom : 0)
        //  Subtract out the used space.
        - usedSpace;
    }
    
    override protected function getSpacePerCent(totalSpace:Number, totalPercent:Number, dimension:String):Number
    {
      if(dimension != 'x')
        return super.getSpacePerCent(totalSpace, totalPercent, dimension);
      
      return totalSpace * .01;
    }
    
    override protected function getLayoutPosition(child:Object, dimension:String, currentPosition:Number):Number
    {
      if(dimension == 'y')
      {
        return currentPosition + getMargin(child, dimension, -1);
      }
      if(dimension == 'x')
      {
        var layoutWidth:Number = getLayoutSpace(dimension);
        var childWidth:Number = getChildSpace(child, dimension);
        var alignment:Number = getAlignment(child, dimension);
        alignment = isNaN(alignment) ? getAlignment(this, dimension) || 0 : alignment;
        
        return padding.left + getMargin(child, dimension, -1) + ((layoutWidth - childWidth - padding.left - padding.right) * alignment);
      }
      
      return NaN;
    }
    
    override protected function updateLayoutPosition(child:Object, dimension:String, currentPosition:Number):Number
    {
      if(dimension != 'y')
        return super.updateLayoutPosition(child, dimension, currentPosition);
      
      return currentPosition + getStyle('gap') + getChildSpace(child, dimension) + getMargin(child, dimension);
    }
  }
}