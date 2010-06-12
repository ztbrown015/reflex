package reflex.utilities.layout
{
  import reflex.display.IMeasurable;
  import reflex.display.IMovable;

  public class LayoutUtility implements ILayoutUtility
  {
    public function LayoutUtility()
    {
    }
    
    public function resolveWidth(object:Object):Number
    {
      if(object && 'width' in object)
        return object['width'];
      
      return NaN;
    }
    
    public function resolveHeight(object:Object):Number
    {
      if(object && 'height' in object)
        return object['height'];
      
      return NaN;
    }
    
    public function setSize(object:Object, newWidth:Number, newHeight:Number):void
    {
      if(object is IMeasurable)
      {
        IMeasurable(object).setSize(newWidth, newHeight);
      }
      else
      {
        if('width' in object)
          object['width'] = newWidth;
        if('height' in object)
          object['height'] = newHeight;
      }
    }
    
    public function move(object:Object, x:Number, y:Number):void
    {
      if(object is IMovable)
      {
        IMovable(object).move(x, y);
      }
      else
      {
        if('x' in object)
          object['x'] = x;
        if('y' in object)
          object['y'] = y;
      }
    }
  }
}