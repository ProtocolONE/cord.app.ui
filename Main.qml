import QtQuick 1.1
import Application.Layers 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Blocks 1.0 as Blocks
import Application 1.0

// HACL
import "./js/UserInfo.js" as UserInfo
import "./js/Core.js" as CoreJs

Rectangle {
    id: root

    signal dragWindowPressed(int x, int y);
    signal dragWindowReleased(int x, int y);
    signal dragWindowPositionChanged(int x, int y);

    signal windowClose();

    property bool progressTmp: false

    width: 1000
    height: 600
    color: "#092135"

    Bootstrap {
    }

    MouseArea {
        anchors.fill: parent
        onPressed: dragWindowPressed(mouseX,mouseY);
        onReleased: dragWindowReleased(mouseX,mouseY);
        onPositionChanged: dragWindowPositionChanged(mouseX,mouseY);
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.UserProfile');
            manager.registerWidget('Application.Widgets.Messenger');
            manager.init();
        }
    }

    PageSwitcher {
        id: switcher

        anchors.fill: parent
        sourceComponent: splashCompomemnt
    }

    Timer {
        interval: 5000
        running: true
        repeat: false
        onTriggered: switcher.sourceComponent = authComponent;
    }

    Connections {
        target: UserInfo.instance()
        onAuthDone: {
            console.log('----------------- ')
            //switcher.sourceComponent = mainComponent;
            timerSwitchToMain.start()
        }
    }

    Timer {
        id: timerSwitchToMain

        interval: 10
        running: false
        repeat: false
        onTriggered: switcher.sourceComponent = mainComponent;
    }

    Component {
        id: splashCompomemnt

        Blocks.SplashScreen {
            anchors.fill: parent
        }
    }

    Component {
        id: authComponent

        Blocks.AuthIndex {
            anchors.fill: parent
        }
    }

    Component {
        id: mainComponent

        Item {
            id: main

            anchors.fill: parent

            BaseLayer {
                anchors.fill: parent
            }

            ChatLayer {
                anchors.fill: parent
            }

            PopupLayer {
                anchors.fill: parent
            }

            TooltipLayer {
                anchors.fill: parent
            }

        }

    }

}
