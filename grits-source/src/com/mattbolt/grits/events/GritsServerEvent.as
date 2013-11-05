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

package com.mattbolt.grits.events {

    import com.mattbolt.grits.net.GritsSocket;

    import flash.events.Event;


    /**
     * This event class is sent to notify other classes of changes in a grits server
     * implementation.
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class GritsServerEvent extends Event {

        //--------------------------------------------------------------------------
        //
        //  Event Types
        //
        //--------------------------------------------------------------------------

        /**
         * @eventType openedConnection
         */
        public static const OPENED_CONNECTION:String = "openedConnection";

        /**
         * @eventType closedConnection
         */
        public static const CLOSED_CONNECTION:String = "closedConnection";

        /**
         * @eventType gritsServerChanged
         */
        public static const GRITS_SERVER_CHANGED:String = "gritsServerChanged";


        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * the grits socket associated with the event
         */
        private var _socket:GritsSocket;


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
         * @param socket The <code>GritsSocket</code> used to open/close a connection.
         */
        public function GritsServerEvent(type:String, socket:GritsSocket) {
            super(type, false, false);

            _socket = socket;
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
            return new GritsServerEvent(type, _socket);
        }

        /**
         * @inheritDoc
         */
        public override function toString():String {
            return formatToString("GritsServerEvent", "type", "socket", "bubbles", "cancelable", "eventPhase");
        }


        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        /**
         * This property contains the <code>GritsSocket</code> used to start/close the
         * connection.
         */
        public function get socket():GritsSocket {
            return _socket;
        }

    }

}
