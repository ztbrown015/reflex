package reflex.utilities.styles
{
  public interface IStyleUtility
  {
    function hasStyle(object:Object, styleProp:String):Boolean;
    function getStyle(object:Object, styleProp:String):*;
    function setStyle(object:Object, styleProp:String, newValue:* = null):void;
  }
}