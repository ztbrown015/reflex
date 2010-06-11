package reflex.utilities
{
  import flash.display.DisplayObject;

  public interface IInvalidationUtility
  {
    function registerPhase(phase:String, priority:int = 0, ascending:Boolean = true):void;
    function invalidate(element:DisplayObject, phase:String):void;
    function render():void;
  }
}