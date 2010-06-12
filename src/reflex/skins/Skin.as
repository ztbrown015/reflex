package reflex.skins
{
  import flash.display.DisplayObject;
  import flash.display.InteractiveObject;
  import flash.display.Sprite;
  import flash.events.EventDispatcher;
  
  import mx.core.IStateClient2;
  
  import reflex.utilities.Utility;
  import reflex.utilities.metadata.IMetadataUtility;
  import reflex.utilities.states.IStateUtility;
  
  [DefaultProperty("children")]
  
  /**
   * Skin is a convenient base class for many skins, a swappable graphical
   * definition. Skins decorate a target Sprite by drawing on its surface,
   * adding children to the Sprite, or both.
   * @alpha
   */
  public class Skin extends EventDispatcher implements ISkin, IStateClient2 //, IMeasurable
  {
    public function Skin()
    {
      Utility.resolve(<>IMetadataUtility.resolveBindings</>, this);
    }
    
    private var _children:Array;
    [ArrayElementType("Object")]
    
    public function get children():Array
    {
      return _children;
    }
    
    public function set children(values:Array):void
    {
      _children = [].concat(values);
    }
    
    private var _currentState:String;
    
    [Binding(target="target.currentState")]
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
    }
    
    [Bindable]
    public var states:Array;
    
    private var _target:Sprite;
    
    public function get target():Sprite
    {
      return _target;
    }
    
    public function set target(value:Sprite):void
    {
      if(_target == value)
        return;
      
      if(target)
        detachFrom(target);
      
      _target = value;
      
      if(target)
        attachTo(target);
    }
    
    protected function attachTo(target:Sprite):void
    {
      if('hostComponent' in this)
        this['hostComponent'] = target;
      
      var copy:Array = children.concat();
      while(copy.length)
      {
        attachSkinPart(copy.shift(), target);
      }
    }
    
    protected function detachFrom(target:Sprite):void
    {
      if('hostComponent' in this)
        this['hostComponent'] = null;
      
      var copy:Array = children.concat();
      while(copy.length)
      {
        detachSkinPart(copy.pop(), target);
      }
    }
    
    public function getSkinPart(part:String):InteractiveObject
    {
      return (part in this) ? this[part] : null;
    }
    
    protected function attachSkinPart(part:Object, to:Sprite):void
    {
      if(to is ISkinnable)
        ISkinnable(to).addSkinPart(part, 'id' in part ? part['id'] : '');
      else if(part is DisplayObject)
        to.addChild(DisplayObject(part));
    }
    
    protected function detachSkinPart(part:Object, from:Sprite):void
    {
      if(from is ISkinnable)
        ISkinnable(from).removeSkinPart(part, 'id' in part ? part['id'] : '');
      else if(part is DisplayObject)
        from.removeChild(DisplayObject(part));
    }
  }
}
