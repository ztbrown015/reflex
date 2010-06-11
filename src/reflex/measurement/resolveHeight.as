package reflex.measurement
{
  /**
   * @alpha
   */
  public function resolveHeight(object:Object):Number
  {
    if(object && 'height' in object)
      return object['height'];
    
    return NaN;
  }
}