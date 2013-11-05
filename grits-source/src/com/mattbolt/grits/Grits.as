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

package com.mattbolt.grits {

    //----------------------------------
    //  imports
    //----------------------------------

    import com.mattbolt.grits.config.GritsConfiguration;
    import com.mattbolt.grits.controller.IGritsViewController;
    import com.mattbolt.grits.events.GritsServerEvent;
    import com.mattbolt.grits.events.GritsTransportEvent;
    import com.mattbolt.grits.net.IGritsServer;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;


    /**
     * This class acts as the main controller for the application.
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class Grits extends EventDispatcher implements IEventDispatcher {

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * the grits server instance
         */
        private var _server:IGritsServer;

        /**
         * @private
         * the grits configuration
         */
        private var _gritsConfiguration:GritsConfiguration;

        /**
         * @private
         * the ui view controller
         */
        private var _viewController:IGritsViewController;


        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * <code>Grits</code> Constructor.
         */
        public function Grits( server:IGritsServer,
                               config:GritsConfiguration,
                               viewController:IGritsViewController )
        {
            _server = server;
            _gritsConfiguration = config;
            _viewController = viewController;

            _gritsConfiguration.load();
            _viewController.init(this);
            
            _server.addEventListener(GritsTransportEvent.DELIVERY, onDelivery);
        }


        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        /**
         * This method starts the socket output server. Once this is called, the server
         * will bind to the local address/port and listen for connections.
         */
        public function start():void {
            _server.start();
        }

        /**
         * This method stops the socket output server. It will close all current connections
         * and refuse to except any further connections.
         */
        public function stop():void {
            _server.stop();
        }

        /**
         * @private
         * this message handles the log delivery transport
         */
        private function onDelivery(event:GritsTransportEvent):void {
            _viewController.pushLog(sessionIdFor(event), event.delivery);
        }
        
        /**
         * @private
         * this message returns the session id for a delivery.
         */
        private function sessionIdFor(event:GritsTransportEvent):String {
            return event.remoteAddress + ":" + event.remotePort.toString();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        [Bindable(event=GritsConfigurationEvent.CONFIGURATION_CHANGED)]
        
        /**
         * This property contains the grits application configuration.
         */
        public function get config():GritsConfiguration {
            return _gritsConfiguration;
        }

        [Bindable(event=GritsServerEvent.GRITS_SERVER_CHANGED)]

        /**
         * This property contains the instance of the grits server implementation.
         */
        public function get server():IGritsServer {
            return _server;
        }

    }

}
