package reflex.utilities
{
  import flash.display.MovieClip;
  
  import reflex.events.IStateUtility;
  import reflex.events.StateUtility;

  [Mixin]
  public class ReflexUtilities
  {
    public static function init(root:MovieClip):void
    {
      Utility.registerUtility(IStateUtility, new StateUtility());
    }
  }
}