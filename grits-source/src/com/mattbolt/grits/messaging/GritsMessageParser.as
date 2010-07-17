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

package com.mattbolt.grits.messaging {

    //----------------------------------
    //  imports
    //----------------------------------

    import com.mattbolt.grits.net.GritsDeliveryDetails;


    /**
     * This class parses all of the logging messages sent to the server.
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class GritsMessageParser implements IGritsMessageParser {

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * <code>GritsMessageParser</code> Constructor.
         */
        public function GritsMessageParser() {

        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        /**
         * This method parses the raw <code>String</code> message sent to the server,
         * converts it into <code>GritsDeliveryDetails</code> ready for display in the
         * ui.
         *
         * @param	message The raw <code>String</code> message coming from the client.
         *
         * @return A <code>GritsDeliveryDetails</code> instance containing the parsed
         * message.
         */
        public function parse(message:String):GritsDeliveryDetails {
            var xmlIndex:int = message.indexOf("<");
            var xml:XML = XML(message.substring(xmlIndex));

            return new GritsDeliveryDetails(
                xml.name().toString(),
                xml.toString(),
                xml.@key,
                message.substring(0, xmlIndex));
        }

    }

}
