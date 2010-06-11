package reflex.components
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.events.Event;
  
  import reflex.display.Container;
  import reflex.display.IContainer;
  import reflex.events.InvalidationEvent;

  public class SkinnableContainer extends Component
  {
    public function SkinnableContainer()
    {
      super();
    }
    
    private var _container:Object;
    private var containerChanged:Boolean = false;
    [Bindable(event="containerChanged")]
    
    public function get container():Object
    {
      return _container;
    }
    
    public function set container(value:Object):void
    {
      if(_container == value)
        return;
      
      _container = value;
      invalidateNotifications();
      invalidateChildren();
    }
    
    override public function addSkinPart(part:Object, name:String):Object
    {
      if(name == 'container')
        super.addSkinPart(part, name);
      else
      {
        if(name in this)
          this[name] = part;
        
        children.push(part);
        invalidateChildren();
      }
      
      return part;
    }
    
    override public function removeSkinPart(part:Object, name:String):Object
    {
      if(name == 'container')
        super.removeSkinPart(part, name);
      else
      {
        if(name in this)
          this[name] = part;
        
        children.splice(children.indexOf(part), 1);
        invalidateChildren();
      }
      
      return part;
    }
    
    override protected function onNotifyPhase():void
    {
      super.onNotifyPhase();
      
      if(containerChanged)
        dispatchEvent(new Event("containerChanged"));
    }
    
    override protected function onChildrenPhase():void
    {
      super.onChildrenPhase();
      
      if(containerChanged)
      {
        var copy:Array = children.concat();
        
        if(container is IContainer)
        {
          IContainer(container).children = copy;
        }
        else if(container is DisplayObjectContainer)
        {
          while(DisplayObjectContainer(container).numChildren)
            DisplayObjectContainer(container).removeChildAt(0);
          
          while(copy.length)
            DisplayObjectContainer(container).addChild(copy.shift());
        }
      }
      
      containerChanged = false;
    }
  }
}