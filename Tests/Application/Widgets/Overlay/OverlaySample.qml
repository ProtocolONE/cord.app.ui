import QtQuick 2.4
import Tulip 1.0
import Dev 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Core 1.0

import Application.Controls 1.0

import "../../../../Application/Core/App.js" as App
import "../"

Rectangle {
    id: root

    width: 800
    height: 800
    color: '#EEEEEE'

    function initEmojiOne() {
        if (App.isQmlViewer()) {
            EmojiOne.ns.imagePathPNG = (installPath + 'Develop/Assets/Smiles/');//.replace("file:///", ""); // Debug for QmlViewer
        } else {
            EmojiOne.ns.imagePathPNG = 'qrc:///Develop/Assets/Smiles/';
        }

        EmojiOne.ns.ascii = true;
        EmojiOne.ns.unicodeAlt = false;
        EmojiOne.ns.cacheBustParam = "";
        EmojiOne.ns.addedImageProps = '"width"= "20" height"="20"'
    }

    RequestServices {
        onReady: {
            AppSettings.setValue('gameExecutor/serviceInfo/' + serviceId + "/",
                                 "overlayEnabled", 1);

            var serviceId = App.serviceItemByGameId("71").serviceId;
            initOverlayTimer.start();
        }
    }

    Item {
        id: manager

        Component.onCompleted: {
            Shell.execute(installPath + "Tests/Application/Widgets/Overlay/Tools/NormalWayIntegration.exe", ["-width", "1920", "-height", "1080"]);

            WidgetManager.registerWidget('Application.Widgets.UserProfile');
            WidgetManager.registerWidget('Application.Widgets.Messenger');
            WidgetManager.registerWidget('Application.Widgets.DetailedUserInfo');
            WidgetManager.registerWidget('Application.Widgets.AlertAdapter');

            WidgetManager.registerWidget('Application.Widgets.Money');
            WidgetManager.registerWidget('Application.Widgets.Overlay');
            WidgetManager.init();

            root.initEmojiOne();

            // INFO не работает
//            App.isPublicVersion = function() {
//                return true;
//            }

        }
    }

    Timer {
        id: initOverlayTimer

        interval: 3000
        repeat: false
        onTriggered: {
            SignalBus.serviceStarted(App.serviceItemByGameId("71"));
            //SignalBus.navigate("goprotocolonemoney", '');
        }
    }
}
