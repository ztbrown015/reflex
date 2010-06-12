package reflex.layouts
{
  import flash.display.DisplayObjectContainer;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.utils.Dictionary;
  
  import reflex.display.IContainer;
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  import reflex.utilities.metadata.IMetadataUtility;
  
//  [LayoutProperty(name="measurements", measure="true")]
//  [LayoutProperty(name="layout", measure="false")]
  /**
   * @alpha
   **/
  public class Layout extends EventDispatcher
  {
    private var attached:Dictionary = new Dictionary(true);
    
    [Bindable]
    public var target:IEventDispatcher;
    
    public function Layout()
    {
      Utility.resolve(<>IMetadataUtility.resolveBindings</>, this);
      Utility.resolve(<>IMetadataUtility.resolveEventListeners</>, this);
      Utility.resolve(<>IMetadataUtility.resolvePropertyListeners</>, this);
    }
    
    public function measure(children:Array):Point
    {
      return new Point();
    }
    
    public function update(children:Array, rectangle:Rectangle):void
    {
    }
    
    private function onMeasure():void
    {
      if(!target)
        return;
      
      var children:Array;
      
      if(target is IContainer)
        children = IContainer(target).children;
      else if(target is DisplayObjectContainer)
      {
        children = []
        var index:int = -1;
        var numChildren:int = DisplayObjectContainer(target).numChildren;
        while(++index < numChildren)
          children.push(DisplayObjectContainer(target).getChildAt(index));
      }
      
      var size:Point = measure(children);
      
      Utility.resolve(<>ILayoutUtility.setSize</>, target, size.x, size.y);
    }
    
    private function onLayout():void
    {
      if(!target)
        return;
      
      var children:Array;
      
      if(target is IContainer)
        children = IContainer(target).children;
      else if(target is DisplayObjectContainer)
      {
        children = []
        var index:int = -1;
        var numChildren:int = DisplayObjectContainer(target).numChildren;
        while(++index < numChildren)
          children.push(DisplayObjectContainer(target).getChildAt(index));
      }
      
      update(children, new Rectangle());
    }
  }
}