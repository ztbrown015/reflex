package reflex.graphics
{
  import flash.display.Sprite;

  public class Rect extends Graphic
  {
    public function Rect(target:Sprite = null)
    {
      super(target);
    }
    
    override protected function renderGraphic():void
    {
      super.renderGraphic();
      
      g.lineStyle(2, 0x00, 1, true);
      g.beginFill(0x00, 0.5);
      g.drawRect(x, y, width, height);
      g.endFill();
    }
  }
}