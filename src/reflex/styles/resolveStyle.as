package reflex.styles
{
  public function resolveStyle(child:Object, property:String, standard:* = null):Object
  {
    if('style' in child && child['style'] != null)
      return child['style'][property];
    
    return standard;
  }

}