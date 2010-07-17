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

    //----------------------------------
    //  imports
    //----------------------------------

    import mx.utils.StringUtil;


    /**
     * This class represents a logging delivery via socket connection.
     *
     * @author Matt Bolt <mbolt35&#64;gmail.com>
     */
    public class GritsDeliveryDetails {

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * the log text
         */
        private var _logText:String;

        /**
         * @private
         * the key
         */
        private var _key:String;

        /**
         * @private
         * log command
         */
        private var _command:String;

        /**
         * @private
         * the logger tag
         */
        private var _tag:String;


        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * <code>GritsDeliveryDetails</code> Constructor.
         */
        public function GritsDeliveryDetails(command:String, logText:String, key:String, tag:String) {
            _command = command;
            _logText = logText;
            _key = key;
            _tag = tag;
        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        /**
         * This method displays the <code>String</code> conversion of the object.
         *
         * @return  The <code>String</code> conversion of this instance.
         */
        public function toString():String {
            return StringUtil.substitute(
                "[GritsDeliveryDetails - command: {0}, key: {1}, tag: {2}]",
                command,
                key,
                tag);
        }

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        /**
         * This property contains the log text to display to the logger window.
         */
        public function get logText():String {
            return _logText;
        }

        /**
         * This property contains the key (ie: DEBUG, FATAL, etc...) used to display the
         * log text/
         */
        public function get key():String {
            return _key;
        }

        /**
         * This property represents what kind of tag to use for the
         */
        public function get tag():String {
            return _tag;
        }

        /**
         * This property contains the command used to display the log.
         */
        public function get command():String {
            return _command;
        }

    }

}
