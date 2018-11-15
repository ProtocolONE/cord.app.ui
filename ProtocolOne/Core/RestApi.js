.pragma library
//@see http://doc-snapshot.qt-project.org/4.8/qdeclarativejavascript.html



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


var Error = function() { // jshint ignore:line
};

//UNDONE Это не весь перечень ошибок. При необходимости - добавляйте.
Error.UNKNOWN = 1;
Error.TO_MANY_REQUESTS = 2;
Error.INVALID_REQUEST = 3;
Error.TFA_INVALID_CODE = 6;
Error.TFA_INVALID_TOKEN = 7;
Error.CAPTCHA_REQUIRED = 11;
Error.AUTHORIZATION_FAILED = 100;
Error.ACCOUNT_NOT_EXISTS = 101;
Error.SERVICE_ACCOUNT_BLOCKED = 102;
Error.AUTHORIZATION_LIMIT_EXCEED = 103;
Error.UNKNOWN_ACCOUNT_STATUS = 104;
Error.INCORRECT_ACCOUNT_PASSWORD = 105;
Error.INCORRECT_FORMAT_EMAIL = 110;
Error.NICKNAME_FORMAT_INCORRECT = 114;
Error.NICKNAME_EXISTS = 115;
Error.TECHNAME_FORMAT_INCORRECT = 116;
Error.TECHNAME_EXISTS = 117;
Error.UNABLE_CHANGE_TECHNAME = 118;
Error.UNABLE_CHANGE_NICKNAME = 119;
Error.NICKNAME_NOT_SPECIFIED = 121;
Error.TECHNAME_NOT_SPECIFIED = 122;
Error.NICKNAME_FORBIDDEN = 123;
Error.TECHNAME_FORBIDDEN = 124;
Error.SERVICE_AUTHORIZATION_IMPOSSIBLE = 125;
Error.INCORRECT_SMS_CODE = 126;
Error.PHONE_ALREADY_IN_USE = 127;
Error.UNABLE_DELIVER_SMS = 128;
Error.INVALID_PHONE_FORMAT = 129;
Error.PHONE_BLOCKED = 130;
Error.TFA_SMS_TIMEOUT_IS_NOT_EXPIRED = 136;
Error.TFA_NEED_SMS_CODE = 137;
Error.TFA_NEED_APP_CODE = 138;
Error.TFA_INVALID_CODE_OLD = 139;
Error.PARAMETER_MISSING = 200;
Error.WRONG_AUTHTYPE = 201;
Error.WRONG_SERVICEID = 202;
Error.WORNG_AUTHID = 203;
Error.UNKNOWN_METHOD = 204;
Error.PAKKANEN_PERMISSION_DENIED = 601;
Error.PAKKANEN_VK_LINK = 602;
Error.PAKKANEN_PHONE_VERIFICATION = 603;
Error.PAKKANEN_VK_LINK_AND_PHONE_VERIFICATION = 604;


var ErrorEx = function() { // jshint ignore:line
};

ErrorEx.Success = 0;
ErrorEx.UNKNOWN = 1;
ErrorEx.Unauthorized = 2;

ErrorEx.isSuccess = function(code) { return code == ErrorEx.Success; }



var http = function() {
};

// INFO debug output
http.logRequest = false;

