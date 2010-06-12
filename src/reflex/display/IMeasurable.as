package reflex.display
{
  public interface IMeasurable
  {
    function get width():Number;
    function set width(value:Number):void
    
    function get height():Number;
    function set height(value:Number):void
    
    function get explicitWidth():Number;
    function get explicitHeight():Number;
    
    function get percentWidth():Number;
    function set percentWidth(value:Number):void
    
    function get percentHeight():Number;
    function set percentHeight(value:Number):void
    
    function setSize(newWidth:Number, newHeight:Number):void;
  }
}