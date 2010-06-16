package reflex.layouts
{
  import flash.display.DisplayObjectContainer;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import flash.utils.Dictionary;
  
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
  
  [Style(name="hAlign", type="String", enumeration="left,center,right")]
  [Style(name="vAlign", type="String", enumeration="top,middle,bottom")]
  [Style(name="gap", type="Number")]
  
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
      target.removeEventListener("stylesChanged", onPropertyChange);
      
      virtual.removeDimension('x');
      virtual.removeDimension('y');
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
      
      if('width' in target)
        virtual.addDimension('x');
      if('height' in target)
        virtual.addDimension('y');
    }
    
    public function measure(children:Array):Point
    {
      return new Point();
    }
    
    private var _virtual:Virtual;
    
    public function get virtual():Virtual
    {
      if(!_virtual)
        virtual = new Virtual();
      
      return _virtual;
    }
    
    public function set virtual(value:Virtual):void
    {
      if(value === _virtual)
        return;
      
      _virtual = value;
      invalidate();
    }
    
    public function update(children:Array):void
    {
      if(!children || children.length == 0)
        return;
      
      // We only have to process percentage based children here because those 
      // that measure or have explicit dimensions have already set them in measure.
      
      var dimensions:Object = virtual.dimensionNames;
      var dimension:String;
      
      var index:int = 0;
      var len:int = 0;
      
      var percentChildren:Dictionary = new Dictionary();
      var child:Object;
      
      var percent:Number = 0;
      var totalPercent:Number = 0;
      var numPercentChildren:int = 0;
      var usedSpace:Number = 0;
      var childSpace:Number = 0;
      var margin:Number = 0;
      var spaceForPercentChildren:Number = 0;
      var spacePerCent:Number = 0;
      var percentChildrenSpace:Number = 0;
      var excessSpace:Number = 0;
      
      var alignment:Number = 0;
      var position:Number = 0;
      var childPosition:int = 0;
      
      for(dimension in dimensions)
      {
        index = 0;
        len = children.length;
        
        for(; index < len; index++)
        {
          child = children[index];
          percent = getChildPercent(child, dimension);
          // This child doesn't have a percent size for this dimension
          if(isNaN(percent))
          {
            childSpace = getChildSpace(child, dimension);
            usedSpace += childSpace;
            
            if(child in percentChildren)
              delete percentChildren[child];
            
            virtual.hasItem(child, dimension) ?
              virtual.updateSize(child, childSpace, dimension) :
              virtual.add(child, childSpace, dimension);
            
            setChildSpace(child, dimension, childSpace);
          }
          // Has a percent size for this dimension, tally it up.
          else
          {
            totalPercent += percent;
            percentChildren[child] = true;
          }
          
          // Add any margins to the used space, we still want to count margins
          // even on children with percent sizes.
          margin = getMargin(child, dimension);
          if(!isNaN(margin))
            usedSpace += margin;
          
          percent = NaN;
          margin = NaN;
        }
        
        //  Get the total space left over in this dimension after subtracting the
        //  used space and the padding.
        spaceForPercentChildren = getLayoutSpace(dimension, true, usedSpace, children.length);
        
        //  Get the pixel values that 100% represents, a ratio of: space/cent (Space Per Cent)
        //  if(totalPercent >= 100) spacePerCent >= 1;
        //  if(totalPercent <= 100) spacePerCent <= 1;
        spacePerCent = getSpacePerCent(spaceForPercentChildren, totalPercent, dimension);
        
        //  Process the children with percent sizes in this dimension
        for(child in percentChildren)
        {
          //  The pixel value of the space this child takes up.
          childSpace = getChildPercent(child, dimension) * spacePerCent;
          margin = getMargin(child, dimension);
          
          //  Subtract this child's margins from his size.
          if(!isNaN(margin))
            childSpace -= margin;
          
          virtual.hasItem(child, dimension) ?
            virtual.updateSize(child, childSpace, dimension) :
            virtual.add(child, childSpace, dimension);
          
          //  Set his size in this dimension
          setChildSpace(child, dimension, childSpace);
          
          percentChildrenSpace += childSpace;
          
          delete percentChildren[child];
        }
        
        excessSpace = spaceForPercentChildren - percentChildrenSpace;
        
        index = 0;
        len = children.length;
        
        for(; index < len; index++)
        {
          child = children[index];
          
          childSpace = getChildSpace(child, dimension);
          
          if(index == 0)
            position = getLayoutPadding(dimension, -1) + excessSpace * (getAlignment(child, dimension) || 0);
          
          childPosition = getLayoutPosition(child, dimension, position);
          
          setLayoutPosition(child, dimension, childPosition);
          
          virtual.addAt(child, childPosition, childSpace, dimension);
          
          position = updateLayoutPosition(child, dimension, position);
        }
        
        alignment = 0;
        spacePerCent = 0;
        position = 0;
        childSpace = 0;
        excessSpace = 0;
        totalPercent = 0;
      }
    }
    
    protected function getChildSpace(child:Object, dimension:String):Number
    {
      if(dimension == 'x')
        return layoutUtil.getWidth(child);
      if(dimension == 'y')
        return layoutUtil.getHeight(child);
      
      return NaN;
    }
    
    protected function setChildSpace(child:Object, dimension:String, value:Number):void
    {
      if(dimension == 'x')
        layoutUtil.setSize(child, value, layoutUtil.getHeight(child));
      else if(dimension == 'y')
        layoutUtil.setSize(child, layoutUtil.getWidth(child), value);
    }
    
    protected function getChildPercent(child:Object, dimension:String):Number
    {
      if(dimension == 'x')
        return layoutUtil.getPercentWidth(child);
      if(dimension == 'y')
        return layoutUtil.getPercentHeight(child);
      
      return NaN;
    }
    
    protected function getAlignment(child:Object, dimension:String):Number
    {
      var alignment:String = '';
      
      if(dimension == 'x')
      {
        alignment = styleUtil.getStyle(child, 'hAlign');
        if(alignment === 'left')
          return 0;
        if(alignment === 'center')
          return 0.5;
        if(alignment === 'right')
          return 1;
      }
      else if(dimension == 'y')
      {
        alignment = styleUtil.getStyle(child, 'vAlign');
        if(alignment === 'top')
          return 0;
        if(alignment === 'middle')
          return 0.5;
        if(alignment === 'bottom')
          return 1;
      }
      
      return NaN;
    }
    
    protected function getMargin(child:Object, dimension:String, which:Number = 0):Number
    {
      var margin:Number = NaN;
      
      if(dimension == 'x')
      {
        margin = 0;
        if(which <= 0)
          margin += styleUtil.getStyle(child, 'marginLeft') || 0;
        if(which >= 0)
          margin += styleUtil.getStyle(child, 'marginRight') || 0;
      }
      else if(dimension == 'y')
      {
        margin = 0;
        if(which <= 0)
          margin += styleUtil.getStyle(child, 'marginTop') || 0;
        if(which >= 0)
          margin += styleUtil.getStyle(child, 'marginBottom') || 0;
      }
      
      return margin;
    }
    
    protected function getLayoutPosition(child:Object, dimension:String, currentPosition:Number):Number
    {
      if(dimension == 'x')
        return layoutUtil.getX(child);
      if(dimension == 'y')
        return layoutUtil.getY(child);
      
      return NaN;
    }
    
    protected function updateLayoutPosition(child:Object, dimension:String, currentPosition:Number):Number
    {
      return currentPosition;
    }
    
    protected function setLayoutPosition(child:Object, dimension:String, value:Number):void
    {
      if(dimension == 'x')
        layoutUtil.setX(child, value);
      if(dimension == 'y')
        layoutUtil.setY(child, value);
    }
    
    protected function getLayoutSpace(dimension:String, withPadding:Boolean = false, usedSpace:Number = 0, numChildren:int = 0):Number
    {
      var size:Number = 0;
      
      if(dimension == 'x')
        size = target.width - (withPadding ? padding.left + padding.right : 0);
      else if(dimension == 'y')
        size = target.height - (withPadding ? padding.top + padding.bottom : 0);
      
      return size - usedSpace;
    }
    
    protected function getLayoutPadding(dimension:String, which:Number = 0):Number
    {
      var value:Number = NaN;
      
      if(dimension == 'x')
      {
        value = 0;
        if(which <= 0)
          value += padding.left;
        if(which >= 0)
          value += padding.right;
      }
      else if(dimension == 'y')
      {
        value = 0;
        if(which <= 0)
          value += padding.top;
        if(which >= 0)
          value += padding.bottom;
      }
      
      return value;
    }
    
    protected function getSpacePerCent(totalSpace:Number, totalPercent:Number, dimension:String):Number
    {
      return totalSpace / Math.max(totalPercent, 100);
    }
    
    public function invalidate():void
    {
      if(!target)
        return;
      
      // Make sure this guy doesn't have a percentWidth/percentHeight that we're 
      // overriding by setting his size. For example, if this function is run
      // because the padding properties changed, we really only need to re-run the
      // layout phase.
      if(isNaN(layoutUtil.getPercentWidth(target)) && isNaN(layoutUtil.getPercentHeight(target)))
        DisplayPhases.invalidateSize(target, listen(onMeasure, target));
      
      DisplayPhases.invalidateLayout(target, listen(onLayout, target));
    }
    
    private function onMeasure():void
    {
      if(!target)
        return;
      
      var size:Point = measure(layoutUtil.getChildren(target));
      
      var width:Number = size.x;
      var height:Number = size.y;
      
      if(target is IMeasurable)
      {
        width = isNaN(IMeasurable(target).explicitWidth) ? size.x : IMeasurable(target).explicitWidth;
        height = isNaN(IMeasurable(target).explicitHeight) ? size.y : IMeasurable(target).explicitHeight;
      }
      
      layoutUtil.setSize(target, width, height);
    }
    
    private function onLayout():void
    {
      if(!target)
        return;
      
      update(layoutUtil.getChildren(target));
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
    
    private var layoutUtility:ILayoutUtility;
    protected function get layoutUtil():ILayoutUtility
    {
      if(!layoutUtility)
        layoutUtility = ILayoutUtility(Utility.getUtility(ILayoutUtility));
      
      return layoutUtility;
    }
    
    private var styleUtility:IStyleUtility;
    protected function get styleUtil():IStyleUtility
    {
      if(!styleUtility)
        styleUtility = IStyleUtility(Utility.getUtility(IStyleUtility));
      
      return styleUtility;
    }
  }
}