package reflex.utilities
{
  import flash.display.MovieClip;
  
  import reflex.utilities.invalidation.*;
  import reflex.utilities.layout.*;
  import reflex.utilities.metadata.*;
  import reflex.utilities.states.*;
  import reflex.utilities.styles.*;

  [Mixin] // Adds this class to the list of classes that the ReflexApplicationLoader will statically initialize
  public class ReflexDefaults
  {
    public static function init(root:MovieClip = null):void
    {
      Utility.registerUtility(IInvalidationUtility, new InvalidationUtility());
      Utility.registerUtility(IMetadataUtility, new MetadataUtility());
      Utility.registerUtility(ILayoutUtility, new LayoutUtility());
      Utility.registerUtility(IStyleUtility, new StyleUtility());
      Utility.registerUtility(IStateUtility, new StateUtility());
    }
  }
}