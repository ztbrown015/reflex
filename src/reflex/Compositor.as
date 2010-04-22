package reflex
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import flight.observers.PropertyChange;
	
	/**
	 * Holds all composites for an instance of display object.
	 */
	public dynamic class Compositor extends Proxy
	{
		// ****** Static definition ******
		
		protected static var targets:Dictionary = new Dictionary(true);
		protected static var instantiating:Boolean;
		
		/**
		 * Return the compositor for a given display object.
		 */
		public static function get(target:DisplayObject):Compositor
		{
			var compositor:Compositor = targets[target];
			if (!compositor) {
				instantiating = true;
				targets[target] = compositor = new Compositor(target);
				instantiating = false;
			}
			return compositor;
		}
		
		
		// ****** Class definition ******
		
		private var _target:DisplayObject;
		private var classValueFunction:Function = convertClasses;
		private var changeFunction:Function = setTargets;
		protected var explicits:Object = {};
		protected var implicits:Object = {};
		
		public function Compositor(target:DisplayObject = null)
		{
			if (!instantiating) {
				throw new Error("Don't create Compositor directly. Use Compositor.get(target).");
			}
			_target = target;
			PropertyChange.addHook(this, "*", null, convertClasses);
			PropertyChange.addObserver(this, "*", null, setTargets);
		}
		
		public function get constructor():Class
		{
			return Compositor;
		}
		
		public function get target():DisplayObject
		{
			return _target;
		}
		
		/**
		 * Converts Class definitions into objects if the old value is of a
		 * different type. Otherwise just keep the old value.
		 */
		protected function convertClasses(oldValue:*, newValue:*):*
		{
			if ( !(newValue is Class)) return;
			
			var constructor:Class = oldValue is Proxy ? getDefinitionByName(getQualifiedClassName(oldValue)) as Class : oldValue.constructor;
			if (constructor == newValue) {
				return oldValue;
			} else {
				return new newValue();
			}
		}
		
		/**
		 * If the values are IComposites then update their targets.
		 */
		protected function setTargets(oldValue:*, newValue:*):void
		{
			if (oldValue && oldValue is IComposite) {
				IComposite(oldValue).target = null;
			}
			
			if (newValue && newValue is IComposite) {
				IComposite(newValue).target = target;
			}
		}
		
		
		/**
		 * Proxy method to return a requested property.
		 */
		override flash_proxy function getProperty(name:*):*
		{
			return name in explicits ? explicits[name] : implicits[name];
		}
		
		
		/**
		 * Proxy method to set a property. Accepts a Class object for an
		 * IBehavior or an IBehavior object itself.
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			var change:PropertyChange = PropertyChange.begin();
			var currentValue:* = this[name];
			
			explicits[name] = change.add(this, name, currentValue, value);
			change.commit();
		}
		
		
		/**
		 * Proxy method to delete the specified property.
		 */
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			if ( !(name in explicits)) return false;
			
			var oldValue:* = explicits[name];
			delete explicits[name];
			var change:PropertyChange = PropertyChange.begin();
			change.add(this, name, oldValue, implicits[name]);
			change.commit();
			return true;
		}
		
		
		/**
		 * Proxy method to check if the specified property exists.
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return (name in explicits);
		}
		
		
		/**
		 * to be determined
		 */
		override flash_proxy function callProperty(name:*, ...rest):*
		{
			return null;
		}
		
		
		private var props:Array;
		
		/**
		 * Proxy method allowing looping through the map.
		 */
		override flash_proxy function nextName(index:int):String
		{
			return props[index - 1];
		}
		
		/**
		 * Proxy method allowing looping through the map.
		 */
		override flash_proxy function nextValue(index:int):*
		{
			return props[index-1];
		}
		
		/**
		 * Proxy method allowing looping through the map.
		 */
		override flash_proxy function nextNameIndex(index:int):int
		{
			props = [];
			if (index == 0) {
				for (var i:String in explicits) {
					props.push(i);
				}
				for (i in implicits) {
					if ( !(i in explicits)) {
						props.push(i);
					}
				}
			}
			if(index < props.length) {
				return index + 1;
			} else {
				props = null;
				return 0;
			}
		}
		
	}
}