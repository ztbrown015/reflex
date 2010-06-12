package reflex.layouts
{
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import reflex.layout.Align;
  import reflex.styles.resolveStyle;
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  
  [LayoutProperty(name="style.dock", measure="true")]
  [LayoutProperty(name="width", measure="true")]
  [LayoutProperty(name="height", measure="true")]
  public class DockLayout extends Layout implements ILayout
  {
    
    override public function measure(children:Array):Point
    {
      super.measure(children);
      var gap:Number = 5;
      var point:Point = new Point(gap, 0);
      for each(var child:Object in children)
      {
        var width:Number = Utility.resolve(<>ILayoutUtility.resolveWidth</>, child);
        var height:Number = Utility.resolve(<>ILayoutUtility.resolveHeight</>, child);
        point.x += width + gap;
        point.y = Math.max(point.y, height);
      }
      return point;
    }
    
    override public function update(children:Array, rectangle:Rectangle):void
    {
      super.update(children, rectangle);
      var length:int = children.length;
      for(var i:int = 0; i < length; i++)
      {
        var child:Object = children[i];
        var width:Number = Utility.resolve(<>ILayoutUtility.resolveWidth</>, child);
        var height:Number = Utility.resolve(<>ILayoutUtility.resolveHeight</>, child);
        var dock:String = reflex.styles.resolveStyle(child, "dock", Align.NONE) as String;
        var align:String = reflex.styles.resolveStyle(child, "align", Align.NONE) as String;
        switch(dock)
        {
          case Align.LEFT:
            child.x = rectangle.x;
            child.y = rectangle.y;
            if(align == Align.NONE)
            {
              child.setSize(width, rectangle.height);
            }
            else if(align == Align.BOTTOM)
            {
              child.y = rectangle.y + rectangle.height - height;
            }
            break;
          case Align.TOP:
            child.x = rectangle.x;
            child.y = rectangle.y;
            if(align == Align.NONE)
            {
              child.setSize(rectangle.width, height)
            }
            else if(align == Align.RIGHT)
            {
              child.x = rectangle.x + rectangle.width - width;
            }
            break;
          case Align.RIGHT:
            child.x = rectangle.x + rectangle.width - width;
            child.y = rectangle.y;
            if(align == Align.NONE)
            {
              child.setSize(width, rectangle.height);
            }
            else if(align == Align.BOTTOM)
            {
              child.y = rectangle.y + rectangle.height - height;
            }
            break;
          case Align.BOTTOM:
            child.x = rectangle.x;
            child.y = rectangle.y + rectangle.height - height;
            if(align == Align.NONE)
            {
              child.setSize(rectangle.width, height);
            }
            else if(align == Align.RIGHT)
            {
              child.x = rectangle.x + rectangle.width - width;
            }
            break;
          case Align.FILL:
            child.x = rectangle.x;
            child.y = rectangle.y;
            child.setSize(rectangle.width, rectangle.height)
            break;
          case Align.CENTER:
            child.x = rectangle.width / 2 - width / 2;
            child.y = rectangle.height / 2 - height / 2;
            break;
        }
      }
    }
  
  }
}