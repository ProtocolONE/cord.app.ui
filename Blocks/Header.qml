import QtQuick 1.1

import "../js/Core.js" as Core
import "../Elements" as Elements

Item {
    property variant currentItem: Core.currentGame()

    signal homeButtonClicked();

    function setupText() {
        gameTitle.text = currentItem ? currentItem.name :  qsTr("ALL_GAMES");
        descr.text = currentItem ? Core.gamesListModel.shortDescribtion(currentItem.gameId) : qsTr("FREE_OF_CHARGE");
    }

    implicitHeight: 86
    onCurrentItemChanged: {
        if (Core.previousGame()) {
            gameChangeAnim.start();
        } else {
            container.opacity = 0;
            startAnimTimer.start();
        }
    }

    Timer
    {
        id: startAnimTimer

        running: false
        interval: 1
        repeat: false
        onTriggered: fromHomeAnim.start()
    }

    Rectangle {
        color: "#000000"
        height: 86
        width: parent.width
        opacity: 0.4
    }

    SequentialAnimation {
        id: gameChangeAnim

        PropertyAnimation { target: container; property: "opacity"; to: 0; duration: 250 }
        ScriptAction { script: setupText() }
        PropertyAnimation { targets: container; property: "opacity"; to: 1; duration: 250 }
    }

    SequentialAnimation {
        id: fromHomeAnim

        PauseAnimation { duration: 250 }
        ScriptAction { script: setupText() }
        PropertyAnimation { targets: container; property: "opacity"; to: 1; duration: 250 }
    }

    Item {
        id: container

        anchors { fill: parent; leftMargin: 30 }

        Item {
            anchors { top: parent.top; left: gameTitle.left; topMargin: 12; leftMargin: gameTitle.width * 0.8 }
            height: 21
            width: descr.width + 11

            Rectangle{
                anchors.fill: parent
                color :"#ffffff"
                opacity: 0.7
            }

            Text {
                id: descr

                color: "#000000"
                font { family: "Arial"; bold: false; pixelSize: 12; letterSpacing: 0.4 }
                anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 6 }
                smooth: true
            }
        }

        Text {
            id: gameTitle

            anchors { top: parent.top; topMargin: 20 }
            font { family: "Segoe UI Light"; bold: false; pixelSize: 46 }
            smooth: true
            color: "#ffffff"
        }

        Text {
            anchors { top: parent.top; left: parent.left; topMargin: 14 }
            color: "#ffffff"
            text: qsTr("ALL_GAMES")
            font { family: "Arial"; bold: false; pixelSize: 14 }

            Elements.CursorMouseArea {
                anchors.fill: parent
                onClicked: homeButtonClicked();
            }
        }
    }
}
