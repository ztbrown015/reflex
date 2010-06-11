package reflex.utilities.invalidation
{
  import flash.display.DisplayObject;
  
  import reflex.utilities.Utility;
  import reflex.utilities.oneShot;

  public class Phases
  {
    protected static function invalidate(phase:String, caller:DisplayObject, callback:Function = null):void
    {
      if(Utility.resolve(<>IInvalidationUtility.invalidate</>, caller, phase))
        if(callback != null)
          caller.addEventListener(phase, oneShot(callback, caller));
    }
  }
}