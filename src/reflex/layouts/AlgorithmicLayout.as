package reflex.layouts
{
  import flash.geom.Point;
  
  import reflex.utilities.Utility;
  import reflex.utilities.layout.ILayoutUtility;
  import reflex.utilities.styles.IStyleUtility;
  
  [Style(name="hAlign", type="String", enumeration="left,center,right")]
  [Style(name="vAlign", type="String", enumeration="top,middle,bottom")]
  [Style(name="gap", type="Number")]
  
  public class AlgorithmicLayout extends Layout
  {
    override public function update(children:Array):void
    {
      super.update(children);
      
      if(!children || children.length == 0)
        return;
      
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
    
    protected function getHorizontalAlign(object:Object):Number
    {
      var align:String = Utility.resolve(<>IStyleUtility.getStyle</>, object, 'hAlign') || 'left';
      
      if(align == 'center')
        return 0.5;
      else if(align == 'right')
        return 1;
      
      return 0;
    }
    
    protected function getVerticalAlign(object:Object):Number
    {
      var align:String = Utility.resolve(<>IStyleUtility.getStyle</>, object, 'vAlign') || 'top';
      
      if(align == 'middle')
        return 0.5;
      else if(align == 'bottom')
        return 1;
      
      return 0;
    }
  }
}