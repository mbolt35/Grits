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
    
    
    [Bindable]
    
    /**
     * This class contains a list of color configuration combinations for log types.
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class GritsColorConfiguration {
        
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
         * <code>GritsColorConfiguration</code> Constructor.
         */
        public function GritsColorConfiguration() {
            
        }
        
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * This property contains the color mapping for the INFO log type.
         */
        public var flashTraceColor:uint = 0xFFFFFF;
        
        /**
         * This property contains the color mapping for the INFO log type.
         */
        public var infoColor:uint = 0xFFFF95;
        
        /**
         * This property contains the color mapping for the WARN log type.
         */
        public var warnColor:uint = 0xFF9933;
        
        /**
         * This property contains the color mapping for the DEBUG log type.
         */
        public var debugColor:uint = 0xAAD4FF;
        
        /**
         * This property contains the color mapping for the WARNING log type.
         */
        public var warningColor:uint = 0xFFBB78;
        
        /**
         * This property contains the color mapping for the ERROR log type.
         */
        public var errorColor:uint = 0xFF1313;
        
        /**
         * This property contains the color mapping for the FATAL log type.
         */
        public var fatalColor:uint = 0xD90303;
        
        
        // TODO: Add the following:
        
        // CONFIG
        // FINEST
        // FINER
        // SYSTEM
        // SEVERE
        // TEMP
        // TRACE
        // FINE
    }
    
}
