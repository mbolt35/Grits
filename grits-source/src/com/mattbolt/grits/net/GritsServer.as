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

    import com.mattbolt.grits.events.GritsServerEvent;
    import com.mattbolt.grits.events.GritsSocketEvent;
    import com.mattbolt.grits.events.GritsTransportEvent;
    import com.mattbolt.grits.messaging.IGritsMessageParser;
    import com.mattbolt.grits.util.GarbageCollector;
    import com.mattbolt.grits.util.IGarbageCollectable;
    import flash.events.IEventDispatcher;

    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import flash.events.ServerSocketConnectEvent;
    import flash.net.ServerSocket;
    import flash.utils.Dictionary;


    //----------------------------------
    //  imports
    //----------------------------------

    /**
     * @eventType com.mattbolt.grits.events.GritsTransportEvent.DELIVERY
     */
    [Event(name="delivery", type="com.mattbolt.grits.events.GritsTransportEvent")]

    /**
     * @eventType com.mattbolt.grits.events.GritsServerEvent.OPENED_CONNECTION
     */
    [Event(name="openedConnection", type="com.mattbolt.grits.events.GritsServerEvent")]

    /**
     * @eventType com.mattbolt.grits.events.GritsServerEvent.CLOSED_CONNECTION
     */
    [Event(name="closedConnection", type="com.mattbolt.grits.events.GritsServerEvent")]

    /**
     * This class manages a single socket server and its connections
     *
     * @author Matt Bolt [mbolt35&#64;gmail.com]
     */
    public class GritsServer implements IGritsServer, IGarbageCollectable {

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * the local address the server runs on.
         */
        private var _address:String

        /**
         * @private
         * the local port the server runs on.
         */
        private var _port:int;

        /**
         * @private
         * message parser instance
         */
        private var _parser:IGritsMessageParser;

        /**
         * @private
         * the logging server socket
         */
        private var _server:ServerSocket = new ServerSocket();

        /**
         * @private
         * this dispatcher handles all the event dispatch and forwarding
         */
        private var _internalDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));

        /**
         * @private
         * the sockets by id
         */
        private var _byId:Dictionary = new Dictionary();

        /**
         * @private
         * list of sockets managed by this instance.
         */
        private var _sockets:Vector.<GritsSocket> = new Vector.<GritsSocket>();


        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * <code>GritsServer</code> Constructor.
         */
        public function GritsServer(address:String, port:int, messageParser:IGritsMessageParser) {
            _address = address;
            _port = port;
            _parser = messageParser;
        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        /**
         * This method initializes and opens the server for connections.
         */
        public function start():void {
            if (!_server || _server.bound || _server.listening) {
                return;
            }

            initialize();

            // FIXME: AIR doesn't like "localhost" so use 127.0.0.1 instead. I know those two
            // FIXME: are not interchangable, but is there another alternative? Throw and Error?
            _server.bind(_port, _address == "localhost" ? "127.0.0.1" : _address);
            _server.listen();

            _listening = true;
        }

        /**
         * This method stops the log server.
         */
        public function stop():void {
            if (!_server || !_server.bound || !_server.listening) {
                return;
            }

            cleanup();

            _server = new ServerSocket();
        }


        //--------------------------------------------------------------------------
        //
        //  Methods: Initialization
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * initializes the socket server by adding connection listeners
         */
        private function initialize():void {
            _server.addEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
            _server.addEventListener(Event.CLOSE, onCloseConnection);
        }

        /**
         * @private
         * removes the server listeners
         */
        private function removeServerListeners():void {
            _server.removeEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
            _server.removeEventListener(Event.CLOSE, onCloseConnection);
        }

        /**
         * Removes event listeners and disconnects
         */
        public function dispose():void {
            cleanup();

            GarbageCollector.collect(_byId, _sockets);
        }

        /**
         * @private
         * this method removes the listeners and stops the server
         */
        private function cleanup():void {
            _server.close();
            removeServerListeners();

            _listening = false;
        }


        //--------------------------------------------------------------------------
        //
        //  Methods: Event Handlers
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * this method handles a connection event
         */
        private function onConnect(event:ServerSocketConnectEvent):void {
            trace("CONNECT: " + event.socket.remoteAddress + ", port: " + event.socket.remotePort);

            var gritsSocket:GritsSocket = new GritsSocket(event.socket);
            gritsSocket.addEventListener(GritsSocketEvent.CLOSED_CONNECTION, onSocketClosed);
            gritsSocket.addEventListener(GritsSocketEvent.SOCKET_LOG, onSocketLog);

            _byId[gritsSocket.id] = gritsSocket;
            _sockets.push(gritsSocket);

            dispatchEvent(new GritsServerEvent(GritsServerEvent.OPENED_CONNECTION, gritsSocket));
        }

        /**
         * @private
         * this handles a socket logging command
         */
        private function onSocketLog(event:GritsSocketEvent):void {
            var delivery:GritsDeliveryDetails = _parser.parse(event.message);

            trace("[" + delivery.tag + "][" + delivery.command + "][" + delivery.key + "]: " + delivery.logText);

            dispatchEvent(new GritsTransportEvent(GritsTransportEvent.DELIVERY, delivery));
        }

        /**
         * @private
         * this handles a socket connection closing
         */
        private function onSocketClosed(event:GritsSocketEvent):void {
            var gritsSocket:GritsSocket = GritsSocket(event.target);
            gritsSocket.removeEventListener(GritsSocketEvent.CLOSED_CONNECTION, onSocketClosed);
            gritsSocket.removeEventListener(GritsSocketEvent.SOCKET_LOG, onSocketLog);

            trace("Closing connection for: " + gritsSocket);

            delete _byId[gritsSocket.id];

            var index:int = _sockets.indexOf(gritsSocket);
            if (index != -1) {
                _sockets.splice(index, 1);
            }

            dispatchEvent(new GritsServerEvent(GritsServerEvent.CLOSED_CONNECTION, gritsSocket));

            GarbageCollector.collect(gritsSocket);
        }

        /**
         * @private
         * handles the connection closing
         */
        private function onCloseConnection(event:Event):void {
            trace("on close connection: " + event);
        }


        //--------------------------------------------------------------------------
        //
        //  Methods: IEventDispatcher
        //
        //--------------------------------------------------------------------------

        /**
         * @copy flash.events.EventDispatcher#addEventListener
         */
        public function addEventListener( type:String,
                                          listener:Function,
                                          useCapture:Boolean = false,
                                          priority:int = 0,
                                          useWeakReference:Boolean = false ):void
        {
            _internalDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        /**
         * @copy flash.events.EventDispatcher#removeEventListener
         */
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            _internalDispatcher.removeEventListener(type, listener, useCapture);
        }

        /**
         * @copy flash.events.EventDispatcher#dispatchEvent
         */
        public function dispatchEvent(event:Event):Boolean {
            return _internalDispatcher.dispatchEvent(event);
        }

        /**
         * @copy flash.events.EventDispatcher#hasEventListener
         */
        public function hasEventListener(type:String):Boolean {
            return _internalDispatcher.hasEventListener(type);
        }

        /**
         * @copy flash.events.EventDispatcher#willTrigger
         */
        public function willTrigger(type:String):Boolean {
            return _internalDispatcher.willTrigger(type);
        }


        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         * backing variable for listening property
         */
        private var __listening:Boolean;

        /**
         * @private
         * property proxy for binding "listening"
         */
        private function get _listening():Boolean {
            return __listening;
        }

        /**
         * @private
         */
        private function set _listening(value:Boolean):void {
            __listening = value;

            dispatchEvent(new Event("listeningChanged"));
        }

        [Bindable(event="listeningChanged")]

        /**
         * This property is set to <code>true</code> when the server has started and
         * is awaiting, or has already accepted, connections.
         */
        public function get listening():Boolean {
            return _listening;
        }

        /**
         * This property contains the <code>ServerSocket</code> instance used to control
         * the connections.
         */
        public function get server():ServerSocket {
            return _server;
        }

    }

}
