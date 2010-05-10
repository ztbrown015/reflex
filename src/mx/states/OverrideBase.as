package mx.states
{
  import flash.events.EventDispatcher;

  public class OverrideBase extends EventDispatcher
  {
    public function OverrideBase()
    {
    }
    
    /**
     * @private 
     * Initialize this object from a descriptor.
     */
    public function initializeFromObject(properties:Object):Object
    {
      for (var p:String in properties)
      {
        this[p] = properties[p];
      }
      
      return Object(this);
    }
    
    /**
     * @private
     * @param parent The document level context for this override.
     * @param target The component level context for this override.
     */
    protected function getOverrideContext(target:Object, parent:Object):Object
    {
      if (target == null)
        return parent;
      
      if (target is String)
        return parent[target];
      
      return target;
    }
  }
}