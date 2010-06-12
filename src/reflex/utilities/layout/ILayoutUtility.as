package reflex.utilities.layout
{
  public interface ILayoutUtility
  {
    function resolveWidth(object:Object):Number;
    function resolveHeight(object:Object):Number;
    function setSize(object:Object, newWidth:Number, newHeight:Number):void;
    function move(object:Object, x:Number, y:Number):void;
  }
}