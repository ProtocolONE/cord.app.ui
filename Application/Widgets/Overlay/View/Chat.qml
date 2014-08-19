import QtQuick 1.1

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../../Core/Styles.js" as Styles

Item {
    property bool isShown: chat.visible

    Item {
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            onClicked: chat.visible = false;
        }

        Item {
            id: chat

            anchors {
                left: parent.left
                top: parent.top
                margins: 25
            }

            width: 590 + 230
            height: 558
            visible: false

            Row {
                anchors.fill: parent

                Column {
                    width: 230
                    height: parent.height

                    WidgetContainer {
                        height: parent.height
                        width: 230
                        widget: 'Messenger'
                        view: 'Contacts'
                    }
                }

                WidgetContainer {
                    height: parent.height
                    width: 590
                    widget: 'Messenger'
                    view: 'Chat'
                }
            }
        }
    }

    Button {
        anchors {
            right: parent.right
            top: parent.top
            margins: 25
        }

        width: 75
        height: 24
        style: ButtonStyleColors { // TODO поменять стиль
            normal: Styles.style.messengerMessageInputSendButtonNormal
            hover: Styles.style.messengerMessageInputSendButtonHover
        }

        onClicked: chat.visible = !chat.visible;
        text: qsTr("CHAT") // TODO перевод пока не добавлен
        textColor: Styles.style.messengerMessageInputSendButtonText
    }
}



