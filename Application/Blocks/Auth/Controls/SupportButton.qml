import QtQuick 1.1
import GameNet.Controls 1.0

import "../../../Core/Styles.js" as Styles

Button {
    width: 32
    height: 146
    style {
        normal: Styles.style.authSupportButtonNormal
        hover: Styles.style.authSupportButtonHover
    }

    Column {
        anchors.fill: parent

        Item {
            width: parent.width
            height: parent.height - width - 1

            Item {
                anchors.centerIn: parent
                rotation: -90
                width: parent.height
                height: parent.width

                Text {
                    anchors.centerIn: parent
                    text: qsTr("AUTH_SUPPORT_BUTTON_TEXT")
                    color: Styles.style.authSupportButtonText
                    font {
                        family: "Arial"
                        pixelSize: 14
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Styles.style.authSupportButtonText
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
