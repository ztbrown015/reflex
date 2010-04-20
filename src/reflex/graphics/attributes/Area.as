package reflex.graphics.attributes
{
	import flash.geom.Rectangle;
	
	public class Area extends Rectangle
	{
		
		private static var pool:Area;
		private var next:Area;
		
		
		public function Area(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(x, y, width, height);
		}
		
		public function inset(delta:Number):void
		{
			x += delta;
			y += delta;
			width -= delta*2;
			height -= delta*2;
		}
		
		public function dispose():void
		{
			x = 0;
			y = 0;
			width = 0;
			height = 0;
			next = pool;
			pool = this;
		}
		
		public static function clone(area:Area):Area
		{
			return get(area.x, area.y, area.width, area.height);
		}
		
		public static function get(x:Number, y:Number, width:Number, height:Number):Area
		{
			var area:Area = pool;
			
			if (area) {
				pool = area.next;
				area.x = x;
				area.y = y;
				area.width = width;
				area.height = height;
			} else {
				area = new Area(x, y, width, height);
			}
			
			return area;
		}
	}
}