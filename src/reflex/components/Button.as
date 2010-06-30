package reflex.components
{
    import flash.events.Event;
    
    import reflex.behaviors.ButtonBehavior;
    import reflex.behaviors.SelectableBehavior;
    
    [SkinState("over")]
    [SkinState("down")]
    
    /**
     * @alpha
     **/
    public class Button extends Component
    {
        public function Button()
        {
            super();
            
            var btn:ButtonBehavior = new ButtonBehavior(this);
            btn.addEventListener('currentStateChange', function(e:Event):void{currentState = btn.currentState;}, false, 0, true);
            
            behaviors['button'] = btn;
            behaviors['selectable'] = new SelectableBehavior(this);
        }
        
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