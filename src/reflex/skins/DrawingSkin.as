package reflex.skins
{
  import flash.display.Graphics;
  
  import flight.binding.Bind;
  
  import reflex.events.InvalidationEvent;
  import reflex.utilities.Utility;
  import reflex.utilities.invalidation.IInvalidationUtility;
  import reflex.utilities.oneShot;
  
  public class DrawingSkin extends Skin
  {
    static public const DRAW:String = "draw";
    Utility.resolve(<>IInvalidationUtility.registerPhase</>, DRAW);
    
    public function DrawingSkin()
    {
      Bind.addListener(this, invalidateRedraw, this, "target");
      Bind.addListener(this, invalidateRedraw, this, "state");
      Bind.addListener(this, invalidateRedraw, this, "target.width");
      Bind.addListener(this, invalidateRedraw, this, "target.height");
      Bind.bindEventListener(DRAW, onDraw, this, "target");
    }
    
    public function invalidateRedraw():void
    {
      if(!target)
        return;
      
      target.addEventListener(DRAW, oneShot(onDraw, target));
      Utility.resolve(<>IInvalidationUtility.invalidate</>, target, DRAW);
    }
    
    public function redraw(graphics:Graphics):void
    {
    }
    
    protected function onDraw(event:InvalidationEvent):void
    {
      if(target == null)
        return;
      
      redraw(target.graphics);
    }
  }
}