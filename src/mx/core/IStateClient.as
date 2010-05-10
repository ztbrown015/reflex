package mx.core
{
  public interface IStateClient
  {
    function get currentState():String;
    function set currentState(value:String):void;
  }
}