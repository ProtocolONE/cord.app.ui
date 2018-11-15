.pragma library
//@see http://doc-snapshot.qt-project.org/4.8/qdeclarativejavascript.html

var _timerComponent;
var _webSocketComponent

var _setTimeout = function(callback, timeout, arg1) {
    if (!_timerComponent) {
        _timerComponent = Qt.createComponent('./Timer.qml');
    }

    var cb = function() {
        callback(arg1); // undone use arguments
    }

    var timer = _timerComponent.createObject(null);
    timer.interval = timeout;
    timer.repeat = false;

    timer.triggered.connect(cb);
    timer.triggered.connect(function () {
        timer.triggered.disconnect(cb);
        timer.destroy();
    })

    timer.start();
}

function setUseRealBrowser() {}
var _openBrowser = function(url) {
    return Qt.openUrlExternally(url);
}

var _startWSServer = function(options) {
    if (!_webSocketComponent) {
        _webSocketComponent = Qt.createComponent('./WebSocket.qml');
        if (_webSocketComponent.errorString()) {
            console.log('Websocket error: ', _webSocketComponent.errorString())
        }
    }

    var nullCb = function() {};
    var readyCallback = options.readyCallback || nullCb;
    var messageCallback = options.messageCallback || nullCb;
    var errorCallback = options.errorCallback || nullCb;
    var timeout = options.timeout || 60000;

    var ws = _webSocketComponent.createObject(null);
    ws.timeout = timeout;

    if (options.sslEnabled) {
        ws.wssKey = options.wssKey;
        ws.wssCert = options.wssCert;
        ws.sslEnabled = true;
    }

    ws.ready.connect(readyCallback);
    ws.error.connect(errorCallback);
    ws.textMessage.connect(messageCallback);
    ws.textMessage.connect(function() {
        ws.stop();
        ws.destroy();
    })

    ws.start();
}

var _atob = function(data) {
    return Qt.atob(data);
}




/*!
 * jsUri v@1.1.2
 * https://github.com/derek-watson/jsUri
 *
 * Copyright 2011, Derek Watson
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * Includes parseUri regular expressions
 * http://blog.stevenlevithan.com/archives/parseuri
 * Copyright 2007, Steven Levithan
 * Released under the MIT license.
 *
 * Date: @DATE
 */

var Query = (function () {

    'use strict';

    /*jslint white:true, plusplus: true */

    function decode(s) {
        s = decodeURIComponent(s);
        s = s.replace('+', ' ');
        return s;
    }

    function Query(q) {
        var i, ps, p, kvp, k, v;

        this.params = [];

        if (typeof (q) === 'undefined' || q === null || q === '') {
            return;
        }

        if (q.indexOf('?') === 0) {
            q = q.substring(1);
        }

        ps = q.toString().split(/[&;]/);

        for (i = 0; i < ps.length; i++) {
            p = ps[i];
            kvp = p.split('=');
            k = kvp[0];
            v = p.indexOf('=') === -1 ? null : (kvp[1] === null ? '' : kvp[1]);
            this.params.push([k, v]);
        }
    }

    // getParamValues(key) returns the first query param value found for the key 'key'
    Query.prototype.getParamValue = function (key) {
        var param, i;
        for (i = 0; i < this.params.length; i++) {
            param = this.params[i];
            if (decode(key) === decode(param[0])) {
                return param[1];
            }
        }
    };

    // getParamValues(key) returns an array of query param values for the key 'key'
    Query.prototype.getParamValues = function (key) {
        var arr = [], i, param;
        for (i = 0; i < this.params.length; i++) {
            param = this.params[i];
            if (decode(key) === decode(param[0])) {
                arr.push(param[1]);
            }
        }
        return arr;
    };

    // deleteParam(key) removes all instances of parameters named (key)
    // deleteParam(key, val) removes all instances where the value matches (val)
    Query.prototype.deleteParam = function (key, val) {

        var arr = [], i, param, keyMatchesFilter, valMatchesFilter;

        for (i = 0; i < this.params.length; i++) {

            param = this.params[i];
            keyMatchesFilter = decode(param[0]) === decode(key);
            valMatchesFilter = decode(param[1]) === decode(val);

            if ((arguments.length === 1 && !keyMatchesFilter) ||
                (arguments.length === 2 && !keyMatchesFilter && !valMatchesFilter)) {
                arr.push(param);
            }
        }

        this.params = arr;

        return this;
    };

    // addParam(key, val) Adds an element to the end of the list of query parameters
    // addParam(key, val, index) adds the param at the specified position (index)
    Query.prototype.addParam = function (key, val, index) {

        if (arguments.length === 3 && index !== -1) {
            index = Math.min(index, this.params.length);
            this.params.splice(index, 0, [key, val]);
        } else if (arguments.length > 0) {
            this.params.push([key, val]);
        }
        return this;
    };

    // replaceParam(key, newVal) deletes all instances of params named (key) and replaces them with the new single value
    // replaceParam(key, newVal, oldVal) deletes only instances of params named (key) with the value (val) and replaces them with the new single value
    // this function attempts to preserve query param ordering
    Query.prototype.replaceParam = function (key, newVal, oldVal) {

        var index = -1, i, param;

        if (arguments.length === 3) {
            for (i = 0; i < this.params.length; i++) {
                param = this.params[i];
                if (decode(param[0]) === decode(key) && decodeURIComponent(param[1]) === decode(oldVal)) {
                    index = i;
                    break;
                }
            }
            this.deleteParam(key, oldVal).addParam(key, newVal, index);
        } else {
            for (i = 0; i < this.params.length; i++) {
                param = this.params[i];
                if (decode(param[0]) === decode(key)) {
                    index = i;
                    break;
                }
            }
            this.deleteParam(key);
            this.addParam(key, newVal, index);
        }
        return this;
    };

    Query.prototype.toString = function () {
        var s = '', i, param;
        for (i = 0; i < this.params.length; i++) {
            param = this.params[i];
            if (s.length > 0) {
                s += '&';
            }
            if (param[1] === null) {
                s += param[0];
            }
            else {
                s += param.join('=');
            }
        }
        return s.length > 0 ? '?' + s : s;
    };

    return Query;
}());

