import QtQuick 1.1

import GameNet.Controls 1.0
import Application.Controls 1.0

TrayPopupBase {
    id: root

    property string jid
    property string messageText
    property string avatar
    property string nickname

    width: 209
    height: 122

    Column {
        Rectangle {
            width: 209
            height: 52
            color: "#252932"

            Row {
                anchors { fill: parent; margins: 10 }
                spacing: 10

                Image {
                    source: avatar
                    width: 32
                    height: 32
                    cache: true
                    asynchronous: true
                }

                Text {
                    text: nickname
                    color: "#FAFAFA"
                    width: 160
                    elide: Text.ElideRight
                    anchors.verticalCenter: parent.verticalCenter
                    font { pixelSize: 18; family: "Arial"}
                }
            }
        }

        Rectangle {
            width: 209
            height: 70
            color: "#243148"

            Text {
                text: messageText
                color: "#FAFAFA"
                elide: Text.ElideRight
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 3
                font { pixelSize: 14; family: "Arial"}
                anchors { fill: parent; margins: 10 }
            }
        }
    }

    Image {
        id: closeButtonImage

        anchors { right: parent.right; top: parent.top; rightMargin: 9; topMargin: 9 }
        visible: containsMouse || closeButtonImageMouser.containsMouse
        source: installPath + "Assets/Images/Application/Core/TrayPopup/closeButton.png"
        opacity: closeButtonImageMouser.containsMouse ? 0.9 : 0.5

        Behavior on opacity {
            PropertyAnimation {
                duration: 225
            }
        }

        CursorMouseArea {
            id: closeButtonImageMouser

            anchors.fill: parent
            hoverEnabled: true
            onClicked: shadowDestroy();
        }
    }
}