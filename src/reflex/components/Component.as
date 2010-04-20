package reflex.components
{
	import flight.events.PropertyEvent;
	import flight.observers.PropertyChange;
	
	import reflex.Compositor;
	import reflex.behaviors.CompositeBehavior;
	import reflex.behaviors.IBehavior;
	import reflex.behaviors.IBehavioral;
	import reflex.display.Container;
	import reflex.layout.ILayoutAlgorithm;
	import reflex.skins.ISkin;
	import reflex.skins.ISkinnable;
	
	public class Component extends Container implements IBehavioral, ISkinnable
	{
		private var _state:String;
		private var _data:Object;
		protected var compositor:Compositor;
		
		public function Component()
		{
			compositor = Compositor.get(this);
		}
		
		
		[Bindable]
		public function get state():String
		{
			return _state;
		}
		public function set state(value:String):void
		{
			var change:PropertyChange = PropertyChange.begin();
			_state = change.add(this, "state", _state, value);
			change.commit();
		}
		
		
		[Bindable]
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			var change:PropertyChange = PropertyChange.begin();
			_data = change.add(this, "data", _data, value);
			change.commit();
		}
		
		
		override protected function constructChildren():void
		{
			// load skin from CSS, etc
		}
		
	}
}
