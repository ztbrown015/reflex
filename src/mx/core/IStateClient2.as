package mx.core
{
  import flash.events.IEventDispatcher;
  
  public interface IStateClient2 extends IEventDispatcher, IStateClient
  {
    function get states():Array;
    function set states(value:Array):void;
    
    function get transitions():Array;
    function set transitions(value:Array):void;
    
    function hasState(state:String):Boolean;
  }
}