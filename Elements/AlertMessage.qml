/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "." as Elements
import "../Blocks" as Blocks

Blocks.MoveUpPage {
    id: alertModule

    property alias controlRow: controlRowId
    property string messageText: "Not set message Not set message Not set message Not set message Not set message"
    property string headerTitle: "Not set message Not set message Not set message Not set message Not set message"

    signal clicked(int buttonId)
    signal buttonClicked(int messageId, int buttonId)

    width: 800
    height: 550
    openHeight: 292

    Component.onCompleted: alertModule.openMoveUpPage();

    onClicked: alertModule.closeMoveUpPage();
    onFinishClosing: alertModule.destroy();

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

