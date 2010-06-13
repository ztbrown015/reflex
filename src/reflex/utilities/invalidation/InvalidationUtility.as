package reflex.utilities.invalidation
{
  import flash.display.DisplayObject;
  import flash.display.Stage;
  import flash.events.Event;
  import flash.events.EventPhase;
  import flash.events.IEventDispatcher;
  import flash.utils.Dictionary;
  import flash.utils.setTimeout;

  /**
  * All credit to Tyler Wright (http://xtyler.com) for this utility.
  * 
  * @alpha
  */
  public class InvalidationUtility implements IInvalidationUtility
  {
    private var phaseList:Array = [];
    private var phaseIndex:Object = {};
    
    public function registerPhase(name:String, priority:int = 0, ascending:Boolean = true):void
    {
      phaseIndex[name] = phaseIndex[name] || new ValidationPhase(name, priority, ascending);
      
      if(phaseList.indexOf(phaseIndex[name]) == -1)
        phaseList.push(phaseIndex[name]);
      
      phaseList.sortOn("priority");
    }
    
    private var depths:Dictionary = new Dictionary(true);
    private var rendering:Boolean = false;
    
    public function invalidate(element:DisplayObject, name:String):Boolean
    {
      if(!(phaseIndex[name]))
        throw new ArgumentError("DisplayObject cannot be invalidated in unknown phase '" + name + "'.");
      
      var phase:ValidationPhase = phaseIndex[name];
      if(phase.hasElement(element))
        return false;
      
      var hasStage:Boolean = element.stage != null;
      
      element.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0xF, true);
      element.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0xF, true);
      
      // This is safe beacuse in the case that depths[element] == 0, getDepth will return 0 anyway.
      var depth:int = depths[element] = depths[element] || getDepth(element);
      
      phase.addElement(element, hasStage ? depth : -1);
      
      if(!hasStage)
        return false;
      
      if(!rendering)
        invalidateStage(element.stage);
      else if((phase.ascending && depth <= phase.depth) || (!phase.ascending && depth >= phase.depth))
        setTimeout(invalidateStage, 0, element.stage);
      
      return true;
    }
    
    public function render():void
    {
      rendering = true;
      
      validateStages();
      
      var index:int = 0;
      var length:int = phaseList.length;
      
      for(; index < length; index++)
      {
        ValidationPhase(phaseList[index]).render();
      }
      
      rendering = false;
    }
    
    private var invalidStages:Dictionary = new Dictionary(true);
    
    private function invalidateStage(stage:Stage):void
    {
      invalidStages[stage] = true;
      stage.addEventListener(Event.RENDER, onRender, false, 0xF, true);
      stage.addEventListener(Event.RESIZE, onRender, false, 0xF, true);
      stage.invalidate();
    }
    
    private function validateStages():void
    {
      for(var stage:* in invalidStages)
      {
        IEventDispatcher(stage).removeEventListener(Event.RENDER, onRender);
        IEventDispatcher(stage).removeEventListener(Event.RESIZE, onRender);
      }
    }
    
    private function onRender(event:Event):void
    {
      render();
    }
    
    private function getDepth(element:DisplayObject):int
    {
      var depth:int = 0;
      while((element = element.parent) != null)
      {
        depth++;
        // if a parent already has depth defined, take the shortcut
        if(depths[element])
        {
          depth += depths[element];
          break;
        }
      }
      
      return depth;
    }
    
    // Do some investigation, but I think this will also auto-invalidate children
    // of the originally invalidated DisplayObject. It's a weak listener, but 
    // still possible?
    private function onAddedToStage(event:Event):void
    {
      var element:DisplayObject = DisplayObject(event.target);
      
      depths[element] = getDepth(element);
      
      for each(var phase:ValidationPhase in phaseList)
      {
        if(!phase.hasElement(element))
          continue;
        
        phase.removeElement(element);
        invalidate(element, phase.type);
      }
    }
    
    private function onRemovedFromStage(event:Event):void
    {
      var element:DisplayObject = DisplayObject(event.target);
      
      delete depths[element];
      
      for each(var phase:ValidationPhase in phaseList)
      {
        if(!phase.hasElement(element))
          continue;
        
        phase.removeElement(element);
        phase.addElement(element, -1);
      }
    }
  }
}

import flash.display.DisplayObject;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import reflex.events.InvalidationEvent;

internal class ValidationPhase
{
  private var _ascending:Boolean = true;
  private var _priority:int = 0;
  
  private var _type:String;
  private var depths:Array = [];
  private var pos:int = -1;
  private var invalidated:Dictionary = new Dictionary(true);
  
  public function ValidationPhase(type:String, priority:int = 0, ascending:Boolean = true)
  {
    _type = type;
    _ascending = ascending;
    _priority = priority;
  }
  
  public function get ascending():Boolean
  {
    return _ascending;
  }
  
  public function get priority():int
  {
    return _priority;
  }
  
  public function get type():String
  {
    return _type;
  }
  
  public function get depth():int
  {
    return pos;
  }
  
  public function render():void
  {
    if(depths.length == 0)
      return;
    
    var begin:int = ascending ? -1 : depths.length;
    var end:int = ascending ? depths.length : 0;
    var direction:int = ascending ? 1 : -1;
    var pre:Dictionary;
    var current:Dictionary;
    var element:*;
    
    for(pos = begin; pos != end; pos += direction)
    {
      if(depths[pos] == null)
      {
        continue;
      }
      
      // replace current dictionary with a clean one before new cycle
      pre = current;
      current = depths[pos];
      depths[pos] = pre;
      
      for(element in current)
      {
        IEventDispatcher(element).dispatchEvent(new InvalidationEvent(type));
        
        delete current[element];
        delete invalidated[element];
      }
    }
    
    pos = -1;
  }
  
  public function addElement(element:DisplayObject, depth:int):void
  {
    if(depths[depth] == null)
      depths[depth] = new Dictionary(true);
    
    depths[depth][element] = true;
    invalidated[element] = depth;
  }
  
  public function removeElement(element:DisplayObject):void
  {
    delete depths[invalidated[element]][element];
    delete invalidated[element];
  }
  
  public function hasElement(element:DisplayObject):Boolean
  {
    return invalidated[element];
  }
}