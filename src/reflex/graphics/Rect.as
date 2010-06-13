package reflex.graphics
{
  [Style(name="left")]
  [Style(name="right")]
  [Style(name="top")]
  [Style(name="bottom")]
  [Style(name="horizontalCenter")]
  [Style(name="verticalCenter")]
  [Style(name="dock")]
  [Style(name="align")]
  
  public class Rect extends Graphic
  {
    public function Rect()
    {
      super();
    }
    
    override protected function renderGraphic():void
    {
      super.renderGraphic();
      
      g.lineStyle(3, 0x00, 1, true);
      g.beginFill(0x00, 0.5);
      g.drawRect(x, y, width, height);
      g.endFill();
    }
  }
}