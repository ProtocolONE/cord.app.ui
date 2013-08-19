/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import "../../Elements" as Elements
import "../../Blocks" as Blocks
import "../../js/Core.js" as Core
import "../../js/support.js" as SupportHelper

import "index.js" as Js

Blocks.MoveUpPage {
    id: root

    property string messageText: qsTr("PUBLIC_TEST_HELP_TEXT")
    property string headerTitle: qsTr("PUBLIC_TEST_TITLE")

    width: Core.clientWidth
    height: Core.clientHeight
    openHeight: 464

    Component.onCompleted: Js.publicTestInit(root);

    Rectangle {
        id: alertRectangleBlock

        color: "#353945"
        anchors.fill: parent

        Rectangle {
            anchors { right: parent.right; left: parent.left; top: parent.top }
            height: 1
            color: "#FFFFFF"
            opacity: 0.15
        }

        Text {
            id: mainAlertText

            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors { topMargin: 30; leftMargin: 275; rightMargin: 60 }
            font { family: "Arial"; pixelSize: 13 }
            text: messageText
            wrapMode: Text.Wrap
            color: "#FFFFFF"
            smooth: true
            onLinkActivated: mainAuthModule.openWebPage(link);
        }

        Row {
            id: controlRowId

            spacing: 8
            anchors {
                top: mainAlertText.top
                topMargin: mainAlertText.height + 15
                left: mainAlertText.left
            }

             Elements.Button2 {
                 buttonText: qsTr("PUBLIC_TEST_SUPPORT_BUTTON")
                 onClicked: {
                     root.closeMoveUpPage();
                     SupportHelper.show(root, Core.currentGame() ? Core.currentGame().gaName : '');
                 }
             }

             Elements.Button2 {
                 buttonText: qsTr("PUBLIC_TEST_CHANGE_VERSION_BUTTON")
                 onClicked: {
                     root.closeMoveUpPage();
                     settingsViewModel.switchClientVersion();
                 }
             }

             Elements.Button2 {
                 buttonText: qsTr("PUBLIC_TEST_CLOSE_BUTTON")
                 onClicked: root.closeMoveUpPage();
             }
        }

        Text {
            anchors { top: parent.top; left: parent.left; leftMargin: 42; topMargin: 30 }
            width: 200
            font { family: "Tahoma"; pixelSize: 16 }
            text: headerTitle
            wrapMode: Text.WordWrap
            color: "#ffff66"
            smooth: true
        }
    }
}

