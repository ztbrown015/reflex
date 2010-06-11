package reflex.text
{
  import flash.display.DisplayObject;
  
  import reflex.utilities.Utility;
  import reflex.utilities.invalidation.IInvalidationUtility;
  import reflex.utilities.invalidation.Phases;
  import reflex.utilities.oneShot;

  public class TextPhases extends Phases
  {
    public static const TEXT_PHASES:String = "notify";
    Utility.resolve(<>IInvalidationUtility.registerPhase</>, TEXT_PHASES, 190, false);
    
    public static function invalidateText(caller:DisplayObject, callback:Function = null):void
    {
      invalidate(TEXT_PHASES, caller, callback);
    }
  }
}