package reflex.layouts
{
  import flash.display.DisplayObjectContainer;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  
  import mx.events.PropertyChangeEvent;
  import mx.events.PropertyChangeEventKind;
  
  import reflex.display.DisplayPhases;
  import reflex.display.IMeasurable;
  import reflex.styles.IStyleAware;
  import reflex.styles.StyleAwareActor;
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  import reflex.utilities.listen;
  import reflex.utilities.metadata.IMetadataUtility;
  import reflex.utilities.styles.IStyleUtility;
  
  [Style(name="padding", type="reflex.layouts.Padding")]
  [Style(name="paddingLeft", type="Number")]
  [Style(name="paddingRight", type="Number")]
  [Style(name="paddingTop", type="Number")]
  [Style(name="paddingBottom", type="Number")]
  
  /**
   * @alpha
   **/
  public class Layout extends StyleAwareActor implements ILayout, IStyleAware
  {
    public function Layout(target:DisplayObjectContainer = null)
    {
      Utility.resolve(<>IMetadataUtility.resolveBindings</>, this);
      Utility.resolve(<>IMetadataUtility.resolveEventListeners</>, this);
      Utility.resolve(<>IMetadataUtility.resolvePropertyListeners</>, this);
      
      padding.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
      addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
      addEventListener('stylesChanged', onStylesChanged);
      
      this.target = target;
    }
    
    override public function get style():Object
    {
      return target && 'style' in target ? target['style'] : super.style;
    }
    
    public function get padding():Padding
    {
      var padding:Padding = getStyle('padding');
      
      if(padding)
        return padding;
      
      setStyle('padding', new Padding());
      
      return getStyle('padding');
    }
    
    public function set padding(value:Padding):void
    {
      if(value == getStyle('padding') || !value)
        return;
      
      setStyle('padding', value);
    }
    
    private var _target:DisplayObjectContainer;
    
    [Bindable(event="targetChanged")]
    
    public function get target():DisplayObjectContainer
    {
      return _target;
    }
    
    public function set target(newTarget:DisplayObjectContainer):void
    {
      if(_target)
        detachFrom(_target);
      
      _target = newTarget;
      
      if(_target)
        attachTo(_target);
      
      dispatchEvent(new Event("targetChanged"));
    }
    
    protected function detachFrom(target:DisplayObjectContainer):void
    {
      target.addEventListener("stylesChanged", onPropertyChange);
    }
    
    protected function attachTo(target:DisplayObjectContainer):void
    {
      target.addEventListener("stylesChanged", onPropertyChange);
      
      //Copy any cached style values over to the new target instance.
      if(styles && style)
        for(var styleProp:String in styles)
          if(target is IStyleAware)
            IStyleAware(target).setStyle(styleProp, styles[styleProp]);
          else
            style[styleProp] = styles[styleProp];
    }
    
    public function measure(children:Array):Point
    {
      return new Point();
    }
    
    public function update(children:Array):void
    {
      if(!children || children.length == 0)
        return;
      
      // We only have to process percentage based children here because those 
      // that measure or have explicit dimensions have already set them in measure.
      
      var usedSpace:Point = new Point();
      
      var percentChildren:Array = [];
      
      var percent:Point = new Point(NaN, NaN);
      var margin:Padding = new Padding(NaN, NaN, NaN, NaN);
      var totalPercent:Point = new Point();
      
      var index:int = 0;
      var length:int = children.length;
      var child:Object;
      
      for(; index < length; index++)
      {
        child = children[index];
        
        percent.x = Utility.resolve(<>ILayoutUtility.getPercentWidth</>, child);
        
        if(isNaN(percent.x))
          usedSpace.x += Utility.resolve(<>ILayoutUtility.getWidth</>, child);
        else
          totalPercent.x += percent.x;
        
        margin.left = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginLeft'));
        usedSpace.x += isNaN(margin.left) ? 0 : margin.left;
        
        margin.right = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginRight'));
        usedSpace.x += isNaN(margin.right) ? 0 : margin.right;
        
        percent.y = Utility.resolve(<>ILayoutUtility.getPercentHeight</>, child);
        
        if(isNaN(percent.y))
          usedSpace.y += Utility.resolve(<>ILayoutUtility.getHeight</>, child);
        else
          totalPercent.y += percent.y;
        
        margin.top = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginTop'));
        usedSpace.y += isNaN(margin.top) ? 0 : margin.top;
        
        margin.bottom = parseFloat(Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginBottom'));
        usedSpace.y += isNaN(margin.bottom) ? 0 : margin.bottom;
        
        if(!isNaN(percent.x) || !isNaN(percent.y))
          percentChildren.push(child);
        
        percent.x = NaN;
        percent.y = NaN;
        margin.left = NaN;
        margin.right = NaN;
        margin.top = NaN;
        margin.bottom = NaN;
      }
      
      index = 0;
      length = percentChildren.length;
      
      totalPercent.x = Math.max(totalPercent.x, 100);
      totalPercent.y = Math.max(totalPercent.y, 100);
      
      var percentRatio:Point = getPercentRatio(totalPercent, length);
      var total:Point = getDimensions(usedSpace, true, children);
      
      var size:Point = new Point();
      
      for(; index < length; index++)
      {
        child = percentChildren[index];
        
        percent.x = Utility.resolve(<>ILayoutUtility.getPercentWidth</>, child, total.x) * percentRatio.x;
        percent.y = Utility.resolve(<>ILayoutUtility.getPercentHeight</>, child, total.y) * percentRatio.y;
        
        size.x = percent.x || Utility.resolve(<>ILayoutUtility.getWidth</>, child);
        size.y = percent.y || Utility.resolve(<>ILayoutUtility.getHeight</>, child);
        
        if(percent.x)
        {
          margin.left = Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginLeft');
          margin.right = Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginRight');
          
          size.x -= isNaN(margin.left) ? 0 : margin.left;
          size.x -= isNaN(margin.right) ? 0 : margin.right;
        }
        if(percent.y)
        {
          margin.top = Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginTop');
          margin.bottom = Utility.resolve(<>IStyleUtility.getStyle</>, child, 'marginBottom');
          
          size.y -= isNaN(margin.top) ? 0 : margin.top;
          size.y -= isNaN(margin.bottom) ? 0 : margin.bottom;
        }
        
        Utility.resolve(<>ILayoutUtility.setSize</>, child, size.x, size.y);
      }
    }
    
    protected function getDimensions(usedSpace:Point = null, withPadding:Boolean = true, children:Array = null):Point
    {
      if(!target)
        return new Point();
      
      if(!usedSpace)
        usedSpace = new Point();
      
      if(withPadding)
        return new Point(target.width - padding.left - padding.right,
                         target.height - padding.top - padding.bottom).subtract(usedSpace);
      else
        return new Point(target.width, target.height).subtract(usedSpace);
    }
    
    protected function getPercentRatio(total:Point, numChildren:Number):Point
    {
      var point:Point = total.clone();
      point.x /= (numChildren * 2)
      point.y /= (numChildren * 2);
      point.x *= .01;
      point.y *= .01;
      
      return point;
    }
    
    private function onMeasure():void
    {
      if(!target)
        return;
      
      var size:Point = measure(Utility.resolve(<>ILayoutUtility.getChildren</>, target));
      
      var width:Number = size.x;
      var height:Number = size.y;
      
      if(target is IMeasurable)
      {
        width = isNaN(IMeasurable(target).explicitWidth) ? size.x : IMeasurable(target).explicitWidth;
        height = isNaN(IMeasurable(target).explicitHeight) ? size.y : IMeasurable(target).explicitHeight;
      }
      
      Utility.resolve(<>ILayoutUtility.setSize</>, target, width, height);
    }
    
    private function onLayout():void
    {
      if(!target)
        return;
      
      update(Utility.resolve(<>ILayoutUtility.getChildren</>, target));
    }
    
    public function invalidate():void
    {
      if(!target)
        return;
      
      // Make sure this guy doesn't have a percentWidth/percentHeight that we're 
      // overriding by setting his size. For example, if this function is run
      // because the padding properties changed, we really only need to re-run the
      // layout phase.
      if(isNaN(Utility.resolve(<>ILayoutUtility.getPercentWidth</>, target)) && isNaN(Utility.resolve(<>ILayoutUtility.getPercentHeight</>, target)))
        DisplayPhases.invalidateSize(target, listen(onMeasure, target));
      
      DisplayPhases.invalidateLayout(target, listen(onLayout, target));
    }
    
    private function onPropertyChange(event:Event):void
    {
      invalidate();
    }
    
    protected function onStylesChanged(event:PropertyChangeEvent):void
    {
      var styleProp:String = event.property.toString();
      
      if(styleProp.indexOf("padding") > 0)
      {
        var prop:String = String(styleProp.split('padding').pop()).toLowerCase();
        padding[prop] = getStyle(styleProp);
      }
      
      invalidate();
    }
  }
}