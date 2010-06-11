package reflex.utilities
{
  import flash.display.MovieClip;

  [Mixin]
  public class ReflexDefaults
  {
    public static function init(root:MovieClip = null):void
    {
      Utility.registerUtility(IInvalidationUtility, new InvalidationUtility());
      Utility.registerUtility(IStateUtility, new StateUtility());
    }
  }
}