var Uri = (function () {

    'use strict';

    /*jslint white: true, plusplus: true, regexp: true, indent: 2 */
    /*global Query: true */

    function is(s) {
        return (s !== null && s !== '');
    }

    function Uri(uriStr) {

        uriStr = uriStr || '';

        var parser = /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/,
            keys = [
                "source",
                "protocol",
                "authority",
                "userInfo",
                "user",
                "password",
                "host",
                "port",
                "relative",
                "path",
                "directory",
                "file",
                "query",
                "anchor"
            ],
            q = {
                name: 'queryKey',
                parser: /(?:^|&)([^&=]*)=?([^&]*)/g
            },
            m = parser.exec(uriStr),
            i = 14,
            self = this;

        this.uriParts = {};

        while (i--) {
            this.uriParts[keys[i]] = m[i] || "";
        }

        this.uriParts[q.name] = {};
        this.uriParts[keys[12]].replace(q.parser, function ($0, $1, $2) {
            if ($1) {
                self.uriParts[q.name][$1] = $2;
            }
        });

        this.queryObj = new Query(this.uriParts.query);

        this.hasAuthorityPrefixUserPref = null;
    }


    /*
     Basic get/set functions for all properties
     */

    Uri.prototype.protocol = function (val) {
        if (typeof val !== 'undefined') {
            this.uriParts.protocol = val;
        }
        return this.uriParts.protocol;
    };

    // hasAuthorityPrefix: if there is no protocol, the leading // can be enabled or disabled
    Uri.prototype.hasAuthorityPrefix = function (val) {

        if (typeof val !== 'undefined') {
            this.hasAuthorityPrefixUserPref = val;
        }

        if (this.hasAuthorityPrefixUserPref === null) {
            return (this.uriParts.source.indexOf('//') !== -1);
        } else {
            return this.hasAuthorityPrefixUserPref;
        }
    };

    Uri.prototype.userInfo = function (val) {
        if (typeof val !== 'undefined') {
            this.uriParts.userInfo = val;
        }
        return this.uriParts.userInfo;
    };

    Uri.prototype.host = function (val) {
        if (typeof val !== 'undefined') {
            this.uriParts.host = val;
        }
        return this.uriParts.host;
    };

    Uri.prototype.port = function (val) {
        if (typeof val !== 'undefined') {
            this.uriParts.port = val;
        }
        return this.uriParts.port;
    };

    Uri.prototype.path = function (val) {
        if (typeof val !== 'undefined') {
            this.uriParts.path = val;
        }
        return this.uriParts.path;
    };

    Uri.prototype.query = function (val) {
        if (typeof val !== 'undefined') {
            this.queryObj = new Query(val);
        }
        return this.queryObj;
    };

    Uri.prototype.anchor = function (val) {
        if (typeof val !== 'undefined') {
            this.uriParts.anchor = val;
        }
        return this.uriParts.anchor;
    };

    /*
     Fluent setters for Uri properties
     */
    Uri.prototype.setProtocol = function (val) {
        this.protocol(val);
        return this;
    };

    Uri.prototype.setHasAuthorityPrefix = function (val) {
        this.hasAuthorityPrefix(val);
        return this;
    };

    Uri.prototype.setUserInfo = function (val) {
        this.userInfo(val);
        return this;
    };

    Uri.prototype.setHost = function (val) {
        this.host(val);
        return this;
    };

    Uri.prototype.setPort = function (val) {
        this.port(val);
        return this;
    };

    Uri.prototype.setPath = function (val) {
        this.path(val);
        return this;
    };

    Uri.prototype.setQuery = function (val) {
        this.query(val);
        return this;
    };

    Uri.prototype.setAnchor = function (val) {
        this.anchor(val);
        return this;
    };


    /*
     Query method wrappers
     */
    Uri.prototype.getQueryParamValue = function (key) {
        return this.query().getParamValue(key);
    };

    Uri.prototype.getQueryParamValues = function (key) {
        return this.query().getParamValues(key);
    };

    Uri.prototype.deleteQueryParam = function (key, val) {
        if (arguments.length === 2) {
            this.query().deleteParam(key, val);
        } else {
            this.query().deleteParam(key);
        }

        return this;
    };

    Uri.prototype.addQueryParam = function (key, val, index) {
        if (arguments.length === 3) {
            this.query().addParam(key, val, index);
        } else {
            this.query().addParam(key, val);
        }
        return this;
    };

    Uri.prototype.replaceQueryParam = function (key, newVal, oldVal) {
        if (arguments.length === 3) {
            this.query().replaceParam(key, newVal, oldVal);
        } else {
            this.query().replaceParam(key, newVal);
        }

        return this;
    };


    /*
     Serialization
     */
    Uri.prototype.scheme = function () {

        var s = '';

        if (is(this.protocol())) {
            s += this.protocol();
            if (this.protocol().indexOf(':') !== this.protocol().length - 1) {
                s += ':';
            }
            s += '//';
        } else {
            if (this.hasAuthorityPrefix() && is(this.host())) {
                s += '//';
            }
        }

        return s;
    };

    /*
     Same as Mozilla nsIURI.prePath
     cf. https://developer.mozilla.org/en/nsIURI
     */
    Uri.prototype.origin = function () {

        var s = this.scheme();

        if (is(this.userInfo()) && is(this.host())) {
            s += this.userInfo();
            if (this.userInfo().indexOf('@') !== this.userInfo().length - 1) {
                s += '@';
            }
        }

        if (is(this.host())) {
            s += this.host();
            if (is(this.port())) {
                s += ':' + this.port();
            }
        }

        return s;
    };


    // toString() stringifies the current state of the uri
    Uri.prototype.toString = function () {

        var s = this.origin();

        if (is(this.path())) {
            s += this.path();
        } else {
            if (is(this.host()) && (is(this.query().toString()) || is(this.anchor()))) {
                s += '/';
            }
        }
        if (is(this.query().toString())) {
            if (this.query().toString().indexOf('?') !== 0) {
                s += '?';
            }
            s += this.query().toString();
        }

        if (is(this.anchor())) {
            if (this.anchor().indexOf('#') !== 0) {
                s += '#';
            }
            s += this.anchor();
        }

        return s;
    };

    /*
     Cloning
     */
    Uri.prototype.clone = function () {
        return new Uri(this.toString());
    };

    return Uri;
}());


