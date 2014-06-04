import QtQuick 1.1
//import Tulip 1.0

import "Core/App.js" as AppJs
import "Core/GoogleAnalytics.js" as GoogleAnalyticsJs
import "Core/User.js" as UserJs
import "Core/restapi.js" as RestApiJs

QtObject {

//    function setMidToGoogleAnalytics() {
//        var mid = Marketing.mid();
//        if (!mid) {
//            return;
//        }

//        RestApiJs.Marketing.getMidDetails(mid,
//                                        function(response) {
//                                            var midDescription = (response.agentId || "") +
//                                                    '-' + (response.company || "") +
//                                                    '-' + (response.urlId || "");
//                                            GoogleAnalyticsJs.setMidDescription(midDescription);
//                                        });
//    }

    Component.onCompleted: {
//        var url = Settings.value('qGNA/restApi', 'url', 'https://gnapi.com:8443/restapi');

//        RestApiJs.Core.setup({lang: 'ru', url: url});

//        console.log('appProxy', App.mainWindow);
//        console.log('Version ', App.fileVersion());
//        console.log('Desktop ', desktop);
//        console.log('RestApi ', url);

//        GoogleAnalytics.init({
//                                 saveSettings: Settings.setValue,
//                                 loadSettings: Settings.value,
//                                 desktop: desktop,
//                                 systemVersion: GoogleAnalyticsHelper.systemVersion(),
//                                 globalLocale: GoogleAnalyticsHelper.systemLanguage(),
//                                 applicationVersion: App.fileVersion()
//                             });

//        setMidToGoogleAnalytics();
    }

//    Connections {
//        target: AppJs.signalBus();
//        onAuthDone: {
//        }
//    }
}