function setHeaders(xhr, options) {
    if (!options.hasOwnProperty('headers')) {
        return;
    }

    for (var hkey in options.headers) {
        if (options.headers.hasOwnProperty(hkey)) {
            xhr.setRequestHeader(hkey, options.headers[hkey]);
        }
    }
}

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
            var tmp = '[RestApi] Request: ' + uri.toString();
            if (options.hasOwnProperty('post')) {
                tmp += '\n[RestApi] Post:' + options.post;
            }

            if (options.hasOwnProperty('headers')) {
                tmp += '\n[RestApi] Request headers:' + JSON.stringify(options.headers, null, 2);
            }

            tmp += '\n[RestApi] Status: ' + xhr.status;
            try {
                var debugResponseObject = JSON.parse(xhr.responseText);
                tmp += '\n[RestApi] Response: \n' + JSON.stringify(debugResponseObject, null, 2);
            } catch (e) {
                tmp += '\n[RestApi] Response: \n' + xhr.responseText;
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
        setHeaders(xhr, options);

        xhr.send(null);
    } else {
        xhr.open('POST', uri.toString());

        if (userAgent) {
            xhr.setRequestHeader('QtBug', 'QTBUG-20473\r\nUser-Agent: ' + userAgent);
        }

        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        setHeaders(xhr, options);

        if (options.hasOwnProperty('post')) {
            xhr.send(options.post);
        } else {
            xhr.send(uri.query().toString().substring(1)); //jsuri return query with '?' always
        }
    }
};


var Core = function(options) {
    var baseUrl;

    this._lang = (options && options.lang) ? options.lang : 'ru';
    this._auth = (options && options.auth) ? options.auth : false;
    this._url =  (options && options.url) ? options.url : "https://gnapi.com:8443/restapi";
    this._genericErrorCallback = undefined;
    this._cacheLookupCallback = undefined;
    this._cacheSaveCallback = undefined;

    this._jwt = undefined;
    this._jwtExpiredTime = undefined;
    this._jwtRefreshCallback = function() { this.setJwt(); };
    this._version = (options && options.version) ? options.version : "v1";

    baseUrl = (options && options.url) ? options.url : "http://api.protocol.local:8080";
    if (baseUrl[baseUrl.length - 1] == '/')
        baseUrl = baseUrl.slice(0, baseUrl.length - 1);

    this._urlEx = baseUrl + '/api/' + this._version + '/';

    this._refreshCallbackQueue = [];
    this._refreshInProgress = false;

    this.__defineSetter__('lang', function(value) {
        this._lang = value;
    });

    this.__defineSetter__("auth", function(value) {
        this._auth = value;
    });

    this.__defineSetter__("url", function(value) {
        this._url = value;
    });

    this.__defineSetter__("genericErrorCallback", function(value) {
        this._genericErrorCallback = value;
    });

    this.__defineSetter__('cacheLookupCallback', function(value) {
        this._cacheLookupCallback = value;
    });

    this.__defineSetter__('cacheSaveCallback', function(value) {
        this._cacheSaveCallback = value;
    });

    this.setupEx(options);
};

Core.instance = undefined;
Core.setupEx = function(options){
    if (Core.instance === undefined) {
        Core.instance = new Core();
    }

    Core.instance.setupEx(options)
};

Core.setJwt = function(jwt, jwtExpiredTime) {
    Core.instance.setJwt(jwt, jwtExpiredTime);
}

Core.setup = function(options){
    if (Core.instance === undefined) {
        Core.instance = new Core();
    }

    if (options === undefined) {
        return;
    }

    if (options.userId) {
        Core._userId = options.userId;
    }

    if (options.appKey) {
        Core._appKey = options.appKey;
    }

    if (options.url) {
        Core.instance.url = options.url;
    }

    if (options.auth) {
        Core.instance.auth = options.auth;
    }

    if (options.lang) {
        Core.instance.lang = options.lang;
    }

    if (options.genericErrorCallback) {
        Core.instance.genericErrorCallback = options.genericErrorCallback;
    }

    if (options.cacheLookupCallback) {
        Core.instance.cacheLookupCallback = options.cacheLookupCallback;
    }

    if (options.cacheSaveCallback) {
        Core.instance.cacheSaveCallback = options.cacheSaveCallback;
    }
};

Core.execute = function(method, params, auth, successCallback, errorCallback) {
    Core.setup();

    Core.instance.auth = auth;
    Core.instance.execute(method, params, successCallback, errorCallback);
};

