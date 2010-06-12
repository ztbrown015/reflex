package reflex.layouts
{
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import reflex.styles.hasStyle;
  import reflex.styles.resolveStyle;
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  
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
        xp = item.x + Utility.resolve(<>ILayoutUtility.resolveWidth</>, item);
        yp = item.y + Utility.resolve(<>ILayoutUtility.resolveHeight</>, item);
        if(!isNaN(xp))
          point.x = Math.max(point.x, xp);
        if(!isNaN(yp))
          point.y = Math.max(point.y, yp);
      }
      return point;
    }
    
    override public function update(children:Array, rectangle:Rectangle):void
    {
      super.update(children, rectangle);
      
      var width:Number = 0;
      var height:Number = 0;
      var left:Number = 0;
      var right:Number = 0;
      var top:Number = 0;
      var bottom:Number = 0;
      var horizontalCenter:Number = 0;
      var verticalCenter:Number = 0;
      
      for each(var child:Object in children)
      {
        width = Utility.resolve(<>ILayoutUtility.resolveWidth</>, child);
        height = Utility.resolve(<>ILayoutUtility.resolveHeight</>, child);
        left = resolveStyle(child, "left") as Number;
        right = resolveStyle(child, "right") as Number;
        top = resolveStyle(child, "top") as Number;
        bottom = resolveStyle(child, "bottom") as Number;
        horizontalCenter = resolveStyle(child, "horizontalCenter") as Number;
        verticalCenter = resolveStyle(child, "verticalCenter") as Number;
        
        if(hasStyle(child, "left") && hasStyle(child, "right"))
        {
          child.x = left;
          width = rectangle.width - child.x - right;
        }
        else if(hasStyle(child, "left"))
        {
          child.x = resolveStyle(child, "left") as Number;
        }
        else if(hasStyle(child, "right"))
        {
          child.x = rectangle.width - width - right;
        }
        else if(hasStyle(child, "horizontalCenter"))
        {
          child.x = rectangle.width / 2 - width / 2;
        }
        
        if(hasStyle(child, "top") && hasStyle(child, "bottom"))
        {
          child.y = top;
          height = rectangle.height - child.y - bottom;
        }
        else if(hasStyle(child, "top"))
        {
          child.y = top;
        }
        else if(hasStyle(child, "bottom"))
        {
          child.y = rectangle.height - height - bottom;
        }
        else if(hasStyle(child, "verticalCenter"))
        {
          child.y = rectangle.height / 2 - height / 2;
        }
        
        Utility.resolve(<>ILayoutUtility.setSize</>, child, width, height);
      }
    }
  
  }
}