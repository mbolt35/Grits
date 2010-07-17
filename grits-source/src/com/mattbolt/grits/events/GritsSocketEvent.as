////////////////////////////////////////////////////////////////////////////////
//
//  MATTBOLT.BLOGSPOT.COM
//  Copyright(C) 2010 Matt Bolt
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

package com.mattbolt.grits.events {

    import flash.events.Event;


    /**
     * This event class is used to notify objects of a grits socket event.
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class GritsSocketEvent extends Event {

        //--------------------------------------------------------------------------
        //
        //  Event Types
        //
        //--------------------------------------------------------------------------

        /**
         * @eventType socketLog
         */
        public static const SOCKET_LOG:String = "socketLog";

        /**
         * @eventType closedConnection
         */
        public static const CLOSED_CONNECTION:String = "closedConnection";


        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * the log delivery
         */
        private var _message:String;


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
         * @param message The <code>String</code> transferred via the socket.
         */
        public function GritsSocketEvent(type:String, message:String) {
            super(type, false, false);

            _message = message;
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
            return new GritsSocketEvent(type, _message);
        }

        /**
         * @inheritDoc
         */
        public override function toString():String {
            return formatToString("GritsSocketEvent", "type", "message", "bubbles", "cancelable", "eventPhase");
        }


        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        /**
         * This property contains a log delivery to be parsed and displayed.
         */
        public function get message():String {
            return _message;
        }

    }

}
