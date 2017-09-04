import QtQuick 2.4
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Button {
    width: 32
    height: 160
    style {
        normal: "#ffae02"
        hover: "#ffcc02"
    }

    Column {
        anchors.fill: parent

        Item {
            width: parent.width
            height: 24

            Image {
                anchors.centerIn: parent
                source: installPath + Styles.linkIconAsk
            }
        }    

        Item {
            width: parent.width
            height: parent.height - width - 30

            Item {
                anchors.centerIn: parent
                rotation: -90
                width: parent.height
                height: parent.width

                Text {
                    anchors.centerIn: parent
                    text: qsTr("AUTH_SUPPORT_BUTTON_TEXT")
                    color: Styles.lightText
                    font {
                        family: "Arial"
                        pixelSize: 14
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 5
            color: Styles.light
            opacity: 0.2
        }

        Item {
            width: parent.width
            height: width

            Image {
                anchors.centerIn: parent
                source: installPath + "Assets/Images/Application/Blocks/Auth/support.png"
            }
        }
    }
}
