package reflex.utilities.states
{
  import mx.core.IStateClient2;

  public interface IStateUtility
  {
    function change(client:IStateClient2, from:String, to:String):void
  }
}