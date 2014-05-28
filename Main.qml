import QtQuick 1.1
import Application.Layers 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Blocks 1.0 as Blocks

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

    MouseArea {
        anchors.fill: parent
        onPressed: dragWindowPressed(mouseX,mouseY);
        onReleased: dragWindowReleased(mouseX,mouseY);
        onPositionChanged: dragWindowPositionChanged(mouseX,mouseY);
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.Messenger');
            manager.init();
        }
    }

    PageSwitcher {
        id: switcher

        anchors.fill: parent
        sourceComponent: splashCompomemnt
    }

    Component {
        id: splashCompomemnt

        Blocks.SplashScreen {
            Component.onDestruction:  {
                console.log('--------- splash destroyed')
            }

            anchors.fill: parent

            Button {
                width: 10
                height: 10
                onClicked: {
                    switcher.sourceComponent = authComponent;
                }
            }
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
