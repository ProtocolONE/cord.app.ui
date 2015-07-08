.pragma library

console.log(
    "\n\nWARNIN! Google Analytics `GA` deprecated! Use `Measure Protocol` defined in GameNet\Core\Analytics.js\n\n"
);

var prestartQueue = [];
var activated = false;

var saveSettings, loadSettings;
var visits = 0;

var timestampFirst;
var timestampPrevious;
var timestampCurrent;

var googleAnalyticPage = 'http://www.google-analytics.com';

var applicationVersion;
var desktop;
var globalLocale;
var systemVersion;
var accountId; // Гугловый аккаунт един на все приложение

var tmpUserId; // используется, если пользователь не авторизован
var userId; // используется, если пользователь авторизован

var referrerPrefix = 'gamenet://qgna';
var referrer;

var deafultLabelValue = '_DEFAULT_';
var customVariable;

var sampleRate = 1500; // Из 10000
var isFiltered = true;

function initSampling() {
    var result = getRandomInt(0, 10000);

    if (result < sampleRate)  {
        isFiltered = false;
    }
}

function save(key, value) {
    if (!saveSettings) {
        console.log('Google Analytics Save function is not defined')
        return;
    }

    saveSettings('ga', key, value);
}

function load(key, defaultValue) {
    if (!loadSettings) {
        console.log('Google Analytics Load function is not defined')
        return defaultValue;
    }

    return loadSettings('ga', key, defaultValue);
}

function isNewGAAccount() {
    var result = (load('account', '') != accountId);
    save('account', accountId);
    return result;
}

function saveFirstTimestamp(timestamp) {
    save('firstTS', timestamp);
}

function loadFirstTimestamp() {
    return load('firstTS', 0);
}

function savePreviousTimestamp(timestamp) {
    save('previousTS', timestamp);
}

function loadPreviousTimestamp() {
    return load('previousTS', 0);
}

function getCurrentTimstamp() {
    return Math.floor((+ new Date()) / 1000);
}

function setMidDescription(description) {
    var name = 'mid';
    var index = '0';
    var scope = '1';

    var result = '8(' + index + '!' + encode(x10Escape(name)) + ')';
    result += '9(' + index + '!' + encode(x10Escape(description)) + ')';
    result += '11(' + index + '!' + encode(x10Escape(scope)) + ')';

    customVariable = result;
}

function init(options) {
    accountId = options.accountId;
    saveSettings = options.saveSettings;
    loadSettings = options.loadSettings;
    systemVersion = options.systemVersion;
    applicationVersion = options.applicationVersion || '0.0.0.1';
    desktop = options.desktop;
    globalLocale = options.globalLocale;

    initSampling();

    var currentTimestamp = getCurrentTimstamp();

    if (isNewGAAccount()) {
        timestampFirst = currentTimestamp;
        saveFirstTimestamp(timestampFirst);
        timestampPrevious = currentTimestamp;
    } else {
        timestampFirst = loadFirstTimestamp();
        if (!timestampFirst) {
            timestampFirst = currentTimestamp;
            saveFirstTimestamp(timestampFirst);
        }

        timestampPrevious = loadPreviousTimestamp() || currentTimestamp;
    }

    tmpUserId = getRandomInt(100000000, 0x7fffffff);
    timestampCurrent = currentTimestamp;
}

function request(options, callback) {
    var xhr = new XMLHttpRequest(),
        uri,
        userAgent;

    uri = options.uri;
    if (options.hasOwnProperty('userAgent')) {
        userAgent = options.userAgent;
    }

    xhr.onreadystatechange = function() {
        if (xhr.readyState !== 4) { // full body received
            return;
        }
        callback({status: xhr.status, header: xhr.getAllResponseHeaders(), body: xhr.responseText});
    };

    xhr.open('GET', uri.toString());

    if (userAgent) {
        xhr.setRequestHeader('QtBug', 'QTBUG-20473\r\nUser-Agent: ' + userAgent);
    }
    xhr.send(null);
}

function sendHit(hit) {
    if (isFiltered) {
        // sampled
        return;
    }

    var options = {
        uri: hit,
        userAgent: 'qGNA/' + applicationVersion + ' ' + systemVersion
    }

    request(options, function(response) {});
}

function activate() {
    activated = true;
    prestartQueue.forEach(sendHit);
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function encode(str) {
    return encodeURIComponent(str).replace(/\+/g, "%20");
}

function x10Escape(str) {
    return str.replace(/'/g, "'0")
        .replace(/\)/g, "'1")
        .replace(/\*/g, "'2")
        .replace(/!/g, "'3");
}

function correctPage(page) {
    var result = page || "";
    if (result.charAt(0) != '/') {
        result = '/' + result;
    }

    return result;
}

function formatPage(page) {
    return encode(correctPage(page));
}

function prepairCookie(referrer) {
    var result = '__utma=1.';
    result += (userId || tmpUserId) + '.';
    result += timestampFirst + '.';
    result += timestampPrevious + '.';
    timestampCurrent = getCurrentTimstamp();
    result += timestampCurrent + '.';
    timestampPrevious = timestampCurrent;

    visits++;

    result += visits;
    result += ';';


    if (referrer) {
        // UNDONE: выставить реферер куку если будет понятно зачем и как
        // Это примерный код ее обработки
        //        stringbuilder.append("+__utmz=");
        //        stringbuilder.append("1").append(".");
        //        stringbuilder.append(referrer.getTimeStamp()).append(".");
        //        stringbuilder.append(Integer.valueOf(referrer.getVisit()).toString()).append(".");
        //        stringbuilder.append(Integer.valueOf(referrer.getIndex()).toString()).append(".");
        //        stringbuilder.append(referrer.getReferrerString()).append(";");
    }

    return encode(result);
}

function trackPageView(page) {
    var result = googleAnalyticPage + "/__utm.gif";

    result += "?utmwv=4.9.1ma";
    result += "&utmn=" + getRandomInt(100000000, 0x7fffffff); // RANDOM
    result += "&utmcs=UTF-8";

    if (desktop)
        result += "&utmsr=" + desktop;

    if (globalLocale)
        result += "&utmul=" + globalLocale;

    result += "&utmp=" + formatPage(page);
    result += "&utmac=" + accountId;

    if (customVariable) {
        result += "&utme=" + customVariable;
    }

    result += "&utmcc=" + prepairCookie();

    if (referrer) {
        result += "&utmr=" + encode(referrerPrefix + referrer);
    }

    referrer = correctPage(page);

    if (!activated) {
        prestartQueue.push(result);
        return;
    }

    sendHit(result);
}

function trackEvent(page, category, action, label) {
    var result = googleAnalyticPage + "/__utm.gif";

    result += "?utmwv=4.9.1ma";
    result += "&utmn=" + getRandomInt(100000000, 0x7fffffff); // RANDOM
    result += "&utmcs=UTF-8";
    result += "&utmt=event"

    var event = "5(";
    event += encode(x10Escape(category)) + "*"
    event += encode(x10Escape(action));
    event += "*" + encode(x10Escape(label || deafultLabelValue));
    event += ")";

    if (customVariable) {
        event += customVariable;
    }

    result += "&utme=" + event;

    if (desktop)
        result += "&utmsr=" + desktop;

    if (globalLocale)
        result += "&utmul=" + globalLocale;

    result += "&utmp=" + formatPage(page);
    result += "&utmac=" + accountId;

    result += "&utmcc=" + prepairCookie();

    if (!activated) {
        prestartQueue.push(result);
        return;
    }

    sendHit(result);
}
