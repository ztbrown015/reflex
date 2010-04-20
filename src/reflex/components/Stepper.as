package reflex.components
{
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.behaviors.StepBehavior;
	import reflex.skins.StepperSkin;

	public class Stepper extends Component
	{
		[Bindable]
		public var position:IPosition;
		
		public function Stepper()
		{
			position = new Position();
			position.value = 0;
			position.min = 0;
			position.max = 100;
			compositor.skin = new StepperSkin();
			compositor.stepBehavior = new StepBehavior();
		}
		
		override protected function init():void
		{
		}
	}
}