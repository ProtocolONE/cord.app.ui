import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../Core/Styles.js" as Styles

Item {
    id: root

    property alias vkButtonContainsMouse: vkButton.containsMouse
    property alias vkButtonInProgress: vkButton.inProgress
    property alias title: primaryTextButton.title
    property alias text: primaryTextButton.text
    property bool guestMode

    signal openVkAuth();
    signal clicked();
    signal guestClicked();

    implicitHeight: 100
    implicitWidth: 500

    ContentStroke {
        width: parent.width
        opacity: 0.25
    }

    Row {
        spacing: 10
        anchors { left: parent.left; top: parent.top; topMargin: 22 }

        Button {
            id: vkButton

            width: height + vkCaption.width + 21
            height: 48

            //INFO Стили кнопки "ВКонтакте" не должны настраиваться
            style {
                normal: "#379adb"
                hover: "#379adb"
            }
            onClicked: root.openVkAuth();

            Row {
                anchors.fill: parent

                Item {
                    width: 48
                    height: 48

                    Rectangle {
                        anchors.fill: parent
                        color: "#2174c7"
                    }

                    Image {
                        anchors.centerIn: parent
                        source: installPath +'Assets/Images/Application/Blocks/Auth/vkLogo.png'
                    }
                }

                Item {
                    width: vkCaption.width + 20
                    height: parent.height

                    Text {
                        id: vkCaption
                        text: qsTr("VK_LOGIN_BUTTON_TEXT")
                        color: Styles.style.authVkButtonText
                        visible: !root.vkButtonInProgress
                        font { pixelSize: 15; family: "Open Sans Regular" }
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

    Item {
        anchors {
            top: parent.top;
            right: parent.right;
            topMargin: 22
        }
        height: 48

        Column {
            anchors {
                verticalCenter: parent.verticalCenter;
                right: parent.right
            }
            height: childrenRect.height

            FooterButton {
                id: primaryTextButton

                anchors.right: parent.right
                onClicked: root.clicked();
            }

            FooterButton {
                title: qsTr("LOGIN_BY_GUEST_TITLE")
                text: qsTr("LOGIN_BY_GUEST_BUTTON_TEXT")
                visible: root.guestMode
                onClicked: root.guestClicked();
            }
        }
    }
}
