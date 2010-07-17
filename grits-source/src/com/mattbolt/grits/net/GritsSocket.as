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

    import com.mattbolt.grits.events.GritsSocketEvent;
    import com.mattbolt.grits.util.IGarbageCollectable;

    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;


    /**
     * @eventType com.mattbolt.grits.events.GritsSocketEvent.SOCKET_LOG
     */
    [Event(name="socketLog", type="com.mattbolt.grits.events.GritsSocketEvent")]

    /**
     * @eventType com.mattbolt.grits.events.GritsSocketEvent.CLOSED_CONNECTION
     */
    [Event(name="closedConnection", type="com.mattbolt.grits.events.GritsSocketEvent")]

    /**
     * This class manages a single socket connection for the grits logger.
     *
     * @author Matt Bolt <mbolt35&#64;gmail.com>
     */
    public class GritsSocket extends EventDispatcher implements IGarbageCollectable {

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * socket id to start
         */
        private static var socketId:int = int(Math.random() * 1000);

        /**
         * @private
         * the socket being managed by this instance
         */
        private var _socket:Socket;

        /**
         * @private
         * a unique identifier
         */
        private var _id:int;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * <code>GritsSocket</code> Constructor.
         */
        public function GritsSocket(socket:Socket) {
            _socket = socket;
            _id = socketId++;

            initialize();
        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * initializes the socket listeners
         */
        private function initialize():void {
            _socket.addEventListener(Event.CLOSE, onSocketClose);
            _socket.addEventListener(Event.CONNECT, onSocketConnect);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
            _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
        }

        /**
         * @private
         * removes the socket listeners
         */
        private function removeEventListeners():void {
            _socket.removeEventListener(Event.CLOSE, onSocketClose);
            _socket.removeEventListener(Event.CONNECT, onSocketConnect);
            _socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
            _socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            _socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
        }

        /**
         * @inheritDoc
         */
        public function dispose():void {
            removeEventListeners();
        }

        /**
         * @inheritDoc
         */
        public override function toString():String {
            return "[GritsSocket id: " + id + "]";
        }


        //--------------------------------------------------------------------------
        //
        //  Methods: Event Handlers
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * this method handles socket data events
         */
        private function onSocketData(event:ProgressEvent):void {
            var msg:String = _socket.readUTFBytes(_socket.bytesAvailable);

            dispatchEvent(new GritsSocketEvent(GritsSocketEvent.SOCKET_LOG, msg));
        }

        /**
         * @private
         * security error handler
         */
        private function onSecurityError(event:SecurityErrorEvent):void {

        }

        /**
         * @private
         * io error handler
         */
        private function onIOErrorEvent(event:IOErrorEvent):void {

        }

        /**
         * @private
         * socket connect handler
         */
        private function onSocketConnect(event:Event):void {

        }

        /**
         * @private
         * socket close handler
         */
        private function onSocketClose(event:Event):void {
            dispatchEvent(new GritsSocketEvent(GritsSocketEvent.CLOSED_CONNECTION, null));
        }

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        /**
         * This property contains the <code>Socket</code> instance being managed.
         */
        public function get socket():Socket {
            return _socket;
        }

        /**
         * This property contains the unique identifier for this socket.
         */
        public function get id():int {
            return _id;
        }

    }

}
