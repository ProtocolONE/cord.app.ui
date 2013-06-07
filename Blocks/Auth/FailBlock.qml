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
import "../../js/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: failPage

    property string errorMessage

    Item {
        id: authError

        anchors { left: parent.left; top: parent.top; right: parent.right }
        anchors { leftMargin: 254 + 65; topMargin: 80; rightMargin: 20 }

        Column {
            anchors { fill: parent }
            spacing: 10

            Text {
                id: authErrorText

                color: "#ffff66"
                anchors { left: parent.left; right: parent.right }
                text: failPage.errorMessage
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                width: 500
                font { family: "Arial"; pixelSize: 16 }
                onLinkActivated: Qt.openUrlExternally(link);
            }

            Elements.Button {
                id: forgotPasswordOKbutton

                buttonText: qsTr("BUTTON_OK")
                width: 68
                focus: true
                onButtonPressed: {
                    GoogleAnalytics.trackEvent('/AuthFail', 'Auth', 'Confirm Ok');
                    authRegisterMoveUpPage.state = (authRegisterMoveUpPage.state === "FailAuthPage")
                            ? "AuthPage"
                            : "RegistrationPage";
                }
            }

            Item {
                width: 1
                height: 1
            }

            Text {
                color: "#d8e5d4"
                anchors { left: parent.left }
                text: qsTr("RESTORE_PASSWORD_LINK")
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                font { family: "Arial"; pixelSize: 14 }
                onLinkActivated: Qt.openUrlExternally(link);

                Elements.CursorShapeArea { anchors.fill: parent }
            }
        }
    }
}
