package mx.core
{
  import flash.events.IEventDispatcher;
  
  public interface IStateClient2 extends IEventDispatcher, IStateClient
  {
    function get states():Array;
    function set states(value:Array):void;
  }
}