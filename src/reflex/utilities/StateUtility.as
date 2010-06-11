package reflex.utilities
{
  import mx.core.IStateClient2;
  import mx.core.mx_internal;
  import mx.events.StateChangeEvent;
  import mx.states.State;
  
  use namespace mx_internal;
  
  public class StateUtility implements IStateUtility
  {
    public function StateUtility()
    {
      super();
    }
    
    public function change(client:IStateClient2, from:String, to:String):void
    {
      this.client = client;
      
      var base:String = findCommonBaseState(from, to);
      
      initializeState(to);
      
      removeState(from, base);
      
      applyState(to, base);
      
      this.client = null;
    }
    
    private var client:IStateClient2;
    
    private function getState(name:String):State
    {
      for each(var state:State in client.states)
      {
        if(state.name == name)
          return state;
      }
      
      return null;
    }
    
    private function isBaseState(stateName:String):Boolean
    {
      return !stateName || stateName == "";
    }
    
    private function getBaseStates(state:State):Array
    {
      var baseStates:Array = [];
      
      // Push each basedOn name
      while(state && state.basedOn)
      {
        baseStates.push(state.basedOn);
        state = getState(state.basedOn);
      }
      
      return baseStates;
    }
    
    private function findCommonBaseState(from:String, to:String):String
    {
      var firstState:State = getState(from);
      var secondState:State = getState(to);
      
      // Quick exit if either state is the base state
      if(!firstState || !secondState)
        return "";
      
      // Quick exit if both states are not based on other states
      if(isBaseState(firstState.basedOn) && isBaseState(secondState.basedOn))
        return "";
      
      // Get the base states for each state and walk from the top
      // down until we find the deepest common base state.
      var firstBaseStates:Array = getBaseStates(firstState);
      var secondBaseStates:Array = getBaseStates(secondState);
      var commonBase:String = "";
      
      while((commonBase = firstBaseStates.pop()) == secondBaseStates.pop())
      {
        if(!firstBaseStates.length || !secondBaseStates.length)
          break;
      }
      
      // Finally, check to see if one of the states is directly based on the other.
      if(firstBaseStates.length && firstBaseStates[firstBaseStates.length - 1] == secondState.name)
        commonBase = secondState.name;
      else if(secondBaseStates.length && secondBaseStates[secondBaseStates.length - 1] == firstState.name)
        commonBase = firstState.name;
      
      return commonBase;
    }
    
    private function initializeState(stateName:String):void
    {
      var state:State = getState(stateName);
      while(state)
      {
        state.initialize();
        state = getState(state.basedOn);
      }
    }
    
    private function removeState(stateName:String, lastStateName:String):void
    {
      var state:State = getState(stateName);
      var overrides:Array;
      
      if(stateName == lastStateName)
        return;
      
      // Remove existing state overrides.
      // This must be done in reverse order
      if(state)
      {
        // Dispatch the "exitState" event
        state.dispatchExitState();
        
        overrides = state.overrides.concat();
        
        while(overrides.length > 0)
          overrides.pop().remove(client);
        
        // Remove any basedOn deltas last
        if(state.basedOn != lastStateName)
          removeState(state.basedOn, lastStateName);
      }
    }
    
    private function applyState(stateName:String, lastStateName:String):void
    {
      var state:State = getState(stateName);
      var overrides:Array;
      
      if(stateName == lastStateName)
        return;
      
      if(state)
      {
        // Apply "basedOn" overrides first
        if(state.basedOn != lastStateName)
          applyState(state.basedOn, lastStateName);
        
        // Apply new state overrides
        overrides = state.overrides.concat();
        
        while(overrides.length > 0)
          overrides.pop().apply(client);
        
        // Dispatch the "enterState" event
        state.dispatchEnterState();
      }
    }
  }
}
