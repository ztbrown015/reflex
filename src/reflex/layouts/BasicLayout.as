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
    
    override public function update(children:Array):void
    {
      super.update(children);
      
      if(!children || children.length == 0)
        return;
      
      var dimensions:Point = new Point(target.width, target.height);
      
      var child:Object;
      var width:Number = 0;
      var height:Number = 0;
      var x:Number = 0;
      var y:Number = 0;
      
      var left:*;
      var right:*;
      var top:*;
      var bottom:*;
      var horizontalCenter:*;
      var verticalCenter:*;
      
      var index:int = 0;
      var length:int = children.length;
      
      for(; index < length; index++)
      {
        child = children[index];
        
        width = Utility.resolve(<>ILayoutUtility.getWidth</>, child);
        height = Utility.resolve(<>ILayoutUtility.getHeight</>, child);
        
        left = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'left'));
        right = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'right'));
        top = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'top'));
        bottom = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'bottom'));
        
        horizontalCenter = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'horizontalCenter'));
        verticalCenter = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'verticalCenter'));
        
        if(!isNaN(left) && !isNaN(right))
        {
          x = left;
          width = dimensions.x - x - right;
        }
        else if(!isNaN(left))
          x = Utility.resolve(<>IStyleUtility.getStyle</>, child, 'left') as Number;
        else if(!isNaN(right))
          x = dimensions.x - width - right;
        else if(!isNaN(horizontalCenter))
          x = ((dimensions.x - width) * 0.5) + horizontalCenter;
        
        if(!isNaN(top) && !isNaN(bottom))
        {
          y = top;
          height = dimensions.y - y - bottom;
        }
        else if(!isNaN(top))
          y = top;
        else if(!isNaN(bottom))
          y = dimensions.y - height - bottom;
        else if(!isNaN(verticalCenter))
          y = ((dimensions.y - height) * 0.5) + verticalCenter;
        
        Utility.resolve(<>ILayoutUtility.setSize</>, child, width, height);
        Utility.resolve(<>ILayoutUtility.move</>, child, x, y);
      }
    }
  
  }
}