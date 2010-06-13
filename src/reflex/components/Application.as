package reflex.components
{
  import flash.display.Graphics;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.events.EventPhase;
  
  import reflex.display.Container;
  import reflex.utilities.ReflexDefaults;
  ReflexDefaults;
  
  [Frame(factoryClass="reflex.tools.flashbuilder.ReflexApplicationLoader")]
  [SWF(percentWidth="100%", percentHeight="100%", frameRate="30")]
  
  /**
   * @alpha
   */
  public class Application extends Container
  {
    public function Application()
    {
      super();
      
      trace('Application Constructor');
      
      addEventListener(Event.ADDED, onAdded);
    }
    
    private function onAdded(event:Event):void
    {
      if(event.eventPhase != EventPhase.AT_TARGET)
        return;
      
      trace('App Added to Stage');
      
      //contextMenu = new ContextMenu();
      //contextMenu.hideBuiltInItems();
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      stage.addEventListener(Event.RESIZE, onStageResize);
      onStageResize(null);
    }
    
    private function onStageResize(event:Event):void
    {
      width = stage.stageWidth;
      height = stage.stageHeight;
      
      invalidateLayout();
    }
  }
}