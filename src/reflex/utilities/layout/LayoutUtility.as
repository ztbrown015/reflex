package reflex.utilities.layout
{
  import flash.display.DisplayObjectContainer;
  
  import reflex.display.IContainer;
  import reflex.display.IMeasurable;
  import reflex.display.IMovable;
  
  use namespace rx_internal;
  
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
      if(!object)
        return NaN;
      
      if('width' in object)
        return object['width'];
      
      return NaN;
    }
    
    public function setWidth(object:Object, value:Number):void
    {
      if(!object)
        return;
      
      if('width' in object)
        object['width'] = value;
    }
    
    public function getHeight(object:Object):Number
    {
      if(!object)
        return NaN;
      
      if('height' in object)
        return object['height'];
      
      return NaN;
    }
    
    public function setHeight(object:Object, value:Number):void
    {
      if(!object)
        return;
      
      if('height' in object)
        object['height'] = value;
    }
    
    public function getPercentWidth(object:Object, total:Number = 0):Number
    {
      if(!object)
        return NaN;
      
      if('percentWidth' in object)
        return total > 0 ? object['percentWidth'] * total : object['percentWidth'];
      
      return NaN;
    }
    
    public function getPercentHeight(object:Object, total:Number = 0):Number
    {
      if(!object)
        return NaN;
      
      if('percentHeight' in object)
        return total > 0 ? object['percentHeight'] * total : object['percentHeight'];
      
      return NaN;
    }
    
    public function getX(object:Object):Number
    {
      if(!object)
        return NaN;
      
      if('x' in object)
        return object['x'];
      
      return NaN;
    }
    
    public function setX(object:Object, value:Number):void
    {
      if(!object)
        return;
      
      if('x' in object)
        object['x'] = value;
    }
    
    public function getY(object:Object):Number
    {
      if(object && 'y' in object)
        return object['y'];
      
      return NaN;
    }
    
    public function setY(object:Object, value:Number):void
    {
      if(object && 'y' in object)
        object['y'] = value;
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