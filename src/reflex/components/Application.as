package reflex.components
{
  import flash.display.Graphics;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.events.EventPhase;
  
  import reflex.display.Container;
  import reflex.utilities.ReflexDefaults; ReflexDefaults;
  
  [Frame(factoryClass="reflex.tools.flashbuilder.ReflexApplicationLoader")]
  [SWF(percentWidth="100%", percentHeight="100%")]
  
  /**
   * @alpha
   */
  public class Application extends Container
  {
    public function Application()
    {
      super();
    }
  }
}