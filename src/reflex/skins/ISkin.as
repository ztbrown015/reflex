package reflex.skins
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	
	import reflex.IComposite;
	import reflex.layout.ILayoutAlgorithm;
	
	public interface ISkin extends IComposite
	{
		function get layout():ILayoutAlgorithm;
		function set layout(value:ILayoutAlgorithm):void;
		
		function get data():Object;
		function set data(value:Object):void;
		
		function get state():String;
		function set state(value:String):void;
		
		function getSkinPart(part:String):InteractiveObject;
	}
}