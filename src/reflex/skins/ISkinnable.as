package reflex.skins
{
	import flash.events.IEventDispatcher;
	
	import flight.list.IList;
	
	import reflex.display.IContainer;
	import reflex.layout.ILayoutAlgorithm;
	
	public interface ISkinnable extends IContainer
	{
		function get data():Object;
		function set data(value:Object):void;
		
		function get state():String;
		function set state(value:String):void;
	}
}