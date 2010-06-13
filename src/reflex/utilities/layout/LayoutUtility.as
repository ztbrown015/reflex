package reflex.utilities.layout
{
  import flash.display.DisplayObjectContainer;
  
  import reflex.display.IContainer;
  import reflex.display.IMeasurable;
  import reflex.display.IMovable;

  public class LayoutUtility implements ILayoutUtility
  {
    public function getChildren(object:Object):Array
    {
      var children:Array = []
        
      if(object is IContainer)
        children = IContainer(object).children;
      else if(object is DisplayObjectContainer)
      {
        var index:int = -1;
        var numChildren:int = DisplayObjectContainer(object).numChildren;
        while(index < numChildren)
          children.push(DisplayObjectContainer(object).getChildAt(++index));
      }
      
      return children;
    }
    
    public function getWidth(object:Object):Number
    {
      if(object && 'width' in object)
        return object['width'];
      
      return NaN;
    }
    
    public function getHeight(object:Object):Number
    {
      if(object && 'height' in object)
        return object['height'];
      
      return NaN;
    }
    
    public function getPercentWidth(object:Object, total:Number = 0):Number
    {
      if(object && 'percentWidth' in object && total > 0)
        return object['percentWidth'] * .01 * total;
      else if(total == 0)
        return object['percentWidth'];
      
      return NaN;
    }
    
    public function getPercentHeight(object:Object, total:Number = 0):Number
    {
      if(object && 'percentHeight' in object && total > 0)
        return object['percentHeight'] * .01 * total;
      else if(total == 0)
        return object['percentHeight'];
      
      return NaN;
    }
    
    public function getX(object:Object):Number
    {
      if(object && 'x' in object)
        return object['x'];
      
      return NaN;
    }
    
    public function getY(object:Object):Number
    {
      if(object && 'y' in object)
        return object['y'];
      
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