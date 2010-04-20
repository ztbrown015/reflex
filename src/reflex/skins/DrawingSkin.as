package reflex.skins
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import flight.binding.Bind;
	
	import reflex.events.RenderEvent;
	import reflex.graphics.attributes.Angle;
	import reflex.graphics.attributes.Area;
	import reflex.graphics.attributes.CornerRadius;

	public class DrawingSkin extends Skin
	{
		RenderEvent.registerPhase(DRAW);
		
		public function DrawingSkin()
		{
			Bind.addListener(this, invalidateRedraw, this, "target");
			Bind.addListener(this, invalidateRedraw, this, "state");
			Bind.addListener(this, invalidateRedraw, this, "target.width");
			Bind.addListener(this, invalidateRedraw, this, "target.height");
			Bind.bindEventListener(DRAW, onDraw, this, "target");
		}
		
		public function invalidateRedraw():void
		{
			if (target) {
				RenderEvent.invalidate(target, DRAW);
			}
		}
		
		public function redraw(graphics:Graphics):void
		{
		}
		
		protected function onDraw(event:RenderEvent):void
		{
			if (target != null && target is Graphics) {
				redraw(Sprite(target).graphics);
			}
		}
		
		protected static var matrix:Matrix = new Matrix();
		
		protected function linearFill(graphics:Graphics, area:Area, colors:Array, alphas:Array = null, ratios:Array = null, angle:Number = 90):void
		{
			var i:uint, count:uint = colors.length;
			if (alphas == null) {
				alphas = [];
				for (i = 0; i < count; i++) {
					alphas[i] = 1;
				} 
			}
			
			if (ratios == null) {
				ratios = [];
				var stepSize:Number = 255/(count - 1);
				for (i = 0; i < count; i++) {
					ratios[i] = i * stepSize;
				}
			}
			
			angle = Angle.fromDegrees(angle);
			
			matrix.createGradientBox(area.width, area.height, angle, area.x, area.y);
			graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
		}
		
		protected function drawRect(graphics:Graphics, area:Area, radius:CornerRadius = null, inset:Number = 0, isBorder:Boolean = false):void
		{
			if (radius) {
				graphics.drawRoundRectComplex(area.x, area.y, area.width, area.height, radius.topLeft, radius.topRight, radius.bottomLeft, radius.bottomRight);
			} else {
				graphics.drawRect(area.x, area.y, area.width, area.height);
			}
			
			if (inset) {
				// shrink the area and radius by the border amount and draw again, cutting out the center
				if (radius) {
					radius.inset(inset);
				}
				area.inset(inset);
				if (isBorder) {
					if (radius) {
						graphics.drawRoundRectComplex(area.x, area.y, area.width, area.height, radius.topLeft, radius.topRight, radius.bottomLeft, radius.bottomRight);
					} else {
						graphics.drawRect(area.x, area.y, area.width, area.height);
					}
				}
			}
		}
	}
}