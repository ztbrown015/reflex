package reflex.display
{
	import reflex.layouts.ILayout;
	
	/**
	 * @alpha
	 */
	public interface IContainer
	{
		function get children():Array;
		
		function get layout():ILayout;
		function set layout(value:ILayout):void;
	}
}