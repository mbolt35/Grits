////////////////////////////////////////////////////////////////////////////////
//
//  MATTBOLT.BLOGSPOT.COM
//  Copyright(C) 2010 Matt Bolt
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at:
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package com.mattbolt.ifone.events {
    
    import flash.events.Event;
    
    
    /**
     * This event class is dispatched via the <code>IFoneWindow</code> class on a specific
     * action.
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class IFoneWindowEvent extends Event {
        
        //--------------------------------------------------------------------------
        //
        //  Event Types
        //
        //--------------------------------------------------------------------------
        
        /**
         * @eventType backClick
         */
        public static const BACK_CLICK:String = "backClick";
        
        /**
         * @eventType closeClick
         */
        public static const CLOSE_CLICK:String = "closeClick";
        
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         * Constructor.
         *
         * @param type The event type; indicates the action that caused the event.
         *
         * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
         *
         * @param cancelable Specifies whether the behavior associated with
         * the event can be prevented.
         */
        public function IFoneWindowEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            
        }
        
        
        //--------------------------------------------------------------------------
        //
        //  Override Methods: Event
        //
        //--------------------------------------------------------------------------
        
        /**
         * @inheritDoc
         */
        public override function clone():Event {
            return new IFoneWindowEvent(type, bubbles, cancelable);
        }
        
        /**
         * @inheritDoc
         */
        public override function toString():String {
            return formatToString("IFoneWindowEvent", "type", "bubbles", "cancelable", "eventPhase");
        }
        
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
    }
    
}
