package reflex.components
{
  import reflex.behaviors.ButtonBehavior;
  import reflex.behaviors.SelectableBehavior;
  
  /**
   * @alpha
   **/
  public class Button extends Component
  {
    public function Button()
    {
      super();
      
      behaviors['button'] = new ButtonBehavior(this);
      behaviors['selectable'] = new SelectableBehavior(this);
    }
    
//    public var labelDisplay:TextField;
    
    private var _label:String;
    
    [Bindable(event="labelChanged")]
    [Inspectable(name="Label", type="String", defaultValue="Label")]
    
    public function get label():String
    {
      return _label;
    }
    
    public function set label(value:String):void
    {
      if(_label == value)
        return;
      
      _label = value;
      invalidateNotifications('labelChanged');
    }
    
    private var _selected:Boolean = false;
    
    [Bindable(event="selectedChanged")]
    [Inspectable(name="selected", type="Boolean", defaultValue="false")]
    
    public function get selected():Boolean
    {
      return _selected;
    }
    
    public function set selected(value:Boolean):void
    {
      if(_selected == value)
        return;
      
      _selected = value;
      invalidateNotifications('selectedChanged');
    }
  }
}