package reflex.layouts
{
  import flash.events.EventDispatcher;
  
  public class Padding extends EventDispatcher
  {
    public function Padding(left:Number = 0, right:Number = 0, top:Number = 0, bottom:Number = 0)
    {
      this.left = left;
      this.right = right;
      this.top = top;
      this.bottom = bottom;
    }
    
    [Bindable]
    public var left:Number = 0;
    
    [Bindable]
    public var right:Number = 0;
    
    [Bindable]
    public var top:Number = 0;
    
    [Bindable]
    public var bottom:Number = 0;
  }
}