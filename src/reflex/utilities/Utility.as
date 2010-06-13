package reflex.utilities
{
  import flash.utils.Dictionary;
  
  public class Utility
  {
    private static const implMap:Dictionary = new Dictionary(false);
    
    public static function registerUtility(forAPI:Object, impl:Object):void
    {
      implMap[getName(forAPI)] = impl;
    }
    
    public static function getUtility(forAPI:Object):Object
    {
      var name:String = getName(forAPI);
      
      if(name in implMap)
        return implMap[name];
      
      return null;
    }
    
    private static function getName(forObject:Object):String
    {
      if(forObject is Class)
        return forObject.toString();
      else if(forObject is String)
      {
        return '[class ' + (forObject.toString().indexOf("::") == -1 ?
          forObject.toString() :
          forObject.toString().split("::").pop()) + ']';
      }
      
      throw new Error("Can't understand the type you are attempting to retrieve a name for.");
    }
    
    /**
     * Resolves functions on implementations held by Utility.
     * Pass in SomeInterface.functionToResolve as the first parameter and it
     * will call functionToResolve on the registered impl for SomeInterface.
     */
    public static function resolve(resolvePath:String, ... params):*
    {
      var obj:Array = resolvePath.split('.');
      var method:String = obj.pop();
      var className:String = obj.pop();
      
      var impl:Object = getUtility(className);
      
      if(!impl || !(method in impl) || !(impl[method] is Function))
        return;
      
      return (impl[method] as Function).apply(null, params);
    }
  }
}