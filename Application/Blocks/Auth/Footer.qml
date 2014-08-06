import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

Item {
    id: root

    property alias vkButtonContainsMouse: vkButton.containsMouse
    property alias vkButtonInProgress: vkButton.inProgress

    signal openVkAuth();

    implicitHeight: 65

    Rectangle {
        height: 1
        color: Styles.style.authDelimiter
        anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 1 }
    }

    Row {
        spacing: 10
        anchors { fill: parent; topMargin: 21 }

        Item {
            width: 116
            height: 24

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("AUTH_FOOTER_ALTERNATIVE_LOGIN")
                color: Styles.style.authSubTitleText
                font { pixelSize: 12; family: "Arial" }
            }
        }

        //INFO Стили кнопки "ВКонтакте" не должны настраиваться
        Button {
            id: vkButton

            width: height + vkCaption.width + 21
            height: 24

            style {
                normal: Styles.style.authVkButtonNormal
                hover: Styles.style.authVkButtonHover
            }

            onClicked: root.openVkAuth();

            Row {
                anchors.fill: parent

                Item {
                    width: 24
                    height: 24

                    // UNDONE вероятно лучше картинку
                    Text {
                        anchors.centerIn: parent
                        text: "B"
                        color: Styles.style.authVkButtonText
                        font { pixelSize: 14; family: "Arial" }
                    }
                }

                Rectangle {
                    width: 1
                    height: 24
                    color: Styles.style.authVkButtonNormal
                }

                Item {
                    width: vkCaption.width + 20
                    height: 24

                    Text {
                        id: vkCaption
                        text: "ВКонтакте"
                        color: Styles.style.authVkButtonText

                        visible: !root.vkButtonInProgress
                        font { pixelSize: 14; family: "Arial" }
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 10

                        }
                    }
                }
            }
        }
    }

}
