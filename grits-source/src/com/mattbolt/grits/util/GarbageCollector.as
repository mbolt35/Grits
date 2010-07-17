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

package com.mattbolt.grits.util {

    //----------------------------------
    //  imports
    //----------------------------------

    import __AS3__.vec.Vector;

    import flash.display.DisplayObject;
    import flash.utils.Dictionary;


    /**
     * This class collects any implementations of <code>IGarbage</code> that is
     * specifically disposed of by using this class.
     *
     * @author Matt Bolt <mbolt35@gmail.com>
     */
    public class GarbageCollector {

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        /**
         * This method cleans and sets up multiple <code>IGarbageCollectable</code> implementations
         * for flash garbage collection.
         *
         * @param	garbage at least 1 instance/implementation of <code>IGarbageCollectable</code>.
         *
         * @param	...moreGarbage More garbage!
         */
        public static function collect(...garbage):void {
            collectArray(garbage);
        }

        /**
         * @private
         * collects an array of garbage
         */
        private static function collectArray(garbage:Array):void {
            if (!garbage) {
                return;
            }

            for each (var obj:* in garbage) {
                if (obj is IGarbageCollectable) {
                    IGarbageCollectable(obj).dispose();
                } else if (obj is Array) {
                    collectArray(obj as Array);
                } else if (obj is Vector || obj is Vector.<*>) {
                    for each (var vectObj:* in obj) {
                        collect(vectObj);
                    }
                    if (obj) {
                        obj["length"] = 0;
                    }
                } else if (obj is Dictionary) {
                    for (var key:String in obj) {
                        collect(obj[key]);
                        delete obj[key];
                    }
                }
            }


            garbage.length = 0;
        }

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

    }

}
