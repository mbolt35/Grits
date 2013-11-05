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

package com.mattbolt.grits.controller {
    
    import com.mattbolt.grits.Grits;
    import com.mattbolt.grits.net.GritsDeliveryDetails;
    
    
    /**
     * This interface is used to prototype a view controller which allows custom 
     * implementations of the UI to be passed to the <code>Grits</code> instance.
     * 
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public interface IGritsViewController {
        
        /**
         * This method prototype defines the initializer which should use the <code>GritsConfiguration</code>
         * instance to determine ui specifics.
         *
         * @param   grits The <code>Grits</code> instance used to initialize the view
         */
        function init(grits:Grits):void;
        
        /**
         * This method prototype defines a delivery path for the log messages to be 
         * pushed to the view.
         * 
         * @param   logSessionId The <code>String</code> identifier (localAddress:localPort)
         * used to determine the unique id for the log.
         * 
         * @param   delivery The <code>GritsDeliveryDetails</code> used to push the delivery
         * to the UI.
         */
        function pushLog(logSessionId:String, delivery:GritsDeliveryDetails):void;
        
        /**
         * This method prototype defines a way to "end" the log session. The session will be considered
         * dead, but the UI will able to keep the log view open, save it to disk, etc...
         */
        function endLog(logSessionId:String):void;
    }
}