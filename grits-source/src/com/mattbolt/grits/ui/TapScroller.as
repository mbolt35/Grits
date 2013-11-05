////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2007 voq.jp
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package com.mattbolt.grits.ui
{
    import app.core.action.RotatableScalable;
    import flash.events.TUIOObject;
    import flash.events.TUIO;
    import flash.events.*;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import caurina.transitions.Tweener;
    
    /**
     * TapScroller simulates iPhone like scrolling.
     */
    public class TapScroller extends Sprite
    {
        // Inner contents
        private var _content:DisplayObject;
        // MovieClip of scroll bars
        private var _scrollBarV:Sprite;
        private var _scrollBarH:Sprite;
        // Scroll factor is length of mouse movement to detect dragging
        public var scrollFactor:Number = 10;
        // use vertical scrolling
        public var useVertical:Boolean = true;
        // use horizontal scrolling
        public var useHorizontal:Boolean = true;
        // dragging flag
        private var isDragging:Boolean = false;
        // last mouse position
        private var lastPos:Point = new Point();
        // last touch position
        private var lastTouchPos:Point = new Point();
        // first mouse position
        private var firstPos:Point = new Point();
        // first mouse position in panel 
        private var firstPanelPos:Point = new Point();
        // difference of mouse movement
        private var diff:Point = new Point();
        // scroll inhertia power
        private var inertia:Point = new Point();
        // minimum movable length
        private var min:Point = new Point();
        // maximum movable length
        private var max:Point = new Point();
        //Touch coordinates;
        private var touchX:Number;
        private var touchY:Number;
        
        private var blobCount:Number = 0;
        
        private var touchDrag:Boolean = false;
        
        private var panelWidth:Number;
        
        private var panelHeight:Number;
        
        public function TapScroller(
            content:DisplayObject,
            width:Number,
            height:Number)
        {
            // copy size
            panelWidth = width;
            panelHeight = height;
            
            // fill empty rectangle with width and height
            graphics.beginFill(0, 0);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
            
            _content = content;
            addChild(content);
            
            this.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
            
            // initialize mask
            var mask:Shape = new Shape();
            mask.graphics.beginFill(0, 1);
            mask.graphics.drawRect(0,0,width, height);
            mask.graphics.endFill();
            addChild(mask);
            
            _content.mask = mask;
            
            // initialize scrollbar
            _scrollBarV = new Sprite();
            _scrollBarV.cacheAsBitmap = true;
            _scrollBarV.x = width - 10;
            addChild(_scrollBarV);
            
            _scrollBarH = new Sprite();
            _scrollBarH.cacheAsBitmap = true;
            _scrollBarH.y = height - 10;
            addChild(_scrollBarH);
        }
        
        /**
         * Get contents
         */
        public function get content():DisplayObject 
        {
            return _content;
        }
        
        public function set dragging(bool:Boolean):void
        {
            isDragging = bool;
        }
        
        public function blobsOnScroller():Number
        {
            return blobCount;
        }
        
        /**
         * Listener for stage addition
         * @param e event
         */
        private  function handleAddedToStage(e:Event):void 
        {
            //this.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
            this.addEventListener(TouchEvent.MOUSE_DOWN, handleTouchDown);
            this.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
            this.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        }
        
        private function handleTouchDown (e:TouchEvent):void
        {
            this.addEventListener(TouchEvent.MOUSE_MOVE, handleTouchMove);
            this.addEventListener(TouchEvent.MOUSE_UP, handleTouchUp);
            stage.addEventListener(TouchEvent.MOUSE_UP, handleTouchUp);
            
            var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);
            blobCount = TUIO.getBlobArray().length;
            
            var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));														
            touchX = localPt.x;
            touchY = localPt.y;
            
            inertia.y = 0;
            inertia.x = 0;
            
            firstPos.x = touchX;
            firstPos.y = touchY;
            
            firstPanelPos.x = _content.x;
            firstPanelPos.y = _content.y;
            
            min.x = Math.min(-_content.x, -_content.width + panelWidth - _content.x);
            min.y = Math.min(-_content.y, -_content.height + panelHeight - _content.y);
            
            max.x = -_content.x;
            max.y = -_content.y;
            
            _scrollBarV.graphics.clear();
            if (useVertical) {
                _scrollBarV.graphics.beginFill(0x888899,1);
                _scrollBarV.graphics.drawRoundRect(2,0,6, panelHeight * Math.max(0, panelHeight / _content.height), 8);
                _scrollBarV.graphics.endFill();
            }
            
            _scrollBarH.graphics.clear();
            if (useHorizontal) {
                _scrollBarH.graphics.beginFill(0x888899,1);
                _scrollBarH.graphics.drawRoundRect(0,2, panelWidth * Math.max(0, panelWidth / _content.width), 6, 8);
                _scrollBarH.graphics.endFill();
            }
            e.stopPropagation();
        }
        
        private function handleTouchMove(e:TouchEvent):void
        {
            touchDrag = true;
            var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);							
            
            var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));														
            touchX = localPt.x;
            touchY = localPt.y;
            
            var totalX:Number = touchX - firstPos.x;
            var totalY:Number = touchY - firstPos.y;
            
            // movement detection with scrollFactor
            if (useVertical && Math.abs(totalY) > scrollFactor) {
                isDragging = true;
            }
            if (useHorizontal && Math.abs(totalX) > scrollFactor) {
                isDragging = true;
            }
            
            if (isDragging) {
                
                if (useVertical) {
                    if (totalY < min.y) {
                        totalY = min.y - Math.sqrt(min.y-totalY);
                    }
                    if (totalY > max.y) {
                        totalY = max.y + Math.sqrt(totalY - max.y);
                    }
                    _content.y = firstPanelPos.y + totalY;
                }
                
                if (useHorizontal) {
                    if (totalX < min.x) {
                        totalX = min.x - Math.sqrt(min.x-totalX);
                    }
                    if (totalX > max.x) {
                        totalX = max.x + Math.sqrt(totalX - max.x);
                    }
                    _content.x = firstPanelPos.x + totalX;
                }
                
            }
            
            e.stopImmediatePropagation();
        }
        
        /**
         * Listener for mouse movement
         * @param e information for mouse
         */
        private function handleMouseMove(e:MouseEvent):void 
        {
            var totalX:Number = mouseX - firstPos.x;
            var totalY:Number = mouseY - firstPos.y;
            
            // movement detection with scrollFactor
            if (useVertical && Math.abs(totalY) > scrollFactor) {
                isDragging = true;
            }
            if (useHorizontal && Math.abs(totalX) > scrollFactor) {
                isDragging = true;
            }
            
            if (isDragging) {
                
                if (useVertical) {
                    if (totalY < min.y) {
                        totalY = min.y - Math.sqrt(min.y-totalY);
                    }
                    if (totalY > max.y) {
                        totalY = max.y + Math.sqrt(totalY - max.y);
                    }
                    _content.y = firstPanelPos.y + totalY;
                }
                
                if (useHorizontal) {
                    if (totalX < min.x) {
                        totalX = min.x - Math.sqrt(min.x-totalX);
                    }
                    if (totalX > max.x) {
                        totalX = max.x + Math.sqrt(totalX - max.x);
                    }
                    _content.x = firstPanelPos.x + totalX;
                }
                
            }
            e.stopImmediatePropagation();
        }
        
        private function handleTouchUp(e:TouchEvent):void 
        {
            this.removeEventListener(TouchEvent.MOUSE_MOVE, handleTouchMove);
            
            var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);
            blobCount = 0;
            
            var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));														
            touchX = localPt.x;
            touchY = localPt.y;
            //trace(this, "TouchX in up: " + touchX + " touchY: " + touchY);
            
            isDragging = false;
            // setting inertia power
            if (useVertical) {
                inertia.y = diff.y;
            }
            if (useHorizontal) {
                inertia.x = diff.x;
            }
            try
            {
                stage.removeEventListener(TouchEvent.MOUSE_UP, handleTouchUp);
            }catch (e:Error)
            {
                trace(this, "Fail: " + e);
            }
            this.removeEventListener(TouchEvent.MOUSE_UP, handleTouchUp);
            e.stopImmediatePropagation();
        }
        
        /**
         * Listener for mouse up action
         * @param e information for mouse
         */
        private function handleMouseUp(e:MouseEvent):void 
        {
            if (stage.hasEventListener(MouseEvent.MOUSE_MOVE) )
            {
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
            }
            isDragging = false;
            // setting inertia power
            if (useVertical) {
                inertia.y = diff.y;
            }
            if (useHorizontal) {
                inertia.x = diff.x;
            }
            stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            e.stopImmediatePropagation();
        }
        
        /**
         * Listener for mouse down
         * @param e information for mouse
         */
        private function handleMouseDown(e:MouseEvent):void 
        {
            if (!stage.hasEventListener(MouseEvent.MOUSE_MOVE)) 
            {
                stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
                this.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
                stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            }
            
            inertia.y = 0;
            inertia.x = 0;
            
            firstPos.x = mouseX;
            firstPos.y = mouseY;
            
            firstPanelPos.x = _content.x;
            firstPanelPos.y = _content.y;
            
            min.x = Math.min(-_content.x, -_content.width + panelWidth - _content.x);
            min.y = Math.min(-_content.y, -_content.height + panelHeight - _content.y);
            
            max.x = -_content.x;
            max.y = -_content.y;
            
            _scrollBarV.graphics.clear();
            if (useVertical) {
                _scrollBarV.graphics.beginFill(0x888899,1);
                _scrollBarV.graphics.drawRoundRect(2,0,6, panelHeight * Math.max(0, panelHeight / _content.height), 8);
                _scrollBarV.graphics.endFill();
            }
            
            _scrollBarH.graphics.clear();
            if (useHorizontal) {
                _scrollBarH.graphics.beginFill(0x888899,1);
                _scrollBarH.graphics.drawRoundRect(0,2, panelWidth * Math.max(0, panelWidth / _content.width), 6, 8);
                _scrollBarH.graphics.endFill();
            }
            e.stopImmediatePropagation();
        }
        
        /**
         * Listener for enter frame event
         * @param e event information
         */
        private function handleEnterFrame(e:Event):void 
        {	
            if (touchDrag)
            {
                
                diff.y = touchY - lastTouchPos.y;
                diff.x = touchX - lastTouchPos.x;
                
                lastTouchPos.y = touchY;
                lastTouchPos.x = touchX;
                
                if (diff.x == 0 || diff.y == 0)
                {
                    touchDrag = false;
                }
            }
            else
            {
                
                diff.y = mouseY - lastPos.y;
                diff.x = mouseX - lastPos.x;
                
                lastPos.y = mouseY;
                lastPos.x = mouseX;
            }
            
            if (!isDragging) {
                
                // movements while non dragging
                
                if (useVertical) {
                    if (_content.y > 0) {
                        inertia.y = 0;
                        _content.y *= 0.8;
                        if (_content.y < 1) {
                            _content.y = 0;
                        }
                    }
                    
                    if (_content.height >= panelHeight && _content.y < panelHeight - _content.height) {
                        inertia.y = 0;
                        
                        var goal:Number = panelHeight - _content.height;
                        var diff:Number = goal - _content.y;
                        
                        if (diff > 1) {
                            diff *= 0.2;
                        }
                        _content.y += diff;
                    }
                    
                    if (_content.height < panelHeight && _content.y < 0) {
                        inertia.y = 0;
                        _content.y *= 0.8;
                        if (_content.y > -1) {
                            _content.y = 0;
                        }
                    }
                    
                    if (Math.abs(inertia.y) > 1) {
                        _content.y += inertia.y;
                        inertia.y *= 0.95;
                    } else {
                        inertia.y = 0;
                    }
                    
                    if (inertia.y != 0) {
                        if (_scrollBarV.alpha < 1) {
                            _scrollBarV.alpha = Math.min(1, _scrollBarV.alpha+0.1);
                        }
                        _scrollBarV.y = panelHeight * Math.min(1, (-_content.y / _content.height));
                    } else {
                        if (_scrollBarV.alpha > 0) {
                            _scrollBarV.alpha = Math.max(0, _scrollBarV.alpha-0.1);
                        }
                    }
                }
                
                if (useHorizontal) {
                    if (_content.x > 0) {
                        inertia.x = 0;
                        _content.x *= 0.8;
                        if (_content.x < 1) {
                            _content.x = 0;
                        }
                    }
                    
                    if (_content.width >= panelWidth && _content.x < panelWidth - _content.width) {
                        inertia.x = 0;
                        
                        goal = panelWidth - _content.width;
                        diff = goal - _content.x;
                        
                        if (diff > 1) {
                            diff *= 0.2;
                        }
                        _content.x += diff;
                    }
                    
                    if (_content.width < panelWidth && _content.x < 0) {
                        inertia.x = 0;
                        _content.x *= 0.8;
                        if (_content.x > -1) {
                            _content.x = 0;
                        }
                    }
                    
                    if (Math.abs(inertia.x) > 1) {
                        _content.x += inertia.x;
                        inertia.x *= 0.95;
                    } else {
                        inertia.x = 0;
                    }
                    
                    if (inertia.x != 0) {
                        if (_scrollBarH.alpha < 1) {
                            _scrollBarH.alpha = Math.min(1, _scrollBarH.alpha+0.1);
                        }
                        _scrollBarH.x = panelWidth * Math.min(1, (-_content.x / _content.width));
                    } else {
                        if (_scrollBarH.alpha > 0) {
                            _scrollBarH.alpha = Math.max(0, _scrollBarH.alpha-0.1);
                        }
                    }
                }
                
            } else {
                
                if (useVertical) {
                    if (_scrollBarV.alpha < 1) {
                        _scrollBarV.alpha = Math.min(1, _scrollBarV.alpha+0.1);
                    }
                    _scrollBarV.y = panelHeight * Math.min(1, (-_content.y / _content.height));
                }
                
                if (useHorizontal) {
                    if (_scrollBarH.alpha < 1) {
                        _scrollBarH.alpha = Math.min(1, _scrollBarH.alpha+0.1);
                    }
                    _scrollBarH.x = panelWidth * Math.min(1, (-_content.x / _content.width));
                }
            }
        }
    }
}