var http = function() {
};

// INFO debug output
http.logRequest = false;

http.request = function(options, callback) {
    var xhr = new XMLHttpRequest(),
        method = options.method || 'get',
        uri,
        userAgent;

    if (options instanceof Uri) {
        uri = options;
    } else if (typeof options === 'string') {
        uri = new Uri(options);
    } else if (options.hasOwnProperty('uri') && options.uri instanceof Uri) {
        uri = options.uri;
        if (options.hasOwnProperty('userAgent')) {
            userAgent = options.userAgent;
        }
    } else {

        throw new Exception('Wrong options');
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState !== 4) { // full body received
            return;
        }

        if (http.logRequest) {
            // INFO debug output
            var tmp = 'Request: ' + uri.toString();
            if (options.hasOwnProperty('post')) {
                tmp += '\nPost:' + options.post;
            }

            tmp += '\nStatus: ' + xhr.status;
            try {
                var debugResponseObject = JSON.parse(xhr.responseText);
                tmp += '\nResponse: \n' + JSON.stringify(debugResponseObject, null, 2);
            } catch (e) {
                tmp += '\nResponse: \n' + xhr.responseText;
            }

            console.log(tmp);
        }

        callback({status: xhr.status, header: xhr.getAllResponseHeaders(), body: xhr.responseText});
    };

    if (method === 'get') {
        xhr.open('GET', uri.toString());

        if (userAgent) {
            xhr.setRequestHeader('QtBug', 'QTBUG-20473\r\nUser-Agent: ' + userAgent);
        }

        xhr.send(null);
    } else {
        xhr.open('POST', uri.toString());

        if (userAgent) {
            xhr.setRequestHeader('QtBug', 'QTBUG-20473\r\nUser-Agent: ' + userAgent);
        }

        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        if (options.hasOwnProperty('post')) {
            xhr.send(options.post); //jsuri return query with '?' always
        } else {
            xhr.send(uri.query().toString().substring(1)); //jsuri return query with '?' always
        }
    }
};


