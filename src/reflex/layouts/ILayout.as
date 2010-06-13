package reflex.layouts
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import reflex.styles.IStyleAware;
	
	/**
	 * @alpha
	 */
	public interface ILayout
	{
		function get target():DisplayObjectContainer;
		function set target(value:DisplayObjectContainer):void;
    
    function get padding():Padding;
    
		function measure(children:Array):Point;
		function update(children:Array):void;
	}
}