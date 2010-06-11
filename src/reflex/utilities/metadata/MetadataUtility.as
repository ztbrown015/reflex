package reflex.utilities.metadata
{
  import flash.events.IEventDispatcher;
  
  import flight.binding.Bind;
  import flight.utils.Type;

  public class MetadataUtility
  {
    /**
     * @experimental
     */
    public function resolveBindings(instance:IEventDispatcher):void
    {
      var desc:XMLList = Type.describeProperties(instance, "Binding");
      for each(var prop:XML in desc)
      {
        var meta:XMLList = prop.metadata.(@name == "Binding");
        
        // to support multiple Binding metadata tags on a single property
        for each(var tag:XML in meta)
        {
          var targ:String = (tag.arg.(@key == "target").length() > 0) ? (tag.arg.(@key == "target").@value) : (tag.arg.@value);
          
          Bind.addBinding(instance, targ, instance, prop.@name, true);
        }
      }
    }
    
    /**
     * @experimental
     */
    public function resolveCommitProperties(instance:IEventDispatcher):void
    {
      var desc:XMLList = Type.describeMethods(instance, "CommitProperties");
      for each(var meth:XML in desc)
      {
        var meta:XMLList = meth.metadata.(@name == "CommitProperties");
        
        // to support multiple PropertyListener metadata tags on a single method
        for each(var tag:XML in meta)
        {
          var targ:String = (tag.arg.(@key == "target").length() > 0) ?
            tag.arg.(@key == "target").@value :
            tag.arg.@value;
          
          Bind.addListener(instance, instance[meth.@name], instance, targ);
        }
      }
    }
    
    /**
     * @experimental
     */
    public function resolveEventListeners(instance:IEventDispatcher):void
    {
      var desc:XMLList = Type.describeMethods(instance, "EventListener");
      for each(var meth:XML in desc)
      {
        var meta:XMLList = meth.metadata.(@name == "EventListener");
        
        // to support multiple EventListener metadata tags on a single method
        for each(var tag:XML in meta)
        {
          var type:String = (tag.arg.(@key == "type").length() > 0) ?
            tag.arg.(@key == "type").@value :
            tag.arg.@value;
          var targ:String = tag.arg.(@key == "target").@value;
          
          Bind.bindEventListener(type, instance[meth.@name], instance, targ);
        }
      }
    }
    
    // this method of listening for layout invalidating changes is very much experimental
    /**
     * @experimental
     */
    public function resolveLayoutProperties(instance:IEventDispatcher, child:IEventDispatcher, listener:Function):void
    {
      var desc:XML = Type.describeType(instance);
      for each(var meth:XML in desc.factory[0])
      {
        var meta:XMLList = meth.metadata.(@name == "LayoutProperty");
        
        // to support multiple PropertyListener metadata tags on a single method
        for each(var tag:XML in meta)
        {
          var sourcePath:String = tag.arg.(@key == "name").@value;
          Bind.addListener(child, listener, child, sourcePath);
        }
      }
    }
    
    /**
     * @experimental
     */
    public function resolvePropertyListeners(instance:IEventDispatcher):void
    {
      var desc:XMLList = Type.describeMethods(instance, "PropertyListener");
      for each(var meth:XML in desc)
      {
        var meta:XMLList = meth.metadata.(@name == "PropertyListener");
        
        // to support multiple PropertyListener metadata tags on a single method
        for each(var tag:XML in meta)
        {
          var targ:String = (tag.arg.(@key == "target").length() > 0) ?
            tag.arg.(@key == "target").@value :
            tag.arg.@value;
          
          Bind.addListener(instance, instance[meth.@name], instance, targ);
        }
      }
    }
  }
}