////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
//  AdobePatentID="B770"
//
////////////////////////////////////////////////////////////////////////////////

package mx.states
{

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import mx.states.OverrideBase;

/**
 *  The event handler function to execute in response to the event that is
 *  specified by the <code>name</code> property. 
 *
 *  <p>Do not specify the <code>handler</code> property and the <code>handlerFunction</code>
 *  property in a single <code>&lt;mx:SetEventHandler&gt;</code> tag.</p>
 *
 *  <p>Flex does <i>not</i> dispatch a <code>handler</code> event.
 *  You use the <code>handler</code> key word only as an MXML attribte. 
 *  When you use the <code>handler</code> handler attribute, you can specify a 
 *  method that takes multiple parameters, not just the Event object;
 *  also, you can specify the handler code in-line in the MXML tag.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="handler", type="Object")]

/**
 *  The SetEventHandler class specifies an event handler that is active 
 *  only during a particular view state.
 *  For example, you might define a Button control that uses one event handler 
 *  in the base view state, but uses a different event handler when you change view state.
 *
 *  <p> You use this class in the <code>overrides</code> property of the State class.</p>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:SetEventHanlder&gt;</code> tag
 *  has the following attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:SetEventHandler
 *  <b>Properties</b>
 *  name="null"
 *  handlerFunction="null"
 *  target="null"
 *  
 *  <b>Events</b>
 *  handler=<i>No default</i>
 *  /&gt;
 *  </pre>
 *
 *  @see mx.states.State
 *  @see mx.states.SetProperty
 *  @see mx.states.SetStyle
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SetEventHandler extends OverrideBase implements IOverride
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param target The object that dispatches the event to be handled.
     *  By default, Flex uses the immediate parent of the State object.
     *
     *  @param event The event type for which to set the handler.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SetEventHandler(
            target:EventDispatcher = null,
            name:String = null)
    {
        super();

        this.target = target;
        this.name = name;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Storage for the old event handler value.
     */
    private var oldHandlerFunction:Function;

    /**
     *  @private
     *  Dictionary of installed event handlers.
     */
    private static var installedHandlers:Dictionary;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  name
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  The name of the event whose handler is being set.
     *  You must set this property, either in 
     *  the SetEventHandler constructor or by setting
     *  the property value directly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var name:String;

    /**
     *  The handler function for the event.
     *  This property is intended for developers who use ActionScript to
     *  create and access view states.
     *  In MXML, you can use the equivalent <code>handler</code>
     *  event attribute; do not use both in a single MXML tag.
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var handlerFunction:Function;

    //----------------------------------
    //  target
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  The component that dispatches the event.
     *  If the property value is <code>null</code>, Flex uses the
     *  immediate parent of the <code>&lt;mx:states&gt;</code> tag.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var target:Object;

    /**
     *  The cached target for which we applied our override.
     *  We keep track of the applied target while applied since
     *  our target may be swapped out in the owning document and 
     *  we want to make sure we roll back the correct (original) 
     *  element. 
     *
     *  @private
     */
    private var appliedTarget:Object;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: EventDispatcher
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function addEventListener(
                                    type:String, listener:Function,
                                    useCapture:Boolean = false,
                                    priority:int = 0,
                                    useWeakReference:Boolean = false):void
    {
        if (type == "handler")
            handlerFunction = listener;

        super.addEventListener(type, listener, useCapture,
                               priority, useWeakReference);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  IOverride interface method; this class implements it as an empty method.
     * 
     *  @copy IOverride#initialize()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function initialize():void
    {
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function apply(parent:Object):void
    {
        var obj:* = getOverrideContext(target, parent);
        if (obj != null)
        {
        	appliedTarget = obj;
//	        var uiObj:UIComponent = obj as UIComponent;
	
	        if (!installedHandlers)
	            installedHandlers = new Dictionary(true);
	            
	        // Remember the current handler so it can be restored
	        if (installedHandlers[obj] && installedHandlers[obj][name])
	        {
	            oldHandlerFunction = installedHandlers[obj][name];
	            obj.removeEventListener(name, oldHandlerFunction);
	        }
//	        else if (uiObj && uiObj.descriptor)
//	        {
//	            var descriptor:ComponentDescriptor = uiObj.descriptor;
//	
//	            if (descriptor.events && descriptor.events[name])
//	            {
//	                oldHandlerFunction = uiObj.document[descriptor.events[name]];
//	                obj.removeEventListener(name, oldHandlerFunction);
//	            }
//	        }
	
	        // Set new handler as weak reference
	        if (handlerFunction != null)
	        {
	            obj.addEventListener(name, handlerFunction, false, 0, true);
	            
	            // Add this handler to our installedHandlers list so it can
	            // be removed if needed by a state based on this state.
	            if (installedHandlers[obj] == undefined)
	                installedHandlers[obj] = {};
	            
	            installedHandlers[obj][name] = handlerFunction;
	        }
        }
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function remove(parent:Object):void
    {
        var obj:* = getOverrideContext(appliedTarget, parent);
        if (obj != null)
        {
	        if (handlerFunction != null)
	            obj.removeEventListener(name, handlerFunction);
	
	        // Restore the old value
	        if (oldHandlerFunction != null)
	            obj.addEventListener(name, oldHandlerFunction, false, 0, true);
	        
	        if (installedHandlers[obj])
	        {
	            var deleteObj:Boolean = true;
	            
	            // Remove this handler
	            delete installedHandlers[obj][name];
	
	            // If no other handlers are installed for this object, delete
	            // this object from the installedHandlers dictionary
	            for (var i:String in installedHandlers[obj])
	            {
	                // Found one - don't delete this object
	                deleteObj = false;
	                break;
	            }
	
	            if (deleteObj)
	                delete installedHandlers[obj];
	        }
        }
        appliedTarget = null;
    }
}

}
