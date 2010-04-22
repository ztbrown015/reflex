package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import reflex.events.ButtonEvent;
	
	public class ScrollBehavior extends StepBehavior
	{
		[Binding(target="style.skin.track")]
		public var track:InteractiveObject;
		
		[Binding(target="style.skin.thumb")]
		public var thumb:InteractiveObject;
		
		[Bindable]
		[Binding(target="target.horizontal")]
		public var horizontal:Boolean = false;
		
		private var _percent:Number = 0;
		private var dragPercent:Number;
		private var dragPoint:Number;
		private var dragging:Boolean;
		private var forwardPress:Boolean;
		
		public function ScrollBehavior(target:InteractiveObject = null)
		{
			super(target);
			name = "scrollBehavior";
		}
		
		[Bindable(event="percentChange")]
		public function get percent():Number
		{
			return _percent;
		}
		
		[PropertyListener(target="style.skin.track")]
		public function onTrackChange(track:InteractiveObject):void
		{
			if (!track) return;
			
			ButtonEvent.initialize(track);
			
			if (track.width > track.height) {
				horizontal = true;
			}
			updatePosition();
		}
		
		[PropertyListener(target="style.skin.thumb")]
		public function onThumbChange(thumb:InteractiveObject):void
		{
			if (thumb) ButtonEvent.initialize(thumb);
		}
		
		[PropertyListener(target="position.percent")]
		public function onPosition(percent:Number):void
		{
			if (thumb == null || track == null) {
				return;
			}
			
			if (!dragging) {
				_percent = position.percent;
				updatePosition();
				dispatchEvent(new Event("percentChange"));
			}
		}
		
		[EventListener(type="press", target="track")]
		public function onTrackPress(event:ButtonEvent):void
		{
			var size:Number = horizontal ? track.width : track.height;
			forwardPress = (horizontal ? track.parent.mouseX - track.x : track.parent.mouseY - track.y) > (size * position.percent);
			
			if (forwardPress) {
				position.skipForward();
			} else {
				position.skipBackward();
			}
			event.updateAfterEvent();
		}
		
		[EventListener(type="hold", target="track")]
		public function onTrackHold(event:ButtonEvent):void
		{
			var size:Number = horizontal ? track.width : track.height;
			var forwardHold:Boolean = (horizontal ? track.parent.mouseX - track.x : track.parent.mouseY - track.y) > (size * position.percent);
			
			if (forwardPress != forwardHold) {
				return;
			}
			
			if (forwardPress) {
				position.skipForward();
			} else {
				position.skipBackward();
			}
			event.updateAfterEvent();
		}
		
		[EventListener(type="press", target="thumb")]
		public function onThumbPress(event:ButtonEvent):void
		{
			dragging = true;
			dragPoint = horizontal ? thumb.parent.mouseX : thumb.parent.mouseY;
			dragPercent = _percent;
		}
		
		[EventListener(type="drag", target="thumb")]
		public function onThumbDrag(event:ButtonEvent):void
		{
			var mousePoint:Number = horizontal ? thumb.parent.mouseX : thumb.parent.mouseY;
			var size:Number = horizontal ? track.width - thumb.width : track.height - thumb.height;
			var delta:Number = (mousePoint - dragPoint) / size;
			_percent = dragPercent + delta;
			_percent = _percent <= 0 ? 0 : (_percent >= 1 ? 1 : _percent);
			position.percent = _percent;
			updatePosition();
			dispatchEvent(new Event("percentChange"));
			
			event.updateAfterEvent();
		}
		
		[EventListener(type="release", target="thumb")]
		[EventListener(type="releaseOutside", target="thumb")]
		public function onThumbRelease(event:ButtonEvent):void
		{
			dragging = false;
		}
		
		[PropertyListener(target="target.width")]
		[PropertyListener(target="target.height")]
		public function onResize(size:Number):void
		{
			updatePosition();
		}
		
		
		protected function updatePosition():void
		{
			var p:Point = new Point();
			if (horizontal) {
				p.x = (track.width - thumb.width) * _percent + track.x;
				p = thumb.parent.globalToLocal( track.parent.localToGlobal(p) );
				thumb.x = Math.round(p.x);
			} else {
				p.y = (track.height - thumb.height) * _percent + track.y;
				p = thumb.parent.globalToLocal( track.parent.localToGlobal(p) );
				thumb.y = Math.round(p.y);
			}
		}
		
	}
}
