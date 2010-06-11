package reflex.utilities.invalidation
{
  import flash.display.DisplayObject;

  public interface IInvalidationUtility
  {
    function registerPhase(phase:String, priority:int = 0, ascending:Boolean = true):void;
    function invalidate(element:DisplayObject, phase:String):Boolean;
    function render():void;
  }
}