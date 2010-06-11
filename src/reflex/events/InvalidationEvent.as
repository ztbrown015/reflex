package reflex.events
{
  import flash.events.Event;
  
  /**
   * @alpha
   **/
  public class InvalidationEvent extends Event
  {
    public function InvalidationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
      super(type, bubbles, cancelable);
    }
    
    override public function clone():Event
    {
      return new InvalidationEvent(type, bubbles, cancelable);
    }
  }
}