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

    import com.mattbolt.grits.net.GritsDeliveryDetails;
    
    import flash.events.Event;


    /**
     * This event class is fired when the logging framework transports a log delivery
     * to the ui for display.
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class GritsTransportEvent extends Event {

        //--------------------------------------------------------------------------
        //
        //  Event Types
        //
        //--------------------------------------------------------------------------

        /**
         * @eventType delivery
         */
        public static const DELIVERY:String = "delivery";

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * the parsed delivery details from the socket
         */
        private var _delivery:GritsDeliveryDetails;
        
        /**
         * @private
         * local address of the socket
         */
        private var _remoteAddress:String;
        
        /**
         * @private
         * local port of the socket
         */
        private var _remotePort:int;


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
        public function GritsTransportEvent(type:String, remoteAddress:String, remotePort:int, delivery:GritsDeliveryDetails) {
            super(type, false, false);

            _remoteAddress = remoteAddress;
            _remotePort = remotePort;
            _delivery = delivery;
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
            return new GritsTransportEvent(type, _remoteAddress, _remotePort, _delivery);
        }

        /**
         * @inheritDoc
         */
        public override function toString():String {
            return formatToString("GritsTransportEvent", "type", "remoteAddress", "remotePort", "delivery", "bubbles", "cancelable", "eventPhase");
        }


        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        /**
         * This property contains the parsed <code>GritsDeliveryDetails</code> instance
         * sent by the client.
         */
        public function get delivery():GritsDeliveryDetails {
            return _delivery;
        }
        
        /**
         * This property contains the remote address of the socket connection
         */
        public function get remoteAddress():String {
            return _remoteAddress;
        }
        
        /**
         * This property contains the remote port of the socket connection.
         */
        public function get remotePort():int {
            return _remotePort;
        }

    }

}