Core.executeEx = function(apiMethod, httpMethod, params, auth, errorCodeMap, callback) {
    Core.setupEx();

    Core.instance.executeEx(apiMethod, httpMethod, params, auth, errorCodeMap, callback);
};

Core._userId = '';
Core.setUserId = function(value) {
    Core._userId = value;
};
Core._appKey = '';
Core.setAppKey = function(value) {
    Core._appKey = value;
};

Core.prototype = {
    //Replaced during CI build
    version: "1.0.0",

    prepareRequestArgs: function(params) {
        var stringParams = '',
            paramValue,
            field;

        for (field in params) {
            if (!params.hasOwnProperty(field)) {
                continue;
            }

            if (field === 'restapiUrl') {
                continue;
            }

            switch(typeof params[field]) {
                case 'function':
                    paramValue = '';
                    break;
//                case 'object':
                default:
                    paramValue = params[field].toString();
            }

            if (paramValue.length > 0) {
                stringParams += "&" + field + "=" + paramValue;
            }
        }

        return stringParams;
    },

    execute:  function(method, params, successCallback, errorCallback) {
        var responseObject, internalParams, stringParams, format, response, genericErrorCallback, cacheResponse
            , cacheSaveCallback;

        format = params.format || 'json';

        stringParams = "?method=" + method + 
	    "&format=" + format + "&lang=" + this._lang +
             this.prepareRequestArgs(params);

        if (this._auth && Core._userId.length && Core._appKey.length) {
            stringParams += "&userId=" + Core._userId + "&appKey=" + Core._appKey;
        }

        internalParams = {
            method: (stringParams.length < 2048) ? 'get' : 'post',
            uri: new Uri((params.restapiUrl || this._url) + stringParams)
        };

        genericErrorCallback = this._genericErrorCallback;

        if (this._cacheLookupCallback) {
            if (this._cacheLookupCallback(internalParams, successCallback)) {
                if (http.logRequest) {
                    var tmp = '[RestApi] Request hit cache: ' + this._url + stringParams;
                    console.log(tmp);
                }
                return;
            }
        }

        cacheSaveCallback = this._cacheSaveCallback;
        http.request(internalParams, function(response) {

            if (response.status !== 200) {
                if (typeof errorCallback === 'function') {
                    errorCallback(response.status);
                }
                return;
            }

            if (typeof successCallback !== 'function') {
                return;
            }

            if (cacheSaveCallback) {
                cacheSaveCallback(internalParams, response.body);
            }

            if (format !== 'json') {
                successCallback(response.body);
                return;
            }

            try {
                responseObject = JSON.parse(response.body);
            } catch (e) {
            }

            if (!responseObject.hasOwnProperty('response')) {
                if (typeof errorCallback === 'function') {
                    errorCallback(0);
                }
                return;
            }

            if (responseObject.response.hasOwnProperty('error')) {
                if (typeof genericErrorCallback === 'function') {
                    genericErrorCallback(
                        responseObject.response.error.code,
                        responseObject.response.error.message);
                }
            }

            successCallback(responseObject.response);
        });
    },

    executeEx: function(apiMethod, httpMethod, params, auth, errorCodeMap, callback) {
        var stringParams = ''
            , internalParams
            , responseObject
            , errorCode
            , self = this;

        if (httpMethod == 'get') {
            stringParams = '?' + this.prepareRequestArgs(params);
        }

        internalParams = {
            method: httpMethod,
            uri: new Uri(this._urlEx + apiMethod + stringParams)
        };

        if (httpMethod == 'post') {
            internalParams.post = JSON.stringify(params);
        }

        var continueCb = function() {
            if (!self.isAuthorized()) {
                // UNDONE Call genericErrorCallback
                callback(ErrorEx.Unauthorized);
                return;
            }

            self.setAuthHeader(internalParams);
            http.request(internalParams, finishCb);
        };

        var finishCb = function(response) {
            if (response.status == 401) {// HTTP/1.1 401 Unauthorized
                // UNDONE Call genericErrorCallback
                callback(ErrorEx.Unauthorized);
                return;
            }

            if (response.status != 200) {
                errorCode = ErrorEx.UNKNOWN;
                if (errorCodeMap.hasOwnProperty(response.status)) {
                    errorCode = errorCodeMap[response.status];
                }

                callback(errorCode);
                return;
            }

            responseObject = response.body;
            try {
                responseObject = JSON.parse(response.body);
            } catch (e) {
            }

            callback(ErrorEx.Success, responseObject);
        };

        var canRetryFinishCb = function(response) {
            if (response.status == 401) {// HTTP/1.1 401 Unauthorized
                self.refreshAuth(continueCb);
                return;
            }

            finishCb(response);
        };

        if (!auth) {
            http.request(internalParams, finishCb);
            return;
        }

        if (!this.isAuthorized()) {
            this.refreshAuth(continueCb);
            return;
        }

        this.setAuthHeader(internalParams);
        http.request(internalParams, canRetryFinishCb);
    },

    refreshAuth: function(cb) {
        this._refreshCallbackQueue.push(cb);

        if (this._refreshInProgress) {
            return;
        }

        this._refreshInProgress = true;
        this._jwtRefreshCallback();
    },
    isAuthorized: function() {
        return !!this._jwt && (+(Date.now()/1000) < this._jwtExpiredTime);
    },
    setAuthHeader: function(options) {
        if (!options.hasOwnProperty('headers')) {
            options.headers = {};
        }

        options.headers["Authorization"] = 'Bearer ' + this._jwt;
    },
    setJwt: function(jwt, jwtExpiredTime) {
        var c;

        this._jwt = jwt
        this._jwtExpiredTime = jwtExpiredTime;

        this._refreshInProgress = false;

        while(this._refreshCallbackQueue.length > 0) {
            c = this._refreshCallbackQueue.pop();
            c();
        }
    },
    setupEx: function(options){
        if (options === undefined) {
            return;
        }

        if (options.version) {
            this._version = options.version;
        }

        if (options.url && options.url.length > 0) {
            var baseUrl = options.url;
            if (baseUrl[baseUrl.length - 1] == '/')
                baseUrl = baseUrl.slice(0, baseUrl.length - 1);

            this._urlEx = baseUrl + '/api/' + this._version + '/';
        }

        if (options.jwtRefreshCallback) {
            this._jwtRefreshCallback = options.jwtRefreshCallback;
        }
    }

};

