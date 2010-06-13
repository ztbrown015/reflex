package reflex.styles
{
  import flash.events.IEventDispatcher;

  public interface IStyleAware extends IEventDispatcher
  {
    function get style():Object;
    function set style(value:Object):void;
    
    function clearStyle(styleProp:String):Boolean;
    function getStyle(styleProp:String):*;
    function setStyle(styleProp:String, newValue:*):void;
  }
}