package reflex.utils
{
  import flash.utils.Dictionary;

  public class Utility
  {
    private static const implMap:Dictionary = new Dictionary(false);
    
    public static function registerUtility(forAPI:Class, implInstance:Object):void
    {
      implMap[forAPI] = implInstance;
    }
    
    public static function getUtility(forAPI:Class):Object
    {
      var impl:Object;
      
      if(forAPI in implMap)
        impl = implMap[forAPI];
      
      return forAPI(impl);
    }
    
    public static function resolve(forAPI:Class, resolveFunc:String, ...params):*
    {
      var impl:Object = getUtility(forAPI);
      
      if(!impl || !(resolveFunc in impl))
        return;
      
      var func:Function = (impl[resolveFunc] as Function);
      
      return func.apply(null, params);
    }
  }
}