package reflex.skins
{
  import mx.core.IDataRenderer;

  public interface IDataSkin extends ISkin
  {
    function get template():IDataRenderer;
  }
}