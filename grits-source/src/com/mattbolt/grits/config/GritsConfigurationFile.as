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

package com.mattbolt.grits.config {

    //----------------------------------
    //  imports
    //----------------------------------

    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    
    import mx.utils.StringUtil;


    [Bindable]

    /**
     * This class contains the representation of the locally store configuration
     * file.
     *
     * @author Matt Bolt <mbolt35&#64;gmail.com>
     */
    public class GritsConfigurationFile extends EventDispatcher implements IEventDispatcher {

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
         * <code>GritsConfigurationFile</code> Constructor.
         */
        public function GritsConfigurationFile() {

        }


        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        /**
         * This method creates and returns the <code>String</code> representation of
         * this object.
         *
         * @return
         */
        public override function toString():String {
            return StringUtil.substitute(
                "Use Tabbed View: {0}, Window Mode: {1}, Save Logs: {2}",
                useTabbedView,
                windowMode,
                saveLogs);
        }

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        /**
         * This property is set to the last known x-axis position of the grits window.
         * 
         * @default 10
         */
        public var xPosition:Number;
        
        /**
         * This property is set to the last known y-axis position of the grits window.
         * 
         * @default 10
         */
        public var yPosition:Number;
        
        /**
         * This property is set to <code>true</code> if the user wishes to use a tab
         * based log view.
         *
         * @default true
         */
        public var useTabbedView:Boolean;

        /**
         * This property contains the desired window mode.
         *
         * @default normal
         *
         * @see com.mattbolt.grits.enum.GritsWindowOptions
         */
        public var windowMode:String;

        /**
         * This property is set to <code>true</code> if the user wishes that the logs be
         * saved on the local file system.
         *
         * @default false
         */
        public var saveLogs:Boolean;
        
        /**
         * This property is set to <code>true</code> if the user wishes to import the flash
         * trace <code>logfile.txt</code> into their logs.
         * 
         * @default false
         */
        public var flashTraceEnabled:Boolean
        
        /**
         * This property contains the file location of the flash log file.
         */
        public var flashLogFileLocation:String;
        
        /**
         * This property contains the log color configuration
         */
        public var colorConfig:GritsColorConfiguration = new GritsColorConfiguration();

    }

}
