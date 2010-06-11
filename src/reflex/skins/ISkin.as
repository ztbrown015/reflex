package reflex.skins
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	
	/**
	 * @alpha
	 **/
	public interface ISkin
	{
    function get children():Array;
    
		function get target():Sprite;           // but I prefer ISkinnable targets, they're my favorite
		function set target(value:Sprite):void; // 'cause then I'll use data, children, layout, state, etc
    
		function getSkinPart(part:String):InteractiveObject;
	}
}