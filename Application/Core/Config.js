.pragma library

var debug = false;

Qt.include("Config.release.js");
//Qt.include("Config.debug.js");

function show() {
    console.log("Global config:\n", JSON.stringify(_internal, null, 2));
}

function getApiUrl() {
    return _internal.apiUrl;
}

var GnUrl = function() {
};

GnUrl.site = function (path) {
    var result = _internal.wwwUrl + (path || "");
    if (debug) {
        console.log('gnUrl.site = ', result);
    }

    return result;
}

GnUrl.login = function (path) {
    var result = _internal.gnloginUrl + (path || "");
    if (debug) {
        console.log('gnUrl.login = ', result);
    }

    return result;
}

GnUrl.api = function (path) {
    var result = _internal.apiUrl + (path || "");
    if (debug) {
        console.log('gnUrl.api = ', result);
    }

    return result;
}

GnUrl.overrideApi = function () {
    if (debug) {
        console.log('GnUrl.overrideApi = ', _internal.overrideApi)
    }

    return _internal.overrideApi;
}

GnUrl.statusUrl = function () {
    if (debug) {
        console.log('GnUrl.statusUrl = ', _internal.statusUrl)
    }

    return _internal.statusUrl;
}

var Jabber = function() {}

Jabber.server = function() {
    if (debug) {
        console.log('Jabber.server = ', _internal.jabberServer)
    }

    return _internal.jabberServer;
}

