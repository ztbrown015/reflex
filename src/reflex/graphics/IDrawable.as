package reflex.graphics
{
	import flash.display.Graphics;
	
	public interface IDrawable
	{
		function set target(value:Object):void;
//		function invalidate():void;
		function render():void;
	}
}