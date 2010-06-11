package reflex.layouts
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.utils.Dictionary;
  
  import reflex.display.Container;
  import reflex.display.DisplayPhases;
  import reflex.display.IContainer;
  import reflex.display.IInvalidating;
  import reflex.utilities.Utility;
  import reflex.utilities.invalidation.IInvalidationUtility;
  import reflex.utilities.metadata.IMetadataUtility;
  import reflex.utilities.oneShot;
  
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
      // this method of listening for layout invalidating changes is very much experimental
      for each(var child:IEventDispatcher in children)
      {
        if(attached[child] != true)
        {
          Utility.resolve(<>IMetadataUtility.resolveLayoutProperties</>, this, child, invalidateSize);
          attached[child] = true;
        }
      }
      
      return new Point(0, 0);
    }
    
    public function update(children:Array, rectangle:Rectangle):void
    {
      // this method of listening for layout invalidating changes is very much experimental
      for each(var child:IEventDispatcher in children)
      {
        if(attached[child] != true)
        {
          Utility.resolve(<>IMetadataUtility.resolveLayoutProperties</>, this, child, invalidateLayout);
          attached[child] = true;
        }
      }
    }
    
    protected function invalidateSize(... args):void
    {
      if(!target || !(target is DisplayObject))
        return;
      
      DisplayPhases.invalidateSize(DisplayObject(target), onMeasure);
    }
    
    protected function invalidateLayout(... args):void
    {
      if(!target || !(target is DisplayObject))
        return;
      
      DisplayPhases.invalidateLayout(DisplayObject(target), onMeasure);
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
      
      measure(children);
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