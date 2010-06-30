package reflex.layouts
{
  import flash.geom.Point;
  
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  import reflex.utilities.styles.IStyleUtility;
  
  [LayoutProperty(name="style.left", measure="true")]
  [LayoutProperty(name="style.right", measure="true")]
  [LayoutProperty(name="style.top", measure="true")]
  [LayoutProperty(name="style.bottom", measure="true")]
  [LayoutProperty(name="style.horizontalCenter", measure="true")]
  [LayoutProperty(name="style.verticalCenter", measure="true")]
  [LayoutProperty(name="width", measure="true")]
  [LayoutProperty(name="height", measure="true")]
  
  /**
   * @alpha
   **/
  public class BasicLayout extends Layout implements ILayout
  {
    override public function measure(children:Array):Point
    {
      super.measure(children);
      
      var point:Point = new Point(0, 0);
      var xp:Number, yp:Number;
      
      for each(var item:Object in children)
      {
        xp = Utility.resolve(<>ILayoutUtility.getX</>, item) + Utility.resolve(<>ILayoutUtility.getWidth</>, item);
        yp = Utility.resolve(<>ILayoutUtility.getY</>, item) + Utility.resolve(<>ILayoutUtility.getHeight</>, item);
        
        if(!isNaN(xp))
          point.x = Math.max(point.x, xp);
        if(!isNaN(yp))
          point.y = Math.max(point.y, yp);
      }
      
      return point;
    }
    
    override protected function getLayoutPosition(child:Object, dimension:String, currentPosition:Number):Number
    {
      var childSpace:Number = getChildSpace(child, dimension);
      var layoutSpace:Number = getLayoutSpace(dimension);
      var styleUtil:IStyleUtility = Utility.getUtility(IStyleUtility) as IStyleUtility;
      
      if(dimension == 'x')
      {
        var left:Number = 0;
        var right:Number = 0;
        var horizontalCenter:Number = 0;
        
        if(styleUtil)
        {
          left = parseFloat(styleUtil.getStyle(child, 'left'));
          right = parseFloat(styleUtil.getStyle(child, 'right'));
          horizontalCenter = parseFloat(styleUtil.getStyle(child, 'horizontalCenter'));
        }
        
        if(!isNaN(left))
          return left;
        if(!isNaN(right))
          return layoutSpace - childSpace - right;
        if(!isNaN(horizontalCenter))
          return ((layoutSpace - childSpace) * 0.5) + horizontalCenter;
      }
      if(dimension == 'y')
      {
        var top:Number = 0;
        var bottom:Number = 0;
        var verticalCenter:Number = 0;
        
        if(styleUtil)
        {
          top = parseFloat(styleUtil.getStyle(child, 'top'));
          bottom = parseFloat(styleUtil.getStyle(child, 'bottom'));
          verticalCenter = parseFloat(styleUtil.getStyle(child, 'verticalCenter'));
        }
        
        if(!isNaN(top))
          return top;
        if(!isNaN(bottom))
          return layoutSpace - childSpace - bottom;
        if(!isNaN(verticalCenter))
          return ((layoutSpace - childSpace) * 0.5) + verticalCenter;
      }
      
      return 0;
    }
    
    override protected function getChildSpace(child:Object, dimension:String):Number
    {
      var layoutSpace:Number = getLayoutSpace(dimension);
      var styleUtil:IStyleUtility = Utility.getUtility(IStyleUtility) as IStyleUtility;
      
      if(dimension == 'x')
      {
        var left:Number;
        var right:Number;
        if(styleUtil)
        {
          left = parseFloat(styleUtil.getStyle(child, 'left'));
          right = parseFloat(styleUtil.getStyle(child, 'right'));
        }
        
        if(!isNaN(left) && !isNaN(right))
          return layoutSpace - left - right;
        
        return super.getChildSpace(child, dimension);
      }
      if(dimension == 'y')
      {
        var top:Number;
        var bottom:Number;
        if(styleUtil)
        {
          top = parseFloat(styleUtil.getStyle(child, 'top'));
          bottom = parseFloat(styleUtil.getStyle(child, 'bottom'));
        }
        
        if(!isNaN(top) && !isNaN(bottom))
          return layoutSpace - top - bottom;
        
        return super.getChildSpace(child, dimension);
      }
      
      return 0;
    }
    
    override protected function getSpacePerCent(totalSpace:Number, totalPercent:Number, dimension:String):Number
    {
      return totalSpace / 100;
    }
    
    override protected function getLayoutSpace(dimension:String, withPadding:Boolean=false, usedSpace:Number=0, numChildren:int=0):Number
    {
      var size:Number = 0;
      
      if(dimension == 'x')
        size = target.width - (withPadding ? padding.left + padding.right : 0);
      else if(dimension == 'y')
        size = target.height - (withPadding ? padding.top + padding.bottom : 0);
      
      return size;
    }
  }
}