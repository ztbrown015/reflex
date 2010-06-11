package reflex.utilities
{
  import flash.display.MovieClip;
  

  [Mixin]
  public class ReflexDefaults
  {
    public static function init(root:MovieClip):void
    {
      Utility.registerUtility(IStateUtility, new StateUtility());
    }
  }
}