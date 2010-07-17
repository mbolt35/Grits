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
    import com.mattbolt.grits.messaging.IGritsMessageParser;
    import com.mattbolt.grits.util.GarbageCollector;
    import com.mattbolt.grits.util.IGarbageCollectable;

    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import flash.events.ServerSocketConnectEvent;
    import flash.net.ServerSocket;
    import flash.utils.Dictionary;


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

            // TODO: AIR doesn't like "localhost" so use 127.0.0.1
            _server.bind(_port, _address == "localhost" ? "127.0.0.1" : _address);
            _server.listen();
        }

        /**
         * This method stops the log server.
         */
        public function stop():void {
            if (!_server || !_server.bound || !_server.listening) {
                return;
            }

            _server.close();
            removeServerListeners();

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
            removeServerListeners();
            _server.close();

            GarbageCollector.collect(_byId, _sockets);
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

        }

        /**
         * @private
         * this handles a socket logging command
         */
        private function onSocketLog(event:GritsSocketEvent):void {
            var delivery:GritsDeliveryDetails = _parser.parse(event.message);

            trace("[" + delivery.tag + "][" + delivery.command + "][" + delivery.key + "]: " + delivery.logText);
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
        //  Properties
        //
        //--------------------------------------------------------------------------

        /**
         * This property contains the <code>ServerSocket</code> instance used to control
         * the connections.
         */
        public function get server():ServerSocket {
            return _server;
        }

    }

}
