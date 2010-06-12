package reflex.display
{
  public interface IMovable
  {
    function get x():Number;
    function set x(value:Number):void;
    
    function get y():Number;
    function set y(value:Number):void;
    
    function move(x:Number, y:Number):void;
  }
}