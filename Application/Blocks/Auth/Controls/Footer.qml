import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property alias vkButtonContainsMouse: vkButton.containsMouse
    property alias vkButtonInProgress: vkButton.inProgress
    property alias title: primaryTextButton.title
    property alias text: primaryTextButton.text

    signal openOAuth(string network);
    signal clicked();

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
            height: 40
            anchors.verticalCenter: parent.verticalCenter

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
            height: 40

            anchors.verticalCenter: parent.verticalCenter

            style {
                normal: "#F58220"
                hover: "#F58220"
            }

            Image {
                anchors.centerIn: parent
                source: installPath +'Assets/Images/Application/Blocks/Auth/okLogo.png'
            }
        }

        Button {
            onClicked: root.openOAuth('fb');
            width: height
            height: 40

            anchors.verticalCenter: parent.verticalCenter

            style {
                normal: "#2a5ecd"
                hover: "#2a5ecd"
            }

            Image {
                anchors.centerIn: parent
                source: installPath +'Assets/Images/Application/Blocks/Auth/facebookLogo.png'
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
        }
    }
}
