package reflex.display
{
  public interface IInvalidating
  {
    function invalidateNotifications():void;
    function invalidateChildren():void;
    function invalidateSize():void;
    function invalidateLayout():void;
  }
}