package reflex.graphics
{
  import flash.display.Sprite;
  
  import reflex.display.IMeasurable;

	public interface IDrawable extends IMeasurable
	{
    function get target():Sprite;
    function set target(value:Sprite):void;
    
		function invalidate():void;
		function render():void;
    
    function get x():Number;
    function get y():Number;
	}
}