package reflex.components
{
  import flash.display.DisplayObject;
  import flash.events.Event;
  
  import mx.events.PropertyChangeEvent;
  import mx.events.PropertyChangeEventKind;
  
  import reflex.behaviors.CompositeBehavior;
  import reflex.behaviors.IBehavioral;
  import reflex.display.Container;
  import reflex.graphics.IDrawable;
  import reflex.skins.ISkin;
  import reflex.skins.ISkinnable;
  import reflex.styles.IStyleAware;
  import reflex.styles.StyleAwareActor;
  import reflex.utilities.Utility;
  import reflex.utilities.states.IStateUtility;
  
  use namespace reflex;
  
  [Event(name="currentStateChanged", type="flash.events.Event")]
  [Event(name="behaviorsChanged", type="flash.events.Event")]
  [Event(name="skinChanged", type="flash.events.Event")]
  [Event(name="stylesChanged", type="flash.events.Event")]
  
  [Style(name="left", type="Object")]
  [Style(name="right", type="Object")]
  [Style(name="top", type="Object")]
  [Style(name="bottom", type="Object")]
  [Style(name="horizontalCenter", type="Number")]
  [Style(name="verticalCenter", type="Number")]
  [Style(name="dock", type="Boolean")]
  [Style(name="align", type="String")]
  
  [Style(name="paddingLeft", type="Number")]
  [Style(name="paddingRight", type="Number")]
  [Style(name="paddingTop", type="Number")]
  [Style(name="paddingBottom", type="Number")]
  
  /**
   * @alpha
   */
  public class Component extends Container implements IBehavioral, ISkinnable, IStyleAware/*, IStateClient2*/
  {
    public function Component()
    {
      _behaviors = new CompositeBehavior(this);
      addEventListener("stylesChanged", onStylesChanged);
    }
    
    private var _behaviors:CompositeBehavior;
    reflex var behaviorsChanged:Boolean = false;
    [Bindable(event="behaviorsChanged")]
    [ArrayElementType("reflex.behaviors.IBehavior")]
    [Inspectable(name="Behaviors", type="Array")]
    /**
     * A dynamic object or hash map of behavior objects. <code>behaviors</code>
     * is effectively read-only, but setting either an IBehavior or array of
     * IBehavior to this property will add those behaviors to the <code>behaviors</code>
     * object/map.
     *
     * To set behaviors in MXML:
     * &lt;Component...&gt;
     *   &lt;behaviors&gt;
     *     &lt;SelectBehavior/&gt;
     *     &lt;ButtonBehavior/&gt;
     *   &lt;/behaviors&gt;
     * &lt;/Component&gt;
     */
    public function get behaviors():*
    {
      return _behaviors;
    }
    
    public function set behaviors(... values):void
    {
      behaviors.clear();
      behaviors.add(values);
      
      behaviorsChanged = true;
      
      invalidateNotifications();
    }
    
    private var _currentState:String;
    reflex var currentStateChanged:Boolean = false;
    [Bindable(event="currentStateChanged")]
    
    public function get currentState():String
    {
      return _currentState;
    }
    
    public function set currentState(value:String):void
    {
      if(_currentState == value)
        return;
      
      Utility.resolve(<>IStateUtility.change</>, this, _currentState, value);
      
      _currentState = value;
      
      currentStateChanged = true;
      
      invalidateNotifications();
    }
    
    private var _states:Array;
    
    public function get states():Array
    {
      return _states;
    }
    
    public function set states(value:Array):void
    {
      if(_states == value)
        return;
      
      _states = value;
      
      invalidateNotifications();
    }
    
    private var _skin:Object;
    reflex var skinChanged:Boolean = false;
    [Bindable(event="skinChanged")]
    [Inspectable(name="Skin", type="General")]
    
    public function get skin():Object
    {
      return _skin;
    }
    
    public function set skin(value:Object):void
    {
      if(value === _skin)
        return;
      
      if(skin)
        removeSkin(skin);
      
      _skin = value;
      
      if(skin)
        attachSkin(skin);
      
      skinChanged = true;
      
      invalidateNotifications();
    }
    
    public function addSkinPart(part:Object, name:String):Object
    {
      if(name in this)
        this[name] = part;
      
      if(children.indexOf(part) == -1)
        children.push(part);
      
      if(part is DisplayObject)
        addChild(DisplayObject(part));
      
      // This happens in Skin too, but keep it here since we aren't guaranteed 
      // that skin extends reflex.skins.Skin.
      if(part is IDrawable)
        IDrawable(part).target = this;
      
      return part;
    }
    
    public function removeSkinPart(part:Object, name:String):Object
    {
      if(name in this)
        this[name] = null;
      
      var i:int = children.indexOf(part);
      if(i != -1)
        children.splice(i, 1);
      
      if(part is DisplayObject)
        removeChild(DisplayObject(part));
      
      if(part is IDrawable)
        IDrawable(part).target = null;
      
      return part;
    }
    
    protected function attachSkin(skin:Object):void
    {
      if(skin is ISkin)
        ISkin(skin).target = this;
      else
        addSkinPart(skin, 'skin');
    }
    
    protected function removeSkin(skin:Object):void
    {
      if(skin is ISkin)
        ISkin(skin).target = null;
      else
        removeSkinPart(skin, 'skin');
    }
    
    protected var _style:Object = new StyleAwareActor();
    reflex var stylesChanged:Boolean = false;
    
    public function get style():Object
    {
      return _style ? _style['style'] || _style : null;
    }
    
    public function set style(styleObject:Object):void
    {
      if(_style === styleObject)
        return;
      
      if(!_style)
        _style = styleObject;
      else
        _style['style'] = styleObject;
      
      stylesChanged = true;
      
      invalidateNotifications();
    }
    
    public function clearStyle(styleProp:String):Boolean
    {
      var oldValue:* = getStyle(styleProp);
      
      stylesChanged = true;
      
      dispatchEvent(new PropertyChangeEvent('stylesChanged', false, false, PropertyChangeEventKind.DELETE, styleProp, oldValue, undefined, this));
      
      invalidateNotifications();
      
      return delete _style[styleProp];
    }
    
    public function getStyle(styleProp:String):*
    {
      return _style[styleProp];
    }
    
    public function setStyle(styleProp:String, newValue:*):void
    {
      var oldValue:* = getStyle(styleProp);
      
      style[styleProp] = newValue;
      
      dispatchEvent(new PropertyChangeEvent('stylesChanged', false, false, PropertyChangeEventKind.UPDATE, styleProp, oldValue, newValue, this));
      
      stylesChanged = true;
      
      invalidateNotifications();
    }
    
    override protected function onNotifyPhase():void
    {
      super.onNotifyPhase();
      
      if(stylesChanged)
        dispatchEvent(new Event("stylesChanged"));
      stylesChanged = false;
      
      if(behaviorsChanged)
        dispatchEvent(new Event("behaviorsChanged"));
      behaviorsChanged = false;
      
      if(skinChanged)
        dispatchEvent(new Event("skinChanged"));
      skinChanged = false;
      
      if(currentStateChanged)
        dispatchEvent(new Event("currentStateChanged"));
      currentStateChanged = false;
    }
    
    protected function onStylesChanged(event:Event):void
    {
      if(event is PropertyChangeEvent)
      {
        var styleProp:String = PropertyChangeEvent(event).property.toString();
        
        if(styleProp.indexOf("padding") > 0)
        {
          var prop:String = String(styleProp.split('padding').pop()).toLowerCase();
          layout.padding[prop] = getStyle(styleProp);
        }
      }
    }
  }
}
