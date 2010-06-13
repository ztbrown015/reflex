package reflex.utilities
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  
  /**
   * Returns a function that will selectively pass in the event argument to
   * an event listener depending on whether that listener accepts an argument.
   *
   * If the second argument is specified, the handler will automatically
   * remove the event listener after the first time the event is fired.
   *
   * <code>
   * function someFunction(){
   *   // Do something without reference to the event.
   * }
   * dispatcher.addEventListener("someEvent", oneShot(someFunction, dispatcher));
   * </code>
   */
  public function listen(func:Function, oneShotScope:IEventDispatcher = null):Function
  {
    var handler:Function =
      function(event:Event):void
      {
        if(oneShotScope)
          oneShotScope.removeEventListener(event.type, handler);
        func.length != 0 ? func(event) : func();
      }
    
    return handler;
  }
}