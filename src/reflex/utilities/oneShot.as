package reflex.utilities
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  
  /**
   * Returns a function that automatically removes the event listener after an
   * event is dispatched the first time. Pass this as the second argument to
   * IEventDispatcher#addEventListener, passing in the real handler:
   * <code>dispatcher.addEventListener("someEvent", oneShot(someEventHandler, dispatcher));</code>
   *
   * This will also drop off the event argument if your handler function doesn't
   * accept any arguments, so you can write a handler like this:
   * <code>function onSomeEvent():void
   * {
   *   //Do stuff
   * }</code>
   */
  public function oneShot(func:Function, scope:IEventDispatcher):Function
  {
    var handler:Function = function(event:Event):void{
        scope.removeEventListener(event.type, handler);
        func.length != 0 ? func(event) : func();
      }
    
    return handler;
  }
}