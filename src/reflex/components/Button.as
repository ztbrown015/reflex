package reflex.components
{
	import reflex.behaviors.ButtonBehavior;
	//import reflex.behaviors.SelectableBehavior;
	import reflex.skins.ButtonSkin;
	
	public class Button extends Component
	{
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var selected:Boolean;
		
		public function Button()
		{
//			var buttonSkin:ButtonSkin = new ButtonSkin();
//			style.skin = buttonSkin;
//			style.buttonBehavior = new ButtonBehavior();
//			state = ButtonBehavior.UP;
		}
		
		override protected function init():void
		{
			
		}
	}
}