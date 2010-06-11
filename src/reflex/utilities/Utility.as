package reflex.utilities
{
  import flash.utils.Dictionary;

  public class Utility
  {
    private static const implMap:Dictionary = new Dictionary(false);
    
    public static function registerUtility(forAPI:Class, implInstance:Object):void
    {
      implMap[forAPI.toString()] = implInstance;
    }
    
    public static function getUtility(forAPI:Class):Object
    {
      var impl:Object;
      
      if(forAPI.toString() in implMap)
        impl = implMap[forAPI.toString()];
      
      return forAPI(impl);
    }
    
    /**
    * Resolves functions on implementations held by Utility.
    * Pass in SomeInterface.functionToResolve as the first parameter and it
    * will call functionToResolve on the registered impl for SomeInterface.
    */
    public static function resolve(resolveFunc:String, ...params):*
    {
      var impl:Object = getUtility(resolveFunc.split('.').shift());
      
      resolveFunc = resolveFunc.split('.').pop();
      
      if(!impl || !(resolveFunc in impl))
        return;
      
      var func:Function = (impl[resolveFunc] as Function);
      
      return func.apply(null, params);
    }
  }
}