package reflex.skins
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.InteractiveObject;
  import flash.display.Sprite;
  import flash.events.EventDispatcher;
  
  import flight.binding.Bind;
  import flight.events.ListEvent;
  import flight.events.ListEventKind;
  import flight.events.PropertyEvent;
  import flight.list.ArrayList;
  import flight.list.IList;
  
  import mx.core.IStateClient2;
  
  import reflex.display.IContainer;
  import reflex.events.StateEvent;
  import reflex.layout.ILayoutAlgorithm;
  import reflex.layout.Layout;
  
  /**
   * Skin is a convenient base class for many skins, a swappable graphical
   * definition. Skins decorate a target Sprite by drawing on its surface,
   * adding children to the Sprite, or both.
   */
  [DefaultProperty("children")]
  public class Skin extends EventDispatcher implements ISkin, IContainer, IStateClient2
  {
    public static const DRAW:String = "draw";
    
    [Bindable]
    public var layout:ILayoutAlgorithm;
    
    [Bindable]
    public var data:Object;
    
    [Bindable]
    public var states:Array = [];
    
    protected var containerPart:DisplayObjectContainer;
    protected var defaultContainer:Boolean = true;
    private var _target:Sprite;
    private var _children:IList = new ArrayList();
    
    public function Skin()
    {
      _children.addEventListener(ListEvent.LIST_CHANGE, onChildrenChange);
      Bind.addListener(this, onLayoutChange, this, "target.layout");
      Bind.addListener(this, onLayoutChange, this, "layout");
      Bind.addBinding(this, "data", this, "target.data");
      Bind.addBinding(this, "state", this, "target.state");
    }
    
    private var _state:String;
    
    [Bindable]
    public function get state():String
    {
      return _state;
    }
    
    public function set state(value:String):void
    {
      if(value === _state)
        return;
      
      StateEvent.change(this, _state, value);
      _state = value;
    }
    
    [Bindable]
    public function get target():Sprite
    {
      return _target;
    }
    
    public function set target(value:Sprite):void
    {
      if(_target == value)
      {
        return;
      }
      
      if(_target)
        detachSkin(_target);
      
      var oldValue:Object = _target;
      _target = value;
      
      if(_target)
        attachSkin(_target);
      
      PropertyEvent.dispatchChange(this, "target", oldValue, _target);
      init();
    }
    
    protected function attachSkin(target:Sprite):void
    {
      var skinnable:ISkinnable = target as ISkinnable;
      
      for(var i:int = 0; i < children.length; i++)
      {
        attachSkinPart(children.getItemAt(i), target);
      }
      
      if(!skinnable)
        return;
      
      containerPart = getSkinPart("container") as DisplayObjectContainer;
      if(!containerPart)
        return;
      
      skinnable.children.addEventListener(ListEvent.LIST_CHANGE, onContentChange, false, 0xF);
      
      if(skinnable.children.length <= 0)
        return;
      
      defaultContainer = false;
      Bind.addBinding(containerPart, "padding", this, "target.padding");
      
      while(containerPart.numChildren)
      {
        removeContainerChildAt(containerPart.numChildren - 1);
      }
      
      for(i = 0; i < skinnable.children.length; i++)
      {
        addContainerChildAt(skinnable.children.getItemAt(i) as DisplayObject, i);
      }
    }
    
    protected function detachSkin(target:Sprite):void
    {
      var skinnable:ISkinnable = target as ISkinnable;
      
      if(skinnable)
        skinnable.children.removeEventListener(ListEvent.LIST_CHANGE, onContentChange);
      
      for(var i:int = 0; i < children.length; i++)
      {
        detachSkinPart(children.getItemAt(i), target);
      }
    }
    
    protected function attachSkinPart(part:Object, to:Sprite):void
    {
      if(part is DisplayObject)
      {
        to.addChild(part as DisplayObject);
      }
      //Should we put the 'target' property in an interface? ITargetable?
      else if("target" in part)
      {
        part["target"] = to;
      }
    }
    
    protected function detachSkinPart(part:Object, from:Sprite):void
    {
      if(part is DisplayObject)
      {
        from.removeChild(part as DisplayObject);
      }
      //Should we put the 'target' property in an interface? ITargetable?
      else if("target" in part)
      {
        part["target"] = null;
      }
    }
    
    protected function init():void
    {
    }
    
//    [ArrayElementType("flash.display.DisplayObject")]
    public function get children():IList
    {
      return _children;
    }
    
    public function set children(value:*):void
    {
      if(value is Array)
      {
        _children.removeItems();
        _children.addItems(value);
      }
      else if(value is IList)
      {
        _children.addItems(IList(value).getItems());
      }
      else
      {
        _children.addItem(value);
      }
    }
    
    public function getSkinPart(part:String):InteractiveObject
    {
      return(part in this) ? this[part] : null;
    }
    
    private function onChildrenChange(event:ListEvent):void
    {
      if(_target == null)
      {
        return;
      }
      var child:DisplayObject;
      var loc:int = event.location1;
      switch(event.kind)
      {
        case ListEventKind.ADD:
          for each(child in event.items)
          {
            _target.addChildAt(child, loc++);
          }
          break;
        case ListEventKind.REMOVE:
          for each(child in event.items)
          {
            _target.removeChild(child);
          }
          break;
        case ListEventKind.REPLACE:
          _target.removeChild(event.items[1]);
          _target.addChildAt(event.items[0], loc);
          break;
        case ListEventKind.RESET:
          while(_target.numChildren)
          {
            _target.removeChildAt(_target.numChildren - 1);
          }
          for(var i:int = 0; i < _children.length; i++)
          {
            _target.addChildAt(_children.getItemAt(i) as DisplayObject, i);
          }
          break;
      }
    }
    
    private function onContentChange(event:ListEvent):void
    {
      event.stopImmediatePropagation();
      var skinnable:ISkinnable = _target as ISkinnable;
      if(defaultContainer)
      {
        defaultContainer = false;
        Bind.addBinding(containerPart, "padding", this, "target.padding");
        while(containerPart.numChildren)
        {
          removeContainerChildAt(containerPart.numChildren - 1);
        }
      }
      
      var child:DisplayObject;
      var loc:int = event.location1;
      switch(event.kind)
      {
        case ListEventKind.ADD:
          for each(child in event.items)
          {
            addContainerChildAt(child, loc++);
          }
          break;
        case ListEventKind.REMOVE:
          for each(child in event.items)
          {
            removeContainerChild(child);
          }
          break;
        case ListEventKind.REPLACE:
          removeContainerChild(event.items[1]);
          addContainerChildAt(event.items[0], loc);
          break;
        case ListEventKind.RESET:
          while(containerPart.numChildren)
          {
            removeContainerChildAt(containerPart.numChildren - 1);
          }
          for(var i:int = 0; i < skinnable.children.length; i++)
          {
            addContainerChildAt(skinnable.children.getItemAt(i) as DisplayObject, i);
          }
          break;
      }
      
      trace("invalidate");
      var containerLayout:Layout = Layout.getLayout(containerPart);
      if(containerLayout != null)
      {
        containerLayout.invalidate(true);
      }
    }
    
    protected function addContainerChildAt(child:DisplayObject, index:int):DisplayObject
    {
      if(containerPart is IContainer)
      {
        return IContainer(containerPart).children.addItemAt(child, index) as DisplayObject;
      }
      else
      {
        return containerPart.addChildAt(child, index);
      }
    }
    
    protected function removeContainerChildAt(index:int):DisplayObject
    {
      if(containerPart is IContainer)
      {
        return IContainer(containerPart).children.removeItemAt(index) as DisplayObject;
      }
      else
      {
        return containerPart.removeChildAt(index);
      }
    }
    
    protected function removeContainerChild(child:DisplayObject):DisplayObject
    {
      if(containerPart is IContainer)
      {
        return IContainer(containerPart).children.removeItem(child) as DisplayObject;
      }
      else
      {
        return containerPart.removeChild(child);
      }
    }
    
    private function onLayoutChange(value:ILayoutAlgorithm):void
    {
      if(_target == null)
      {
        return;
      }
      
      var targetLayout:Layout = Layout.getLayout(_target);
      
      if(containerPart != null && _target is ISkinnable)
      {
        var skinnable:ISkinnable = _target as ISkinnable;
        var containerLayout:Layout = Layout.getLayout(containerPart);
        if(containerLayout != null)
        {
          containerLayout.algorithm = skinnable.layout;
        }
        else if(targetLayout != null)
        {
          containerLayout = new targetLayout["constructor"]();
          containerLayout.target = containerPart;
          containerLayout.algorithm = skinnable.layout;
        }
      }
      
      if(targetLayout != null)
      {
        targetLayout.algorithm = layout;
      }
    }
    
    public function get currentState():String
    {
      return state;
    }
    
    public function set currentState(value:String):void
    {
      state = value;
    }
  }
}
