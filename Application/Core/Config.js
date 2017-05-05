.pragma library

var debug = false;

Qt.include("Config.release.js");

try {
    // INFO - usefull for QmlViewer
    Qt.include('../../Develop/ExternalConfig/Config.js');
} catch(e) {
}

try {
    // Load config from Config.rcc if it exists
    Qt.include('qrc:///ExternalConfig/Config.js');
} catch(e) {
}

function getConfig() {
    var _externalConfig;

    try {
        _externalConfig = getAltConfig();
    } catch(e) {
    }

    return _externalConfig || _internal;
}

function show() {
    console.log("Global config:\n", JSON.stringify(getConfig(), null, 2));
}

function getApiUrl() {
    return getConfig().apiUrl;
}

var GnUrl = function() {
};

GnUrl.site = function (path) {
    var result = getConfig().wwwUrl + (path || "");
    if (debug) {
        console.log('gnUrl.site = ', result);
    }

    return result;
}

GnUrl.login = function (path) {
    var result = getConfig().gnloginUrl + (path || "");
    if (debug) {
        console.log('gnUrl.login = ', result);
    }

    return result;
}

GnUrl.api = function (path) {
    var result = getConfig().apiUrl + (path || "");
    if (debug) {
        console.log('gnUrl.api = ', result);
    }

    return result;
}

GnUrl.overrideApi = function () {
    if (debug) {
        console.log('GnUrl.overrideApi = ', getConfig().overrideApi)
    }

    return getConfig().overrideApi;
}

GnUrl.statusUrl = function () {
    if (debug) {
        console.log('GnUrl.statusUrl = ', getConfig().statusUrl)
    }

    return getConfig().statusUrl;
}

var Jabber = function() {}

Jabber.server = function() {
    if (debug) {
        console.log('Jabber.server = ', getConfig().jabberServer)
    }

    return getConfig().jabberServer;
}

