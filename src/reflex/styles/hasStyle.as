package reflex.styles
{
  public function hasStyle(child:Object, styleProp:String):Boolean
  {
    if('style' in child && child['style'] != null)
      return (child['style'][styleProp] != null);
    
    return false;
  }

}