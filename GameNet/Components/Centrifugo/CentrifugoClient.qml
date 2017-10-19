import QtQuick 2.4
import QtWebSockets 1.0

import GameNet.Core 1.0

import "./CentrifugoClient.js" as Js

Item {
    id: root

    property alias debug: d.debugLog
    property alias retry: d.retry
    property alias maxRetry: d.maxRetry

    signal connected();
    signal disconnected();

    signal messageReceived(string channel, variant params);
    signal userMessageReceived(string channel, variant params);

    signal beginReconnect(int tryCount);

    function connect(opt) {
        d.internalConnect(opt)
    }

    function disconnect(reason) {
        d.disconnect(reason || 'disconnect', false);
    }

    function getClientId() {
        return d.clientID;
    }

    function subscribeUserChannel(channel) {
        subscribe(channel + "#" + d.user);
    }

    function subscribe(channel) {
        d.subscribe(channel);
    }

    function ping() {
        d.callMethod('ping');
    }

    function callMethod(method, params, useUid) {
        d.callMethod(method, params, useUid);
    }

    function startBatch() {
        Js.startBatch();
    }

    function stopBatch() {
        var queue = Js.stopBatch();
        if (!!queue) {
            var sendMsg = JSON.stringify(queue);
            d.debug('[Centrifuge] SendMessage: ', sendMsg)
            webSocket.sendTextMessage(sendMsg);
        }
    }

    QtObject {
        id: d

        property int messageId: 1

        property string wsUrl: ""
        property string timestamp: ""
        property string user: ""
        property string token: ""
        property string clientID: ""
        property string status: ""
        property int retries: 0
        property int retry: 1000
        property int maxRetry: 60000
        property bool reconnect: true
        property bool debugLog: false

        function debug() {
            if (d.debugLog) {
                console.log.apply(console.log, arguments);
            }
        }

        function stripSlash(value) {
            if (value.substring(value.length - 1) == "/") {
                value = value.substring(0, value.length - 1);
            }
            return value;
        }

        function endsWith(value, suffix) {
            return value.indexOf(suffix, value.length - suffix.length) !== -1;
        }

        function internalConnect(opt) {
            if (d.isConnected()) {
                d.debug("[Centrifuge] connect called when already connected");
                return;
            }

            if (d.isConnecting()) {
                return;
            }

            webSocket.active = false;
            webSocket.url = "";

            d.debug("[Centrifuge] start connecting");
            d.setStatus('connecting');

            if (!!opt) {
                d.token = opt.token;
                d.timestamp = opt.timestamp;
                d.user = opt.user;

                var url = opt.endpoint;
                url = url.replace("http://", "ws://");
                url = url.replace("https://", "wss://");
                url = d.stripSlash(url);

                if (d.endsWith(url, '/connection')) {
                    url = url + "/websocket";
                }

                if (!d.endsWith(url, 'connection/websocket')) {
                    url = url + "/connection/websocket";
                }

                d.wsUrl = url;
            }

            d.debug('[Centrifuge] connect to endpoint: ', d.wsUrl);
            webSocket.url = d.wsUrl;
        }

        function webSocketError() {
            if (d.isDisconnected() || !webSocket.active) {
                return;
            }

            console.log('[Centrifuge] Websocket error. Status: ', webSocket.status, 'Message: ', webSocket.errorString, d.status);
        }

        function callMethod(method, params, useUid) {
            var msg = {};

            msg.method = method;

            if (!!params) {
                msg.params = params;
            }

            if (!!useUid) {
                msg.uid = d.nextMessageId();
            }

            if (Js.isBatchStarted()) {
                Js.addMessage(msg);
            } else {
                d.debug('[Centrifuge] SendMessage: ', JSON.stringify(msg))
                webSocket.sendTextMessage(JSON.stringify(msg));
            }
        }

        function webSocketOpened() {
            d.clientID = "";
            d.messageId = 1;
            d.retries = 0;
            d.callMethod('connect', {
                             user: d.user,
                             info: '',
                             timestamp: d.timestamp,
                             token: d.token
                         });
        }

        function webSocketClosed(reason) {
            d.disconnect(reason, d.reconnect);
        }

        function nextMessageId() {
            return d.messageId++;
        }

        function messageReceived(data) {
            if (Object.prototype.toString.call(data) === Object.prototype.toString.call([])) {
                // array of responses received
                for (var i in data) {
                    if (data.hasOwnProperty(i)) {
                        var msg = data[i];
                        d.dispatchMessage(msg);
                    }
                }
            } else if (Object.prototype.toString.call(data) === Object.prototype.toString.call({})) {
                // one response received
                d.dispatchMessage(data);
            }
        }

        function dispatchMessage(message) {
            if (d.errorExists(message)) {
                d.debug('[Centrifuge] Error message: ', JSON.stringify(message, null, 2));
            }

            if (message === undefined || message === null) {
                d.debug("[Centrifuge] dispatch: got undefined or null message");
                return;
            }

            var method = message.method;

            if (!method) {
                d.debug("[Centrifuge] dispatch: got message with empty method");
                return;
            }

            switch (method) {
                case 'connect':
                    d.connectResponse(message);
                    break;
                case 'subscribe':
                    d.subscribeResponse(message);
                    break;
                case 'ping':
                    break;
                case 'message':
                    d.messageResponse(message);
                    break;
//                case 'disconnect':
//                    d._disconnectResponse(message);
//                    break;
//                case 'unsubscribe':
//                    d._unsubscribeResponse(message);
//                    break;
//                case 'publish':
//                    d._publishResponse(message);
//                    break;
//                case 'presence':
//                    d._presenceResponse(message);
//                    break;
//                case 'history':
//                    d._historyResponse(message);
//                    break;
//                case 'join':
//                    d._joinResponse(message);
//                    break;
//                case 'leave':
//                    d._leaveResponse(message);
//                    break;
//                case 'refresh':
//                    d._refreshResponse(message);
//                    break;
                default:
                    d.debug("[Centrifuge] dispatch: got message with unknown method:" + method);
                    break;
            }
        }

        function errorExists(data) {
            return "error" in data && data.error !== null && data.error !== "";
        }

        function connectResponse(message) {
            if (d.isConnected()) {
                return;
            }

            if (d.errorExists(message)) {
                // UNDONE
                d.disconnect('connect error', true);
                return;
            }

            if (!message.body) {
                return;
            }

            d.clientID = message.body.client;
            d.setStatus('connected');
            root.connected();
        }

        function subscribeResponse(message) {
            var body = message.body;
            if (body === null) {
                return;
            }

            var channel = body.channel;
            d.debug('[Centrifuge] subscribed channel: ', channel);
        }

        function messageResponse(message) {
            var body = message.body;
            if (!body) {
                return;
            }

            var channel = body.channel;
            if (!channel) {
                return;
            }

            var userSuffix = '#' + d.user;
            if (d.endsWith(channel, userSuffix)) {
                var privateChannelName = channel.substring(0, channel.length - userSuffix.length);
                if (!!privateChannelName) {
                    root.userMessageReceived(privateChannelName, body.data);
                }

            } else {
                root.messageReceived(channel, body.data);
            }
        }

        function setStatus(newStatus) {
            if (d.status !== newStatus) {
                d.debug('[Centrifuge] Status', d.status, '->', newStatus);
                d.status = newStatus;
            }
        }

        function isDisconnected() {
            return d.status === 'disconnected';
        }

        function isConnecting() {
            return d.status === 'connecting';
        }

        function isConnected() {
            return d.status === 'connected';
        }

        function subscribe(channel) {
            d.callMethod('subscribe', { channel: channel });
        }

        function disconnect(reason, shouldReconnect) {
            if (d.isDisconnected()) {
                return;
            }

            d.debug("[Centrifuge] disconnected:", reason, shouldReconnect);
            d.setStatus('disconnected');
            Js.stopBatch();

            if (shouldReconnect) {
                var interval = d.getRetryInterval();
                console.log("[Centrifuge] reconnect after " + interval + " milliseconds");
                reconnectTimer.interval = interval;
                reconnectTimer.start();
                root.beginReconnect(d.retries);
            } else {
                reconnectTimer.stop();
                root.disconnected();
            }
        }

        function backoff(step, min, max) {
            var jitter = 0.5 * Math.random();
            var interval = min * Math.pow(2, step+1);
            if (interval > max) {
                interval = max
            }
            return Math.floor((1-jitter) * interval);
        }

        function getRetryInterval() {
            var interval = d.backoff(d.retries, d.retry, d.maxRetry);
            d.retries += 1;
            return interval;
        }
    }

    WebSocket {
        id: webSocket

        onStatusChanged: {
            if (status == WebSocket.Open) {
                d.webSocketOpened();
            }

            if (status == WebSocket.Closed) {
                d.webSocketClosed("connection closed");
            }

            if (status == WebSocket.Error) {
                d.webSocketError(webSocket.status, webSocket.errorString);
                return;
            }
        }

        onErrorStringChanged: {
            d.webSocketError(webSocket.status, webSocket.errorString);
        }

        onTextMessageReceived: {
            d.debug('[Centrifuge] message receved:', message)
            var data;
            try {
                data = JSON.parse(message);
            } catch(e) {
                console.log('[Centrifuge] Parse message error:', data);
            }

            d.messageReceived(data);
        }
    }

    Timer {
        id: reconnectTimer

        triggeredOnStart: false
        repeat: false
        onTriggered: d.internalConnect()
    }
}
