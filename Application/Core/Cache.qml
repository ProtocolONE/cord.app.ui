import QtQuick 2.4

import Application.Core 1.0
import ProtocolOne.Core 1.0

import Tulip 1.0

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
    function cachCallback(request) {
        var path = (installPath + "Cache/").replace('file:///', '')
        var files = FileSystem.findFiles(path, "*.*");

        //console.log(request.uri.toString())

        files = files.map(function(m) {
            var fileName = m.slice(m.lastIndexOf('/')+1);
            //console.log(fileName);
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
              if (request.uri.query().getParamValue(key) != value) {
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
        return {
            success: true,
            response: cacheResult
        }
    }

    Component.onCompleted:  {
        RestApi.Core.setup({
                               cacheLookupCallback: cachCallback
                           });
    }

}
