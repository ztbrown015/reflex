package reflex.measurement
{
  import reflex.display.ReflexDisplay;

  public function setSize(child:Object, newWidth:Number, newHeight:Number):void
  {
    if(child is ReflexDisplay)
      ReflexDisplay(child).setSize(newWidth, newHeight);
    else
    {
      if('width' in child)
        child['width'] = newWidth;
      if('height' in child)
        child['height'] = newHeight;
    }
  }
}