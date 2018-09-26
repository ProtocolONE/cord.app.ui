import QtQuick 2.4

import Application.Core 1.0
import Application.Core.Config 1.0

import ProtocolOne.Core 1.0

import Tulip 1.0
import "Cache.js" as Js

Item {

    // Read file from <rootDir>/Cache.
    // Find most suitable filename for api request
    // Example filename without qoutes: 'method=service.getGrid&format=json&lang=ru'
    // File should contain full response. Example:
    //    {
    //      "response": [
    //        {
    //          "id": "1117",
    //          "gridId": "147",
    //          "serviceId": "660000000000",
    //          "serviceName": "SkyFire",
    //          "typeShortcut": "new",
    //          "imageId": "216",
    //          "image": "https://gn653.cdn.gamenet.ru/TY0Xv6hRag/6JNiI/o_1UOXyL.png",
    //          "col": "2",
    //          "row": "1",
    //          "width": "1",
    //          "height": "4",
    //          "url": null,
    //          "buttonText": null
    //        }
    //      ]
    //    }
    function cacheCallback(request, successCallback) {
        var path = (installPath + "Cache/").replace('file:///', '')
        var files = FileSystem.findFiles(path, "*.*");

        files = files.map(function(m) {
            var fileName = m.slice(m.lastIndexOf('/')+1);
            return {
                path: m,
                name: fileName,
                uri: new RestApi.Uri('http://api/?' + fileName)
            }
        })

        files = files.filter(function(e) {
           var q = e.uri.query();
           var i, result = true, key, value;

           for (i = 0; i < q.params.length; i++) {
              key = q.params[i][0];
              value = q.params[i][1];
              var requestedValue = request.uri.query().getParamValue(key);
              if (requestedValue != value) {
                  console.log('Cache miss ', key, requestedValue, value, e.name)
                  result = false;
                  break;
              }
           }

           e.filterCount = q.params.length;
           return result;
        })

        files.sort(function(a,b) {return b.filterCount - a.filterCount});

        if (files.length === 0)
            return;

        var cacheFilePath = files[0].path;
        var cacheResult = FileSystem.readFile(cacheFilePath)
        console.log('Cache hit:', cacheFilePath)

        if (request.uri.query().getParamValue("format") === "json") {
            try {
                cacheResult = JSON.parse(cacheResult);
                if (cacheResult.hasOwnProperty('response')) {
                    Js.push(successCallback, cacheResult.response);
                    callCb.restart();
                    return true;
                }
            } catch(e) {
                console.log('Cache error', cacheFilePath, e);
            }

            return false;
        }

        Js.push(successCallback, cacheResult)
        callCb.restart();

        return true;
    }

    function cacheSaveCallback(requestParams, response) {
        var q = requestParams.uri.query();
        var keys = [], i, key;
        var skipKeys = {
            'userId' : 1,
            'appKey' : 1,
            'method' : 1,
            'format' : 1,
            'lang' : 1
        }

        for (i = 0; i < q.params.length; i++) {
            key = q.params[i][0];
            if (skipKeys.hasOwnProperty(key)) {
                continue;
            }

            keys.push(key);
        }

        keys.sort();

        var m = q.getParamValue("method");
        var f = q.getParamValue("format");
        var l = q.getParamValue("lang");
        var params = []
        if (m)
            params.push("method=" + m);
        if (f)
            params.push("format=" + f);
        if (l)
            params.push("lang=" + l);

        keys.forEach(function(k) {
            var v = q.getParamValue(k)
            params.push(k + "=" + v);
        });

        var rootPath = (installPath + "Cache/").replace('file:///', '')
        var fileName = params.join('&');
        console.log('[Cache] Save cache params', fileName)

        var responseContent = response;
        if (f == "json") {
            try {
                var tmp = JSON.parse(responseContent);
                responseContent = JSON.stringify(tmp, null, 2);
            } catch(e) {

            }
        }

        FileSystem.writeFile(rootPath + fileName, responseContent);
    }

    Component.onCompleted:  {
        if (Config.saveApi()) {
            RestApi.Core.setup({
                                   cacheSaveCallback: cacheSaveCallback
                               });
        }

        RestApi.Core.setup({
                               cacheLookupCallback: cacheCallback
                           });
    }

    Timer {
        id: callCb

        property string value
        property bool json

        interval: 1
        repeat: true
        onTriggered: {
            console.log('cache hit')
            if (Js.queue.length === 0) {
                console.log('cache empty')
                callCb.stop();
                return;
            }

            var nextItem = Js.queue.pop();

            if (!!nextItem) {
                console.log('call cb')
                nextItem.cb(nextItem.value);
            }
        }
    }

}
