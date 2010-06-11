package reflex.display
{
  import flash.display.DisplayObject;
  
  import reflex.utilities.Utility;
  import reflex.utilities.invalidation.IInvalidationUtility;
  import reflex.utilities.invalidation.Phases;
  import reflex.utilities.oneShot;

  public class DisplayPhases extends Phases
  {
    public static const NOTIFY:String = "notify";
    public static const CHILDREN:String = "children";
    public static const MEASURE:String = "measure";
    public static const LAYOUT:String = "layout";
    
    Utility.resolve(<>IInvalidationUtility.registerPhase</>, NOTIFY, 0);
    Utility.resolve(<>IInvalidationUtility.registerPhase</>, CHILDREN, 100);
    Utility.resolve(<>IInvalidationUtility.registerPhase</>, MEASURE, 200, false);
    Utility.resolve(<>IInvalidationUtility.registerPhase</>, LAYOUT, 300);
    
    public static function invalidateNotifications(caller:DisplayObject, callback:Function = null):void
    {
      invalidate(NOTIFY, caller, callback);
    }
    
    public static function invalidateChildren(caller:DisplayObject, callback:Function = null):void
    {
      invalidate(CHILDREN, caller, callback);
    }
    
    public static function invalidateSize(caller:DisplayObject, callback:Function = null):void
    {
      invalidate(MEASURE, caller, callback);
    }
    
    public static function invalidateLayout(caller:DisplayObject, callback:Function = null):void
    {
      invalidate(LAYOUT, caller, callback);
    }
  }
}