/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import "../js/Core.js" as Core
import "../Elements" as Elements

Item {
    property variant currentSocialTable: Core.getCurrentSocialTable()

    function refreshModel() {
        view.model.clear();

        if(currentSocialTable) {
            currentSocialTable.forEach(function(e) {
                view.model.append(e);
            })
        }
    }

    onCurrentSocialTableChanged: startAnimTimer.start()

    width: 300
    height: 41

    SequentialAnimation {
        id: switchAnim

        NumberAnimation { target: view; property: "opacity"; to: 0; duration: 250 }
        ScriptAction { script: refreshModel(); }
        ParallelAnimation {
            NumberAnimation { target: title; property: "opacity";  to: 0.8; duration: 250 }
            NumberAnimation { target: view; property: "opacity"; from: 0; to: 1; duration: 250 }
        }
    }

    SequentialAnimation {
        id: switchToEmptyAnim

        ParallelAnimation {
            NumberAnimation { target: title; property: "opacity"; from: 0.8; to: 0; duration: 250 }
            NumberAnimation { target: view; property: "opacity"; from: 1; to: 0; duration: 250 }
        }
    }

    Timer
    {
        id: startAnimTimer

        running: false
        interval: 1
        repeat: false
        onTriggered: {
            if (!!currentSocialTable && currentSocialTable.length) {
                switchAnim.start();
            } else {
                switchToEmptyAnim.start();
            }
        }
    }

    ListView {
        id: view

        width: count == 0 ? 10 : (count * (26 + 5))
        anchors { top: parent.top; right: parent.right }
        spacing: 5
        orientation: ListView.Horizontal
        layoutDirection: Qt.RightToLeft
        model: ListModel {}

        delegate: Image {
            width: 26
            height: 26
            opacity: mouser.containsMouse ? 1 : 0.8
            source : installPath + icon

            Behavior on opacity {
                NumberAnimation { duration: 250 }
            }

            Elements.CursorMouseArea {
                id: mouser

                anchors.fill: parent
                hoverEnabled: true
                onClicked: Qt.openUrlExternally(link)
            }
        }
    }

    Text {
        id: title

        anchors { bottom: parent.bottom; right: parent.right }
        color: "#ffffff"
        text: qsTr("SOCIAL_NET_TEXT")
        font { family: "Arial"; pixelSize : 12 }
        opacity: 0.8
    }
}
