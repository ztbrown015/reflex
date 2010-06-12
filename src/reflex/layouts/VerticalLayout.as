package reflex.layouts
{
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  
  [LayoutProperty(name="width", measure="true")]
  [LayoutProperty(name="height", measure="true")]
  
  /**
   * @alpha
   **/
  public class VerticalLayout extends Layout implements ILayout
  {
    
    [Bindable]
    public var gap:Number = 5;
    
    override public function measure(children:Array):Point
    {
      super.measure(children);
      var point:Point = new Point(gap, 0);
      for each(var child:Object in children)
      {
        
        var width:Number = Utility.resolve(<>ILayoutUtility.resolveWidth</>, child);
        var height:Number = Utility.resolve(<>ILayoutUtility.resolveHeight</>, child);
        point.x = Math.max(point.x, width);
        point.y += height + gap;
      }
      return point;
    }
    
    override public function update(children:Array, rectangle:Rectangle):void
    {
      super.update(children, rectangle);
      if(children)
      {
        var position:Number = gap;
        var length:int = children.length;
        for(var i:int = 0; i < length; i++)
        {
          var child:Object = children[i];
          var width:Number = Utility.resolve(<>ILayoutUtility.resolveWidth</>, child);
          var height:Number = Utility.resolve(<>ILayoutUtility.resolveHeight</>, child);
          child.x = rectangle.width / 2 - width / 2;
          child.y = position;
          position += height + gap;
        }
      }
    }
  
  }
}