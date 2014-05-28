import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0


import QtQuick 1.1
import Tulip 1.0
//import QXmpp 1.0

import "./js/Core.js" as CoreJs

Rectangle {

    signal onWindowPressed(int x, int y);
    signal onWindowReleased(int x, int y);
    signal onWindowClose();
    signal onWindowOpen();
    signal onWindowPositionChanged(int x, int y);
    signal onWindowMinimize();

    signal windowDestroy();

    width: 1000
    height: 600

    color: "#092135"

    Button {
        width: 100
        height: 100
    }

    Component.onCompleted: {
        //_modelComponent = Qt.createComponent('./Application/Widgets/Messenger/Models/Messenger.qml');
        CoreJs.activateGame(CoreJs.serviceItemByGameId("92"));
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.Messenger');
            manager.registerWidget('Application.Widgets.Facts');
            manager.init();
        }
    }


    WidgetContainer {
        width: 590
        height: 50
        widget: 'Facts'

        anchors.bottom: parent.bottom
    }
}
