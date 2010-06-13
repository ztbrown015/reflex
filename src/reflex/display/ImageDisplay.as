package reflex.display
{
  import flash.display.Loader;
  import flash.events.Event;
  import flash.net.URLRequest;
  
  import reflex.events.InvalidationEvent;
  import reflex.utilities.Utility;
  import reflex.utilities.invalidation.IInvalidationUtility;
  import reflex.utilities.listen;
  
  public class ImageDisplay extends ReflexDisplay
  {
    private var loader:Loader;
    private var _source:Object;
    
    public function get source():Object
    {
      return _source;
    }
    
    public function set source(value:Object):void
    {
      if(source === value)
        return;
      
      _source = value;
      addEventListener(SOURCE_CHANGED, listen(onSourceChanged, this));
      Utility.resolve(<>IInvalidationUtility.invalidate</>, this, SOURCE_CHANGED);
    }
    
    private function onSourceChanged(event:InvalidationEvent):void
    {
      var request:URLRequest = new URLRequest(source as String);
      loader = new Loader();
      loader.load(request);
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
    }
    
    private function onComplete(event:Event):void
    {
      setSize(loader.content.width, loader.content.height);
      addChild(loader);
    }
    
    public static const SOURCE_CHANGED:String = "sourceChanged";
    Utility.resolve(<>IInvalidationUtility.registerPhase</>, SOURCE_CHANGED);
  }
}