var App = function() {
};

App.getUi = function(callback) {
    Core.executeEx('app/ui/', 'get', {}, false, {}, callback);
};

App.getGrid = function(callback) {
    Core.executeEx('app/grid/', 'get', {}, true, {}, callback);
};


var Games = function() {
};

Games.getMaintenance = function(callback) {
    Core.executeEx('games/maintenance/', 'get', {}, false, {}, callback);
};

Games.getNews = function(callback) {
    Core.executeEx('games/news/', 'get', {}, false, {}, callback);
};

Games.getGallery = function(gameId, callback) {
    Core.executeEx('games/gallery/', 'get', {gameId:gameId}, false, {}, callback);
};

Games.getBanners = function(gameId, callback) {
    Core.executeEx('games/banners/', 'get', {gameId:gameId}, false, {}, callback);
};

Games.getAnnouncement = function(callback) {
    Core.executeEx('games/announcement/', 'get', {}, false, {}, callback);
};


var Misc = function() {
};

Misc.getTime = function(callback) {
    Core.executeEx('misc/time/', 'get', {}, false, {}, callback);
};

Misc.getIp = function(callback) {
    Core.executeEx('misc/ip/', 'get', {}, false, {}, callback);
};


var Theme = function() {
};

Theme.getList = function(callback) {
    Core.executeEx('theme/list/', 'get', {}, false, {}, callback);
};

