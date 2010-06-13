package reflex.utilities.layout
{
  public interface ILayoutUtility
  {
    function getChildren(object:Object):Array;
    
    function getWidth(object:Object):Number;
    function getHeight(object:Object):Number;
    
    function getPercentWidth(object:Object, total:Number = 0):Number;
    function getPercentHeight(object:Object, total:Number = 0):Number;
    
    function getX(object:Object):Number;
    function getY(object:Object):Number;
    
    function setSize(object:Object, newWidth:Number, newHeight:Number):void;
    function move(object:Object, x:Number, y:Number):void;
  }
}