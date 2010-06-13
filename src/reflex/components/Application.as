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
  [SWF(percentWidth="100%", percentHeight="100%")]
  
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
    }
    
    private function onStageResize(event:Event):void
    {
//      setSize(isNaN(percentWidth) ? stage.stageWidth : percentWidth * 0.01 * stage.stageWidth,
//              isNaN(percentHeight) ? stage.stageHeight : percentHeight * 0.01 * stage.stageHeight);
//      _explicitWidth = NaN;
//      _explicitHeight = NaN;
//      _explicitWidth = isNaN(percentWidth) ? stage.stageWidth : percentWidth * 0.01 * stage.stageWidth;
//      _explicitHeight = isNaN(percentHeight) ? stage.stageHeight : percentHeight * 0.01 * stage.stageHeight;
      
//      invalidateSize();
//      invalidateLayout();
    }
  }
}