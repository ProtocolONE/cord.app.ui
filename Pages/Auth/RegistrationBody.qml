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
import Tulip 1.0
import "../../Controls" as Controls
import "../../js/Authorization.js" as Authorization
import "../../js/Core.js" as Core
import "../../Proxy/App.js" as App

Item {
    id: root

    property alias login: loginInput.text
    property alias password: passwordInput.text

    signal switchToLogin();
    signal error(string message);
    signal authDone(string userId, string appKey, string cookie);

    implicitHeight: 473
    implicitWidth: 500

    QtObject {
        id: d

        property alias login: loginInput.text
        property alias password: passwordInput.text

        function register() {
            var login = d.login,
                password = d.password;
            d.password = "";
            Core.setGlobalProgressVisible(true);

            Authorization.register(login, password, function(error, response) {
                if (Authorization.isSuccess(error)) {
                    d.auth(login, password);
                    return;
                }

                Core.setGlobalProgressVisible(false);
                if (response.message.login) {
                    loginInput.errorMessage = response.message.login;
                    loginInput.error = true;
                }

                if (response.message.password) {
                    passwordInput.errorMessage = response.message.password;
                    passwordInput.error = true;
                }
            });
        }

        function auth(login, password) {
            Authorization.loginByGameNet(login, password, function(error, response) {
                Core.setGlobalProgressVisible(false);

                if (Authorization.isSuccess(error)) {
                    root.authDone(response.userId, response.appKey, response.cookie);
                    return;
                }

                var errorMessage;

                if (!response) {
                    errorMessage = qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR");
                } else {
                    var map = {
                        0: qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR"),
                    };
                    map[RestApi.Error.AUTHORIZATION_FAILED] = qsTr("AUTH_FAIL_MESSAGE_WRONG");
                    map[RestApi.Error.INCORRECT_FORMAT_EMAIL] = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");
                    errorMessage = map[response.code] || map[0];
                }

                root.error(errorMessage);
            });
        }
    }

    Column {
        anchors.fill: parent
        spacing: 20

        Item {
            width: parent.width
            height: 74

            Text {
                text: qsTr("REGISTER_BODY_TITLE")
                font { family: "Arial"; pixelSize: 20 }
                anchors { baseline: parent.top; baselineOffset: 35 }
                color: "#363636"
            }

            Text {
                text: qsTr("REGISTER_BODY_SUB_TITLE")
                color: "#66758F"
                anchors { baseline: parent.top; baselineOffset: 64 }
                font { family: "Arial"; pixelSize: 14 }
            }
        }

        LoginInput {
            id: loginInput

            width: parent.width
            placeholder: qsTr("REGISTER_BODY_LOGIN_PLACEHOLDER")
            z: 1

            Keys.onTabPressed: passwordInput.focus = true;
            Keys.onBacktabPressed: passwordInput.focus = true;
        }

        PasswordInput {
            id: passwordInput

            width: parent.width
            placeholder: qsTr("REGISTER_BODY_PASSWORD_PLACEHOLDER")

            Keys.onTabPressed: loginInput.focus = true;
            Keys.onBacktabPressed: loginInput.focus = true;

            Keys.onReturnPressed: d.register();
            Keys.onEnterPressed: d.register();
        }

        Row {
            width: parent.width
            height: 48
            spacing: 30

            Controls.Button {
                width: 200
                height: parent.height
                text: qsTr("REGISTER_BODY_REGISTER_BUTTON")
                onClicked: d.register();
            }

            Rectangle {
                width: 1
                color: "#CCCCCC"
                height: parent.height
            }

            Row {
                height: parent.height
                width: 200
                spacing: 5

                Text {
                    anchors { baseline: parent.bottom; baselineOffset: -21 }
                    color: "#66758F"
                    font { family: "Arial"; pixelSize: 12 }
                    text: qsTr("REGISTER_BODY_AUTH_TEXT")
                }

                Controls.TextButton {
                    anchors { baseline: parent.bottom; baselineOffset: -21 }
                    height: parent.height
                    text: qsTr("REGISTER_BODY_AUTH_BUTTON")
                    style: Controls.ButtonStyleColors {
                        normal: "#3498db"
                        hover: "#3670DC"
                        disabled: "#3498db"
                    }

                    fontSize: 12
                    onClicked: root.switchToLogin();
                }
            }
        }
    }

    Row {
        opacity: licenseMouse.containsMouse ? 1 : 0.2
        height: 40
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        spacing: 5

        Text {
            anchors { baseline: parent.bottom; baselineOffset: -20 }
            font.pixelSize: 12
            color: "#66758F"
            text: qsTr("REGISTER_BODY_LICENSE_PART1")
        }

        Controls.TextButton {
            anchors { baseline: parent.bottom; baselineOffset: -20 }
            fontSize: 12
            text: qsTr("REGISTER_BODY_LICENSE_PART2")

            style: Controls.ButtonStyleColors {
                normal: "#3498db"
                hover: "#3670DC"
                disabled: "#3498db"
            }

            onClicked: App.openExternalUrl("http://www.gamenet.ru/license");

            CursorArea {
                anchors.fill: parent
                cursor: licenseMouse.containsMouse ? CursorArea.PointingHandCursor : CursorArea.ArrowCursor
            }
        }
    }

    MouseArea {
        id: licenseMouse

        height: 25
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; bottomMargin: 15 }
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }
}
