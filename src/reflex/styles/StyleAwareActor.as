package reflex.styles
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.utils.Proxy;
  import flash.utils.describeType;
  import flash.utils.flash_proxy;
  
  import mx.events.PropertyChangeEvent;
  import mx.events.PropertyChangeEventKind;
  
  use namespace flash_proxy;
  
  /**
   * StyleAwareActor is a useful base class for objects with sealed properties
   * but who also wish to dynamically accept and store named values.
   *
   * Since he is a Proxy implementation, he overrides the flash_proxy functions
   * for setting and retrieving data. If you are calling a sealed property on
   * StyleAwareActor or one of his subclasses, the property or function is called
   * like normal. However, if you dynamically call or set a property on him, he
   * calls his <code>getStyle</code> and <code>setStyle</code> methods instead.
   *
   * StyleAwareActor has an internal <code>styles</code> object on which these
   * properties and values are stored. However, you can override this
   * functionality by passing in your own implementation to store styles on. You
   * can do this by calling <code>setStyle("styleProxy", myProxyImplem)</code>.
   * This will set the <code>myProxyImpl</code> instance as the new internal
   * styles storage object, as well as copy over all the key/value pairs currently
   * on the <code>myProxyImpl</code> instance.
   *
   * This is particularly useful if you wish to proxy together multiple
   * StyleAwareActors for something similar to CSS inheritance, or to support
   * external CSS implementations (currently Flex and F*CSS).
   */
  public class StyleAwareActor extends Proxy implements IStyleAware
  {
    public function StyleAwareActor(styleObject:Object = null)
    {
      if(!styleObject)
        styleObject = {};
      
      style = styleObject;
    }
    
    public function toString():String
    {
      return style.toString();
    }
    
    private var _style:Object;
    
    public function get style():Object
    {
      return _style || this;
    }
    
    public function set style(value:Object):void
    {
      if(value === _style)
        return;
      
      if(!(value is String))
      {
        var proxy:Object;
        var styleProp:String;
        
        // Use value as the new styles object. This allows you to pass in
        // and use your own subclass of StyleAwareActor 
        // (useful for F*CSS or Flex styles)
        if(value is IStyleAware)
        {
          proxy = styles;
          styles = value;
          
          // Copy values from the proxy styles Object to this.
          // Since here we're copying the old styles onto the replacement styles
          // Object, we have to be sure not to replace any styles that already
          // exist on the new guy.
          for(styleProp in proxy)
            if(!(styleProp in this))
              this[styleProp] = proxy[styleProp];
        }
        else
        {
          proxy = value;
          // Copy values from the proxy styles Object to this.
          for(styleProp in proxy)
            this[styleProp] = proxy[styleProp];
        }
      }
      
      _style = value;
    }
    
    protected var styles:Object = {};
    
    public function clearStyle(styleProp:String):Boolean
    {
      if(!(styleProp in styles))
        return false;
      
      var oldValue:* = styles[styleProp];
      
      var success:Boolean = delete styles[styleProp];
      
      dispatchEvent(new PropertyChangeEvent('stylesChanged', false, false, PropertyChangeEventKind.DELETE, styleProp, oldValue, undefined, this));
      
      return success;
    }
    
    public function getStyle(styleProp:String):*
    {
      return styleProp in styles ? styles[styleProp] : null;
    }
    
    public function setStyle(styleProp:String, newValue:*):void
    {
      var oldValue:* = styles[styleProp];
      
      if(oldValue == newValue)
        return;
      
      styles[styleProp] = newValue;
      dispatchEvent(new PropertyChangeEvent('stylesChanged', false, false, PropertyChangeEventKind.UPDATE, styleProp, oldValue, newValue, this));
    }
    
    override flash_proxy function callProperty(name:*, ... parameters):*
    {
      if(name in this && this[name] is Function)
        return (this[name] as Function).apply(null, parameters);
      
      if(name == 'toString')
        return toString();
    }
    
    override flash_proxy function setProperty(name:*, value:*):void
    {
      (name in this) ? this[name] = value : setStyle(name, value);
    }
    
    override flash_proxy function getProperty(name:*):*
    {
      if(name in this)
        return this[name];
      
      return getStyle(name);
    }
    
    override flash_proxy function hasProperty(name:*):Boolean
    {
      return propertiesMap ? name in propertiesMap : false;
    }
    
    protected var names:Array = [];
    
    override flash_proxy function nextNameIndex(index:int):int
    {
      if(index == 0)
      {
        names.length = 0;
        for(var prop:String in styles)
          names.push(prop);
      }
      
      if(index < names.length)
        return index + 1;
      
      return 0;
    }
    
    override flash_proxy function nextName(index:int):String
    {
      return names[index - 1];
    }
    
    override flash_proxy function nextValue(index:int):*
    {
      return this[names[index]];
    }
    
    private var dispatcher:EventDispatcher = new EventDispatcher();
    
    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
    {
      dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }
    
    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
      dispatcher.removeEventListener(type, listener, useCapture);
    }
    
    public function dispatchEvent(event:Event):Boolean
    {
      return dispatcher.dispatchEvent(event);
    }
    
    public function hasEventListener(type:String):Boolean
    {
      return dispatcher.hasEventListener(type);
    }
    
    public function willTrigger(type:String):Boolean
    {
      return dispatcher.willTrigger(type);
    }
    
    generatePropertiesMap(new StyleAwareActor());
    
    private static var propertiesMap:Object;
    
    protected static function generatePropertiesMap(typeOf:*):void
    {
      propertiesMap = {};
      
      var type:XML = describeType(typeOf);
      var prop:XML;
      for each(prop in type..method)
      {
        propertiesMap[prop.@name] = true;
      }
      
      for each(prop in type..accessor.(@access == "readwrite"))
      {
        propertiesMap[prop.@name] = true;
      }
    }
  }
}