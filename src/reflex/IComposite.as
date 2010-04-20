package reflex
{
	import flash.display.DisplayObject;

	public interface IComposite
	{
		function get target():DisplayObject;
		function set target(value:DisplayObject):void;
	}
}