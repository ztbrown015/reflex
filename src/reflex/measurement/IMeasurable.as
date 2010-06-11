package reflex.measurement
{
  
  public interface IMeasurable
  {
    function get width():Number;
    function set width():Number;
    
    function get height():Number;
    function set height():Number;
    
    function get explicitWidth():Number;
    function get explicitHeight():Number;
    
    function get percentWidth():Number;
    function set percentWidth():Number;
    
    function get percentHeight():Number;
    function set percentHeight():Number;
    
    function setSize(newWidth:Number, newHeight:Number):void;
  }
}