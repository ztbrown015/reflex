package reflex.utilities.metadata
{
  import flash.events.IEventDispatcher;

  public interface IMetadataUtility
  {
    function resolveBindings(instance:IEventDispatcher):void;
    function resolveCommitProperties(instance:IEventDispatcher):void;
    function resolveEventListeners(instance:IEventDispatcher):void;
    function resolveLayoutProperties(instance:IEventDispatcher, child:IEventDispatcher, listener:Function):void;
    function resolvePropertyListeners(instance:IEventDispatcher):void;
  }
}