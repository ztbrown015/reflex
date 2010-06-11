package reflex.skins
{
	/**
	 * @alpha
	 **/
	public interface ISkinnable
	{
		/**
		 * The component's current state.
		 **/
		function get currentState():String;
		function set currentState(value:String):void;
		
		/**
		 * An Object to be used for the component's visual display.
		 * This is commonly an MXML class extending reflex.skins.Skin or a custom MovieClip.
		 * However, any DisplayObject or ISkin implementation may be used.
		 */
		function get skin():Object;
		function set skin(value:Object):void;
    
    function addSkinPart(part:Object, name:String):Object;
    function removeSkinPart(part:Object, name:String):Object;
	}
}