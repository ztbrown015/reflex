package reflex.layouts
{
  import flash.events.IEventDispatcher;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import flight.binding.Bind;
  
  import reflex.measurement.resolveHeight;
  import reflex.measurement.resolveWidth;
  
  [LayoutProperty(name="x", measure="true")]
  [LayoutProperty(name="y", measure="true")]
  [LayoutProperty(name="width", measure="true")]
  [LayoutProperty(name="height", measure="true")]
  
  /**
   * @alpha
   **/
  public class XYLayout extends Layout implements ILayout
  {
    override public function measure(children:Array):Point
    {
      var point:Point = new Point(0, 0);
      for each(var item:Object in children)
      {
        point.x = Math.max(point.x, item.x + resolveWidth(item));
        point.y = Math.max(point.y, item.y + resolveHeight(item));
      }
      //attachBindings(children);
      return point;
    }
    
    override public function update(children:Array, rectangle:Rectangle):void
    {
      attachBindings(children);
    }
    
    // update this for correct binding
    // find the easiest Flash/AS3 option (add metadata functionality as well)
    private function attachBindings(children:Array):void
    {
      for each(var child:IEventDispatcher in children)
      {
        Bind.addListener(child, invalidateSize, child, "x");
        Bind.addListener(child, invalidateSize, child, "y");
        Bind.addListener(child, invalidateSize, child, "width");
        Bind.addListener(child, invalidateSize, child, "height");
        Bind.addListener(child, invalidateSize, child, "measurements");
        Bind.addListener(child, invalidateSize, child, "layout");
      }
    }
  }
}