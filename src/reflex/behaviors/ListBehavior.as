package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	
	import reflex.skins.ISkin;
	import reflex.skins.ISkinnable;

	public class ListBehavior extends Behavior
	{
		[Binding(target="style.skin.hScrollBar")]
		public var hScrollBar:InteractiveObject;
		
		[Binding(target="style.skin.vScrollBar")]
		public var vScrollBar:InteractiveObject;
		
		private var hScrollBehavior:ScrollBehavior;
		private var vScrollBehavior:ScrollBehavior;
		
		public function ListBehavior()
		{
			hScrollBehavior = new ScrollBehavior();
			vScrollBehavior = new ScrollBehavior();
		}
		
		[PropertyListener(target="style.skin.hScrollBar")]
		public function onHScrollChange(hScrollBar:InteractiveObject):void
		{
			hScrollBehavior.target = hScrollBar;
		}
		
		[PropertyListener(target="style.skin.vScrollBar")]
		public function onVScrollChange(vScrollBar:InteractiveObject):void
		{
			vScrollBehavior.target = vScrollBar;
		}
	}
}