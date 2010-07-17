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

    import com.mattbolt.grits.messaging.IGritsMessageParserFactory;
    import com.mattbolt.grits.net.IGritsServerFactory;

    import flash.display.DisplayObjectContainer;


    /**
     * This class is used to build a <code>Grits</code> controller instance used
     * to manage the application.
     *
     * @author Matt Bolt <mbolt35&#64;gmail.com>
     */
    public class GritsBuilder {

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * the address to bind to
         */
        private var _address:String = "localhost";

        /**
         * @private
         * the port to bind to
         */
        private var _port:int = 4444;

        /**
         * @private
         * grits server instance
         */
        private var _server:IGritsServerFactory;

        /**
         * @private
         * the message parser used
         */
        private var _parser:IGritsMessageParserFactory;

        /**
         * @private
         * the parent container for the ui
         */
        private var _container:DisplayObjectContainer;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * <code>GritsBuilder</code> Constructor.
         */
        public function GritsBuilder() {

        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        public function withServer(server:IGritsServerFactory):GritsBuilder {
            _server = server;

            return this;
        }

        public function boundTo(address:String, port:int):GritsBuilder {
            _address = address;
            _port = port;

            return this;
        }

        public function parsingMessagesWith(parser:IGritsMessageParserFactory):GritsBuilder {
            _parser = parser;

            return this;
        }

        public function usingContainer(container:DisplayObjectContainer):GritsBuilder {
            _container = container;

            return this;
        }

        public function build():Grits {
            return new Grits(
                _server.gritsServer(_address, _port, _parser.parser()),
                _container);
        }

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

    }

}
