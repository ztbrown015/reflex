package reflex.utilities.styles
{
  import reflex.styles.IStyleAware;

  public class StyleUtility implements IStyleUtility
  {
    public function hasStyle(object:Object, styleProp:String):Boolean
    {
      if(object is IStyleAware)
        return IStyleAware(object).getStyle(styleProp) != null;
      
      if('getStyle' in object && object['getStyle'] is Function)
        return (object['getStyle'](styleProp) != null);
      
      if('style' in object && object['style'] != null)
        return (object['style'][styleProp] != null);
      
      return false;
    }
    
    public function getStyle(object:Object, styleProp:String):*
    {
      if(object is IStyleAware)
        return IStyleAware(object).getStyle(styleProp);
      
      if('getStyle' in object && object['getStyle'] is Function)
        return object['getStyle'](styleProp);
      
      if('style' in object && object['style'] != null)
        return object['style'][styleProp];
      
      return null;
    }
    
    public function setStyle(object:Object, styleProp:String, newValue:*=null):void
    {
      if(object is IStyleAware)
        IStyleAware(object).setStyle(styleProp, newValue);
      else if('setStyle' in object && object['setStyle'] is Function)
        object['setStyle'](styleProp, newValue);
      else if('style' in object && object['style'] != null)
        object['style'][styleProp] = newValue;
    }
  }
}