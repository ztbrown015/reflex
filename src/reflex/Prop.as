package reflex
{
	import flash.display.DisplayObject;
	
	public class Prop implements IComposite
	{
		private var _name:String;
		
		public var value:*;
		
		public function Prop()
		{
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get target():DisplayObject
		{
			return null;
		}
		
		public function set target(value:DisplayObject):void
		{
		}
	}
}