//Replaced during CI build
var authLibVersion = "1.0.0"
    , _authBaseUrl = 'http://auth.protocol.local:8080'
    , _apiVersion = 'v1'
    , _authUrl = 'http://auth.protocol.local:8080/api/v1/'
    , _hwid
    , _mid
    , _captcha
    , _timeout
    , _localWebSocketUrl = 'ws://127.0.0.1'
    , _wssCert
    , _wssKey
    , _useWSS = false
;

var Result = function() {};
Result.Error = 0;
Result.Success = 1;
Result.InvalidUserNameOrPassword = 2;
Result.CaptchaRequired = 3;
Result.TemporaryLock = 4;
Result.Timeout = 5;
Result.ServerError = 6;
Result.BadResponse = 7;

function setup(options) {
    _hwid = options.hwid || '';
    _mid = options.mid || '';
    _authBaseUrl = options.authUrl || _authBaseUrl;
    _apiVersion = options.authVersion || _apiVersion;
    _authUrl = _authBaseUrl + '/api/' + _apiVersion + '/';
    _timeout = options.timeout || 60000;

    _localWebSocketUrl = options.localWebSocketUrl || _localWebSocketUrl;
    _wssCert = options.wssCert || _wssCert;
    _wssKey = options.wssKey || _wssKey;
     _useWSS = _localWebSocketUrl.substring(0, 3) === 'wss';

    if (options.debug) {
        http.logRequest = true
    }
}

function setDefaultSettings() {
    setUseRealBrowser(true);
    setup({
        hwid: '',
        mid: '',
        authUrl: 'http://auth.protocol.local:8080',
        authVersion: 'v1'
    });
}

function getCaptchaImageSource(login) {
    var url = new Uri(_authUrl+'captcha/login/')
        .addQueryParam('r', Math.random())
        .addQueryParam('email', login);

    return url.toString();
}

function getOAuthServices(callback) {
    var request = new Uri(_authUrl+'oauth/sources/'),
        options = {
        method: "get",
        uri: request
        }
        , httpStatusToResultMap
        , result = 0
        , msg;


    httpStatusToResultMap = {
        200 : Result.Success,
        400 : Result.InvalidUserNameOrPassword,
        429 : Result.CaptchaRequired,
        426 : Result.TemporaryLock,
    }

    http.request(options, function(response) {
        if (httpStatusToResultMap.hasOwnProperty(response.status)) {
            result = httpStatusToResultMap[response.status];
        }

        msg = response.body;
        try {
            msg = JSON.parse(msg);
        } catch (e) {
        }

        callback(result, msg);
    });
}

function _validateAuthResponse(response) {
    return !!response
        && response.hasOwnProperty('accessToken')
        && response.hasOwnProperty('refreshToken')
        && response.accessToken.hasOwnProperty('value')
        && response.refreshToken.hasOwnProperty('value')
        && response.accessToken.hasOwnProperty('exp')
        && response.refreshToken.hasOwnProperty('exp');
}

function _callAuthCallback(response, result, callback) {
    var msg = response;
    try {
        msg = JSON.parse(response);
    } catch (e) {
    }

    if (result != Result.Success) {
        callback(result, msg);
        return;
    }

    if (!_validateAuthResponse(msg)) {
        callback(Result.BadResponse, msg);
        return;
    }

    callback(result, msg);
}

