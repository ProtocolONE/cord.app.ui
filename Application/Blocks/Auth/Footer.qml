import QtQuick 1.1
import GameNet.Controls 1.0 as Control

Item {
    id: root

    property alias vkButtonContainsMouse: vkButton.containsMouse

    signal openVkAuth();

    implicitHeight: 65

    Item {
        anchors { fill: parent; leftMargin: 250; rightMargin: 250 }

        Rectangle {
            height: 1
            color: "#ECECEC"
            anchors { left: parent.left; right: parent.right; top: parent.top }
        }

        Rectangle {
            height: 1
            color: "#FFFFFF"
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
                    color: "#66758F"
                    font { pixelSize: 12; family: "Arial" }
                }
            }

            Control.Button {
                id: vkButton

                width: height + vkCaption.width + 21
                height: 24

                style: Control.ButtonStyleColors {
                    normal: "#4D739E"
                    hover: "#3378c7"
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
                            color: "#FFFFFF"
                            font { pixelSize: 14; family: "Arial" }
                        }
                    }

                    Rectangle {
                        width: 1
                        height: 24
                        color: "#5F81A8"
                    }

                    Item {
                        width: vkCaption.width + 20
                        height: 24

                        Text {
                            id: vkCaption
                            text: "ВКонтакте"
                            color: "#FFFFFF"

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
}
