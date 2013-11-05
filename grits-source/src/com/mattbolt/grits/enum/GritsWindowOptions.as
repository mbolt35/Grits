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

package com.mattbolt.grits.enum {

    //----------------------------------
    //  imports
    //----------------------------------


    /**
     * This class contains an enumeration of possible window options stored in the
     * configuration file.
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class GritsWindowOptions {

        //--------------------------------------------------------------------------
        //
        //  Constants
        //
        //--------------------------------------------------------------------------

        /**
         * This option is used to always keep the window on top.
         */
        public static const ALWAYS_ON_TOP:String = "alwaysOnTop";

        /**
         * This option is used to keep the window on top of all other windows until
         * all connections have been closed.
         */
        public static const DURING_CONNECTIONS:String = "duringConnection";

        /**
         * This option is used when the user wants the window to pop up on top
         * of all other windows when a client makes a connection.
         */
        public static const ON_CONNECT:String = "onConnect";

        /**
         * This option is used when the window behavior is normal.
         */
        public static const NORMAL:String = "normal";

        /**
         * This constant contains a list of nodes that can be easily thrown in flex ui.
         */
        public static const ALL_OPTIONS:Array = [
            { label: "Never", type: NORMAL },
            { label: "On a Connection", type: ON_CONNECT },
            { label: "While Connections are Open", type: DURING_CONNECTIONS },
            { label: "Always", type: ALWAYS_ON_TOP },
        ];

    }

}
