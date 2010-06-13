package reflex.layouts
{
  import flash.geom.Point;
  
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  
  [Style(name="hAlign", type="String", enumeration="left,center,right")]
  [Style(name="vAlign", type="String", enumeration="top,middle,bottom")]
  [Style(name="hGap", type="Number")]
  [Style(name="vGap", type="Number")]
  
  public class AlgorithmicLayout extends Layout
  {
    override public function update(children:Array):void
    {
      super.update(children);
      
      if(!children || children.length == 0)
        return;
      
      var dimensions:Point = getDimensions(null, false);
      
      var position:Number = padding.left;
      var length:int = children.length;
      var child:Object;
      
      for(var i:int = 0; i < length; i++)
      {
        child = children[i];
        position = algorithm(children, i, position);
      }
    }
    
    protected function algorithm(children:Array, index:int, position:Number):Number
    {
      var child:Object = children[index];
      
      Utility.resolve(<>ILayoutUtility.move</>,
                      child,
                      Utility.resolve(<>ILayoutUtility.getX</>, child),
                      Utility.resolve(<>ILayoutUtility.getY</>, child));
      
      return position;
    }
    
    protected function get horizontalAlign():Number
    {
      var align:String = getStyle('hAlign') || 'left';
      switch(align)
      {
        case 'left':
          return 0;
        case 'center':
          return 0.5;
        case 'right':
          return 1;
      }
      
      return 0;
    }
    
    protected function get verticalAlign():Number
    {
      var align:String = getStyle('vAlign') || 'top';
      
      switch(align)
      {
        case 'top':
          return 0;
        case 'middle':
          return 0.5;
        case 'bottom':
          return 1;
      }
      
      return 0;
    }
  }
}