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
  public class HorizontalLayout extends Layout implements ILayout
  {
    
    [Bindable]
    public var gap:Number = 5;
    
    override public function measure(children:Array):Point
    {
      super.measure(children);
      
      var point:Point = new Point(gap, 0);
      var width:Number, height:Number;
      
      for each(var child:Object in children)
      {
        width = Utility.resolve(<>ILayoutUtility.resolveWidth</>, child);
        height = Utility.resolve(<>ILayoutUtility.resolveHeight</>, child);
        point.x += width + gap;
        point.y = Math.max(point.y, height);
      }
      
      return point;
    }
    
    override public function update(children:Array, rectangle:Rectangle):void
    {
      super.update(children, rectangle);
      
      var position:Number = gap;
      var length:int = children.length;
      var child:Object, width:Number, height:Number;
      
      for(var i:int = 0; i < length; i++)
      {
        child = children[i];
        
        width = Utility.resolve(<>ILayoutUtility.resolveWidth</>, child);
        height = Utility.resolve(<>ILayoutUtility.resolveHeight</>, child);
        
        Utility.resolve(<>ILayoutUtility.setSize</>, child, width, height);
        Utility.resolve(<>ILayoutUtility.move</>, child, position, (rectangle.height - height) * 0.5);
        
        position += width + gap;
      }
    }
  
  }
}