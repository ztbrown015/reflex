package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.events.ButtonEvent;
	
	public class DragStepBehavior extends Behavior
	{
		[Bindable]
		[Binding(target="target.position")]
		public var position:IPosition = new Position();		// TODO: implement lazy instantiation of position
		
		protected var startDragPosition:Number;
		
		public function DragStepBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		override public function set target(value:DisplayObject):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			ButtonEvent.initialize(target as InteractiveObject);
		}
		
		[EventListener(type="mouseDown", target="target")]
		public function onDragStart(event:MouseEvent):void
		{
			startDragPosition = position.value;
		}
		
		[EventListener(type="drag", target="target")]
		public function onDrag(event:ButtonEvent):void
		{
			position.value = startDragPosition + event.deltaX;
		}
		
	}
}