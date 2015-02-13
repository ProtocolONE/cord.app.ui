/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import GameNet.Controls 1.0
import "../../../../Core/Styles.js" as Styles
import "../../../../Core/App.js" as App

Rectangle {
    property alias name: targetNickname.text
    property alias statusColor: statusColorItem.color

    implicitWidth: parent.width
    implicitHeight: 35
    color: Styles.style.detailedUserInfoHeaderBackground

    Row {
        anchors {
            fill: parent
            leftMargin: 10
        }

        spacing: 8

        Rectangle {
            id: statusColorItem

            anchors.verticalCenter: parent.verticalCenter

            width: 10
            height: 10
            radius: 5
        }

        Text {
            id: targetNickname

            color: Styles.style.detailedUserInfoHeaderText
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    ImageButton {
        anchors {
            right: parent.right
        }

        width: 26
        height: parent.height

        style {
            normal: "#00000000"
            hover: "#00000000"
            disabled: "#00000000"
        }

        styleImages {
            normal: installPath + "Assets/Images/closeButton.png"
        }

        opacity: containsMouse ? 1 : 0.5
        onClicked: App.closeDetailedUserInfo()

        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
    }
}
