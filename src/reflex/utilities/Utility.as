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
      return (forObject is Class) ? forObject.toString() : '[class ' + forObject.toString() + ']';
    }
    
    /**
    * Resolves functions on implementations held by Utility.
    * Pass in SomeInterface.functionToResolve as the first parameter and it
    * will call functionToResolve on the registered impl for SomeInterface.
    */
    public static function resolve(resolvePath:String, ...params):*
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