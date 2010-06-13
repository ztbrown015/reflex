package reflex.components
{
  import flash.display.DisplayObject;
  import flash.events.Event;
  
  import mx.core.IStateClient2;
  
  import reflex.behaviors.CompositeBehavior;
  import reflex.behaviors.IBehavioral;
  import reflex.display.Container;
  import reflex.events.InvalidationEvent;
  import reflex.skins.ISkin;
  import reflex.skins.ISkinnable;
  import reflex.styles.IStyleAware;
  import reflex.styles.StyleAwareActor;
  import reflex.utilities.Utility;
  import reflex.utilities.states.IStateUtility;
  
  use namespace reflex;
  
  [Style(name="left")]
  [Style(name="right")]
  [Style(name="top")]
  [Style(name="bottom")]
  [Style(name="horizontalCenter")]
  [Style(name="verticalCenter")]
  [Style(name="dock")]
  [Style(name="align")]
  
  /**
   * @alpha
   */
  public class Component extends Container implements IBehavioral, ISkinnable, IStyleAware, IStateClient2
  {
    public function Component()
    {
      _behaviors = new CompositeBehavior(this);
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
      
      if(part is DisplayObject)
        addChild(DisplayObject(part));
      
      return part;
    }
    
    public function removeSkinPart(part:Object, name:String):Object
    {
      if(name in this)
        this[name] = null;
      
      if(part is DisplayObject)
        removeChild(DisplayObject(part));
      
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
    
    protected var _style:IStyleAware = new StyleAwareActor();
    
    public function get style():Object
    {
      return _style['style'] || _style;
    }
    
    public function set style(styleObject:Object):void
    {
      if(_style === styleObject)
        return;
      
      _style.style = styleObject;
    }
    
    public function clearStyle(styleProp:String):Boolean
    {
      return delete _style[styleProp];
    }
    
    public function getStyle(styleProp:String):*
    {
      return _style[styleProp];
    }
    
    public function setStyle(styleProp:String, newValue:*):void
    {
      style[styleProp] = newValue;
    }
    
    override protected function onNotifyPhase():void
    {
      super.onNotifyPhase();
      
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
  }
}
