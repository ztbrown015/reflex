package reflex.layouts
{
  /**
  * Virtual is a collection of Dimensions.
  * @author Paul Taylor (http://guyinthechair.com).
  */
  public class Virtual
  {
    public function Virtual(... dimensions)
    {
      for each(var dimension:String in dimensions)
        addDimension(dimension);
    }
    
    protected var dimensions:Object = {};
    
    public function add(item:*, size:Number, dimension:String):*
    {
      if(!(dimension in dimensions))
        addDimension(dimension);
      
      return Dimension(dimensions[dimension]).add(item, size);
    }
    
    public function addAt(item:*, position:Number, size:Number, dimension:String):*
    {
      if(!(dimension in dimensions))
        addDimension(dimension);
      
      return Dimension(dimensions[dimension]).addAt(item, position, size);
    }
    
    public function addDimension(name:String):Dimension
    {
      if(hasDimension(name))
        return Dimension(dimensions[name]);
      
      _size++;
      
      return Dimension(dimensions[name] = new Dimension());
    }
    
    public function remove(item:*, dimension:String):*
    {
      if(!!hasDimension(dimension))
        return item;
      
      return Dimension(dimensions[dimension]).remove(item);
    }
    
    public function removeDimension(name:String):Dimension
    {
      if(!hasDimension(name))
        return null;
      
      var dimension:Dimension = dimensions[name];
      dimension.clear();
      
      delete dimensions[name];
      
      return dimension;
    }
    
    public function updateSize(item:*, size:Number, dimension:String):*
    {
      if(!hasDimension(dimension))
        return item;
      
      return Dimension(dimensions[dimension]).updateSize(item, size);
    }
    
    public function updatePosition(item:*, dimension:String, position:Number):*
    {
      if(!hasDimension(dimension))
        return item;
      
      return Dimension(dimensions[dimension]).addAt(item, position);
    }
    
    public function getItemsAt(begin:Number, end:Number, dimension:String):Array
    {
      if(!hasDimension(dimension))
        return [];
      
      return Dimension(dimensions[dimension]).getItemsAt(begin, end);
    }
    
    public function hasDimension(dimension:String):Boolean
    {
      return (dimension in dimensions);
    }
    
    public function hasItem(item:*, dimension:String):Boolean
    {
      if(!hasDimension(dimension))
        return false;
      
      return Dimension(dimensions[dimension]).hasItem(item);
    }
    
    public function clear():void
    {
      for(var name:String in dimensions)
      {
        if(!dimensions[name])
          continue;
        
        Dimension(dimensions[name]).clear();
        delete dimensions[name];
      }
      
      dimensions = {};
    }
    
    public function get dimensionNames():Object
    {
      var names:Object = {};
      for(var name:String in dimensions)
        names[name] = name;
      
      return names;
    }
    
    protected var _size:Number = 0;
    
    public function get size():Number
    {
      return _size;
    }
  }
}