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

    import com.mattbolt.grits.enum.GritsWindowOptions;
    import com.mattbolt.grits.events.GritsConfigurationEvent;
    
    import flash.data.EncryptedLocalStore;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;

    //----------------------------------
    //  events
    //----------------------------------

    /**
     * @eventType com.mattbolt.grits.events.GritsConfigurationEvent.CONFIGURATION_CHANGED
     */
    [Event(name="configurationChanged", type="com.mattbolt.grits.events.GritsConfigurationEvent")]


    /**
     * This class is used to control the configuration options for the grits application.
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class GritsConfiguration extends EventDispatcher implements IEventDispatcher {

        //--------------------------------------------------------------------------
        //
        //  Constants
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * config file key for the encrypted local store
         */
        private static const CONFIG_FILE_KEY:String = "gritsConfiguration";


        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * the locally stored configuration file
         */
        private var _configFile:GritsConfigurationFile;


        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * <code>GritsConfiguration</code> Constructor.
         */
        public function GritsConfiguration() {
            registerClassAlias("GritsConfigurationFile", GritsConfigurationFile);
            registerClassAlias("GritsColorConfiguration", GritsColorConfiguration);
        }


        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        /**
         * This method loads the locally stored configuration file. If such a file does
         * not exist, then one will be created.
         */
        public function load():void {
            if (_configFile) {
                return;
            }

            var bytes:ByteArray = EncryptedLocalStore.getItem(CONFIG_FILE_KEY);

            if (!bytes || bytes.length <= 0) {
                _configFile = new GritsConfigurationFile();
                _configFile.xPosition = 10;
                _configFile.yPosition = 10;
                _configFile.saveLogs = true;
                _configFile.useTabbedView = true;
                _configFile.flashTraceEnabled = false;
                _configFile.flashLogFileLocation = "";
                _configFile.windowMode = GritsWindowOptions.NORMAL;

                save();
                return;
            }

            bytes.position = 0;

            _configFile = GritsConfigurationFile( bytes.readObject() );

            dispatchEvent(new GritsConfigurationEvent(GritsConfigurationEvent.CONFIGURATION_CHANGED));
        }

        /**
         * This method saves the existing configuration options to the local file system.
         */
        public function save():void {
            if (!_configFile) {
                return;
            }

            var bytes:ByteArray = new ByteArray();
            bytes.writeObject(_configFile);
            bytes.position = 0;

            EncryptedLocalStore.setItem(CONFIG_FILE_KEY, bytes);
        }

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        [Bindable(event=GritsConfigurationEvent.CONFIGURATION_CHANGED)]

        /**
         * This property contains the grits configuration file which the settings
         * are loaded into.
         */
        public function get configurationFile():GritsConfigurationFile {
            return _configFile;
        }


    }

}
