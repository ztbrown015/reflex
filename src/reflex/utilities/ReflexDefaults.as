package reflex.utilities
{
  import flash.display.MovieClip;
  
  import reflex.utilities.invalidation.IInvalidationUtility;
  import reflex.utilities.invalidation.InvalidationUtility;
  import reflex.utilities.layout.ILayoutUtility;
  import reflex.utilities.layout.LayoutUtility;
  import reflex.utilities.metadata.IMetadataUtility;
  import reflex.utilities.metadata.MetadataUtility;
  import reflex.utilities.states.IStateUtility;
  import reflex.utilities.states.StateUtility;

  [Mixin]
  public class ReflexDefaults
  {
    public static function init(root:MovieClip = null):void
    {
      Utility.registerUtility(IInvalidationUtility, new InvalidationUtility());
      Utility.registerUtility(IMetadataUtility, new MetadataUtility());
      Utility.registerUtility(ILayoutUtility, new LayoutUtility());
      Utility.registerUtility(IStateUtility, new StateUtility());
    }
  }
}