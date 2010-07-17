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

package com.mattbolt.grits.net {
    import com.mattbolt.grits.messaging.IGritsMessageParser;

    //----------------------------------
    //  imports
    //----------------------------------


    /**
     * This class generates <code>GritsServer</code> instances.
     *
     * @author Matt Bolt <mbolt35@gmail.com>
     */
    public class DefaultGritsServerFactory implements IGritsServerFactory {

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * <code>DefaultGritsServerFactory</code> Constructor.
         */
        public function DefaultGritsServerFactory() {

        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        /**
         * This method generates <code>IGritsServer</code> implementation instances used to power
         * the grits application.
         *
         * @param	address The server address to bind to.
         *
         * @param	port The server port to bind to.
         *
         * @param	messageParser An <code>IGritsMessageParser</code> used to parse messages recieved by the
         * connected clients.
         *
         * @return <code>IGritsServer</code>
         */
        public function gritsServer(address:String, port:int, messageParser:IGritsMessageParser):IGritsServer {
            return new GritsServer(address, port, messageParser);
        }

    }

}
