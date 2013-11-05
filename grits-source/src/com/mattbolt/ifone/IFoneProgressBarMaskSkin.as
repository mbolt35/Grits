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

package com.mattbolt.ifone {
    
    import flash.display.Graphics;
    
    import mx.skins.ProgrammaticSkin;
    
    
    /**
     * This class represents the mask which alters the percentage fill on a progress bar
     * styled like the iphone.
     * 
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class IFoneProgressBarMaskSkin extends ProgrammaticSkin {        
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         * Creates a new <code>IFoneProgressBarMaskSkin</code>
         */
        public function IFoneProgressBarMaskSkin() {
            super();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Override Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * @inheritDoc
         */        
        protected override function updateDisplayList(w:Number, h:Number):void {
            super.updateDisplayList(w, h);
            
            with (graphics) {
                clear();
                beginFill(0xFFFF00);
                drawRoundRect(3, 2, w - 4, h - 4, 10, 10);
                endFill();
            }
        }        
        
    }
}       