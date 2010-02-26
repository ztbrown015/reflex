package reflex.display
{
	import flash.events.Event;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	
	import reflex.layout.ScrollBlock;

	public class ScrollContainer extends Container
	{
		[Bindable]
		public var hPosition:IPosition;
		
		[Bindable]
		public var vPosition:IPosition;
		
		override protected function initLayout():void
		{
			var scrollBlock:ScrollBlock = new ScrollBlock();
			hPosition = scrollBlock.hPosition;
			vPosition = scrollBlock.vPosition;
			scrollBlock.addEventListener("xChange", forwardEvent);
			scrollBlock.addEventListener("yChange", forwardEvent);
			scrollBlock.addEventListener("displayWidthChange", forwardEvent);
			scrollBlock.addEventListener("displayWidthChange", onWidthChange);
			scrollBlock.addEventListener("displayHeightChange", forwardEvent);
			scrollBlock.addEventListener("displayHeightChange", onHeightChange);
			scrollBlock.addEventListener("snapToPixelChange", forwardEvent);
			scrollBlock.addEventListener("layoutChange", forwardEvent);
			scrollBlock.addEventListener("boundsChange", forwardEvent);
			scrollBlock.addEventListener("marginChange", forwardEvent);
			scrollBlock.addEventListener("paddingChange", forwardEvent);
			scrollBlock.addEventListener("dockChange", forwardEvent);
			scrollBlock.addEventListener("alignChange", forwardEvent);
			Bind.addBinding(scrollBlock, "freeform", this, "freeform", true);
			
			block = scrollBlock;
		}
		
		private function forwardEvent(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function onWidthChange(event:Event):void
		{
			dispatchEvent( new Event("widthChange") );
		}
		
		private function onHeightChange(event:Event):void
		{
			dispatchEvent( new Event("heightChange") );
		}
	}
}