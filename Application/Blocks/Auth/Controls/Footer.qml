import QtQuick 2.4
import GameNet.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property alias vkButtonContainsMouse: vkButton.containsMouse
    property alias vkButtonInProgress: vkButton.inProgress
    property alias title: primaryTextButton.title
    property alias text: primaryTextButton.text
    property bool guestMode

    signal openOAuth(string network);
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

        Text {
            y: 6
            text: qsTr("Войти с помощью")
            color: Styles.lightText
            font { pixelSize: 14 }
        }

        Button {
            id: vkButton

            width: height
            height: 48

            //INFO Стили кнопки "ВКонтакте" не должны настраиваться
            style {
                normal: "#507299"
                hover: "#507299"
            }
            onClicked: root.openOAuth('vk');

            Image {
                anchors.centerIn: parent
                source: installPath +'Assets/Images/Application/Blocks/Auth/vkLogo.png'
            }
        }

        Button {
            onClicked: root.openOAuth('ok');
            width: height
            height: 48

            style {
                normal: "#F58220"
                hover: "#F58220"
            }

            Image {
                anchors.centerIn: parent
                source: installPath +'Assets/Images/Application/Blocks/Auth/okLogo.png'
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
