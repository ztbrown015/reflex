package reflex.controls
{
	import flight.position.IPosition;
	
	import reflex.component.Component;

	public class ScrollBar extends Component
	{
		[Bindable]
		public var positition:IPosition;
		
		public function ScrollBar()
		{
		}
	}
}