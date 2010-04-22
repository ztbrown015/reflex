package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.events.ButtonEvent;
	
	public class StepBehavior extends Behavior
	{
		public var fwdBehavior:ButtonBehavior;
		public var bwdBehavior:ButtonBehavior;
		
		[Binding(target="style.skin.fwdBtn")]
		[Bindable]
		public var fwdBtn:InteractiveObject;
		
		[Binding(target="style.skin.bwdBtn")]
		[Bindable]
		public var bwdBtn:InteractiveObject;
		
		[Bindable]
		[Binding(target="target.position")]
		public var position:IPosition = new Position();		// TODO: implement lazy instantiation of position
		
		public function StepBehavior(target:InteractiveObject = null)
		{
			super(target);
			fwdBehavior = new ButtonBehavior();
			bwdBehavior = new ButtonBehavior();
			name = "stepBehavior";
		}
		
		
		[PropertyListener(target="style.skin.fwdBtn")]
		public function onFwdBtnChange(fwdBtn:InteractiveObject):void
		{
			if (!fwdBtn) return;
			fwdBehavior.target = fwdBtn;
			if (fwdBtn is MovieClip) {
				Bind.addListener(this, onFwdStateChange, fwdBehavior, "state");
			}
		}
		
		[PropertyListener(target="style.skin.bwdBtn")]
		public function onBwdBtnChange(bwdBtn:InteractiveObject):void
		{
			if (!bwdBtn) return;
			bwdBehavior.target = bwdBtn;
			if (bwdBtn is MovieClip) {
				Bind.addListener(this, onBwdStateChange, bwdBehavior, "state");
			}
		}
		
		
		[EventListener(type="press", target="fwdBtn")]
		[EventListener(type="hold", target="fwdBtn")]
		public function onFwdPress(event:ButtonEvent):void
		{
			position.forward();
			event.updateAfterEvent();
		}
		
		[EventListener(type="press", target="bwdBtn")]
		[EventListener(type="hold", target="bwdBtn")]
		public function onBwdPress(event:ButtonEvent):void
		{
			position.backward();
			event.updateAfterEvent();
		}
		
		protected function onFwdStateChange(state:String):void
		{
			MovieClip(fwdBtn).gotoAndStop(state);
		}
		
		protected function onBwdStateChange(state:String):void
		{
			MovieClip(bwdBtn).gotoAndStop(state);
		}
	}
}