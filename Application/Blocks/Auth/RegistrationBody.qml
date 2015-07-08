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
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../Core/Authorization.js" as Authorization
import "../../Core/App.js" as App
import "../../Core/Styles.js" as Styles

import "./Controls"
import "./Controls/Inputs"

Form {
    id: root

    property alias login: loginInput.text
    property alias password: passwordInput.text
    property int loginMaxSize: 254

    property alias inProgress: d.inProgress

    signal error(string message);
    signal authDone(string userId, string appKey, string cookie);

    title: qsTr("REGISTER_BODY_TITLE")
    subTitle: qsTr("REGISTER_BODY_SUB_TITLE")

    footer {
        visible: true
        title: qsTr("REGISTER_BODY_AUTH_TEXT")
        text: qsTr("REGISTER_BODY_AUTH_BUTTON")
    }

    Keys.onTabPressed: loginInput.forceActiveFocus()
    Component.onCompleted: loginInput.focus = true


    QtObject {
        id: d

        property alias login: loginInput.text
        property alias password: passwordInput.text

        property bool inProgress: false

        function register() {
            var login = d.login,
                password = d.password;

            if (d.inProgress || !App.authAccepted) {
                return;
            }

            if (login.length > root.loginMaxSize) {
                loginInput.errorMessage = qsTr("REGISTER_FAIL_LOGIN_TOO_LONG");
                loginInput.error = true;
                return;
            }

            d.password = "";
            d.inProgress = true;

            Authorization.register(login, password, function(error, response) {
                if (Authorization.isSuccess(error)) {
                    d.auth(login, password);
                    return;
                }

                d.inProgress = false;

                if (!response) {
                    root.error(qsTr("REGISTER_FAIL_GAMENET_UNAVAILABLE"));
                    return;
                }

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
                d.inProgress = false;
                App.setGlobalProgressVisible(false);

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

        onInProgressChanged: App.setGlobalProgressVisible(d.inProgress);
    }

    Column {
        width: parent.width
        spacing: 15

        Column {
            width: parent.width
            height: childrenRect.height
            spacing: 14

            LoginInput {
                id: loginInput

                width: parent.width
                placeholder: qsTr("REGISTER_BODY_LOGIN_PLACEHOLDER")
                maximumLength: loginMaxSize + 1
                z: 1

                onTextChanged: {
                    if (loginInput.text.length > root.loginMaxSize) {
                      loginInput.errorMessage = qsTr("REGISTER_FAIL_LOGIN_TOO_LONG");
                      loginInput.error = true;
                    }
                }
                onTabPressed: passwordInput.forceActiveFocus();
                onBackTabPressed: passwordInput.forceActiveFocus();
            }

            PasswordInput {
                id: passwordInput

                width: parent.width
                placeholder: qsTr("REGISTER_BODY_PASSWORD_PLACEHOLDER")

                onTabPressed: loginInput.forceActiveFocus();
                onBackTabPressed: loginInput.forceActiveFocus();

                Keys.onReturnPressed: d.register();
                Keys.onEnterPressed: d.register();
            }
        }

        Item {
            width: parent.width
            height: 48

            PrimaryButton {
                width: 200
                height: parent.height
                inProgress: d.inProgress
                anchors.left: parent.left
                text: qsTr("REGISTER_BODY_REGISTER_BUTTON")
                onClicked: d.register();
                font {family: "Open Sans Regular"; pixelSize: 15}
                analytics {
                   category: 'Auth Registration'
                   action: 'submit'
                   label: 'Register'
                }
            }

            LicenseText {
                anchors.right: parent.right
                onClicked: App.openExternalUrl("https://www.gamenet.ru/license");
            }
        }
    }
}
