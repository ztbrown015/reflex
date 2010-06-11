package reflex.measurement
{
  /**
   * @alpha
   */
  public function resolveWidth(object:Object):Number
  {
    if(object && 'width' in object)
      return object['width'];
    
    return NaN;
  }
}