package reflex.components
{
	import flight.position.IPosition;
	
	import reflex.behaviors.ScrollBehavior;
	import reflex.skins.ScrollBarSkin;
	
	public class ScrollBar extends Component
	{
		[Bindable]
		public var position:IPosition;
		
		public function ScrollBar()
		{
		}
		
		override protected function init():void
		{
			var scrollBarSkin:ScrollBarSkin = new ScrollBarSkin();
			compositor.skin = scrollBarSkin;
			var scrollBehavior:ScrollBehavior = new ScrollBehavior(this);
			compositor.scrollBehavior = scrollBehavior;
			position = scrollBarSkin.position = scrollBehavior.position;
		}
		
	}
}