function loginByOAuth(type, callback) {
    var url = _authBaseUrl + type;

    function ready(port) {

        var ws = _localWebSocketUrl + ':' + port;
        var authUrl = url + '?_destination='
            + encodeURIComponent('/api/v1/oauth/result/websocket/?wsUrl='+ws);

        if (http.logRequest) {
            console.log('WS opened on port: ' + port);
            console.log('Open external browser with url:', authUrl);
        }

        _openBrowser(authUrl);
    }

    function error(type) {
        callback(type);
    }

    function messageReceived(msg) {
        if (http.logRequest) {
            console.log('WS messageReceived', msg)
        }

        try {
            msg = JSON.parse(msg);
        } catch (e) {
        }

        if (msg.event !== 'oauthCompletedSuccessfully') {
            callback(Result.ServerError, msg);
            return;
        }

        if (!_validateAuthResponse(msg.message)) {
            callback(Result.BadResponse, msg);
            return;
        }

        callback(Result.Success, msg.message);
    }

    _startWSServer({
        readyCallback: ready,
        messageCallback:  messageReceived,
        errorCallback: error,
        timeout: _timeout,
        sslEnabled: _useWSS,
        wssCert: _wssCert,
        wssKey: _wssKey
    })
}

function registerUser(email, password, callback) {
    var request = new Uri(_authUrl+'user/create/'),
        options = {
            method: "post",
            uri: request
        }
        , httpStatusToResultMap
        , result = 0;


    httpStatusToResultMap = {
        200 : Result.Success,
        400 : Result.InvalidUserNameOrPassword,
    }

    options.post = JSON.stringify({
        email: email,
        password: password,
        readEula: true
    })

    http.request(options, function(response) {
        if (httpStatusToResultMap.hasOwnProperty(response.status)) {
            result = httpStatusToResultMap[response.status];
        }

        _callAuthCallback(response.body, result, callback);
    });
}

function login(email, password, captcha, callback) {
    var request = new Uri(_authUrl+'user/login'),
        options = {
            method: "post",
            uri: request
        }
        , httpStatusToResultMap
        , result = 0;

    httpStatusToResultMap = {
        200 : Result.Success,
        400 : Result.InvalidUserNameOrPassword,
        429 : Result.CaptchaRequired,
        426 : Result.TemporaryLock,
    }

    options.post = JSON.stringify({
        email: email,
        password: password,
        captcha: captcha
    })

    http.request(options, function(response) {
        if (httpStatusToResultMap.hasOwnProperty(response.status)) {
            result = httpStatusToResultMap[response.status];
        }

        _callAuthCallback(response.body, result, callback);
    });
}

function requestPasswordResetCode(email, callback) {
    var request = new Uri(_authUrl+'user/send-email/forgot/')
            .addQueryParam('email', email)
        , options = {
            method: "get",
            uri: request
        }
        , httpStatusToResultMap
        , result = 0;

    httpStatusToResultMap = {
        200 : Result.Success,
    }

    http.request(options, function(response) {
        if (httpStatusToResultMap.hasOwnProperty(response.status)) {
            result = httpStatusToResultMap[response.status];
        }

        callback(result, response.body);
    });
}

function changePassword(email, password, code, callback) {
    var request = new Uri(_authUrl+'user/change-password/'),
        options = {
            method: "post",
            uri: request
        }
        , httpStatusToResultMap
        , result = 0;

    httpStatusToResultMap = {
        200 : Result.Success,
        400 : Result.InvalidUserNameOrPassword,
        429 : Result.CaptchaRequired,
        426 : Result.TemporaryLock,
    }

    options.post = JSON.stringify({
        email: email,
        password: password,
        code: code
    })

    http.request(options, function(response) {
        if (httpStatusToResultMap.hasOwnProperty(response.status)) {
            result = httpStatusToResultMap[response.status];
        }

        callback(result, response.body);
    });
}

function refreshToken(token, callback) {
    var request = new Uri(_authUrl+'token/refresh/')
            .addQueryParam('token', token)
        ,
        options = {
            method: "get",
            uri: request
        }
        , httpStatusToResultMap
        , result = 0;


    httpStatusToResultMap = {
        200 : Result.Success,
        403 : Result.Error,
    }

    http.request(options, function(response) {
        if (httpStatusToResultMap.hasOwnProperty(response.status)) {
            result = httpStatusToResultMap[response.status];
        }

        _callAuthCallback(response.body, result, callback);
    });
}

function decodeJwt(encodedToken) {
    var tokens, result;
    encodedToken = encodedToken || ''
    tokens = encodedToken.split('.');
    if (!tokens || tokens.length != 3)
        return;

    try {
        result = {
            header: JSON.parse(_atob(tokens[0])),
            payload: JSON.parse(_atob(tokens[1]))
        }
    } catch(e) {

    }

    return result;
}