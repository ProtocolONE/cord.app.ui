/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0
import GameNet.Controls 1.0
import GameNet.Core 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Authorization 1.0

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

    title: qsTr("CONFIRM_GUEST_BODY_TITLE")
    subTitle: qsTr("CONFIRM_GUEST_BODY_SUB_TITLE")

    footer {
        visible: false
    }

    Keys.onTabPressed: loginInput.forceActiveFocus()
    Component.onCompleted: loginInput.focus = true

    QtObject {
        id: d

        property alias login: loginInput.text
        property alias password: passwordInput.text

        property bool inProgress: false

        function loginSuggestion() {
            var logins = {};
            try {
                logins = JSON.parse(AppSettings.value("qml/auth/", "authedLogins", "{}"));
            } catch (e) {
            }

            return logins;
        }

        function saveAuthorizedLogins(login) {
            var currentValue = d.loginSuggestion();
            currentValue[login] = +new Date();
            AppSettings.setValue("qml/auth/" , "authedLogins", JSON.stringify(currentValue));
        }

        function confirmGuest() {
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

            var auth = new Authorization.ProviderGuest();
            auth.confirm(User.userId(),
                         User.appKey(),
                         login,
                         password,
                         function(error, response) {
                            d.inProgress = false;

                             if (Authorization.isSuccess(error)) {
                                 d.saveAuthorizedLogins(d.login);
                                 root.authDone(response.userId, response.appKey, response.cookie);
                                 return;
                             }

                             if (!response) {
                                 root.error(qsTr("REGISTER_FAIL_GAMENET_UNAVAILABLE"));
                                 return;
                             }

                             var errorCode = response.code;

                             if (errorCode == -2) {//BLOCKED_AUTH
                                root.error(qsTr("AUTH_FAIL_ACCOUNT_BLOCKED"));
                                return;
                             }

                             var inputError = false;
                             if (response.message.login) {
                                 loginInput.errorMessage = response.message.login;
                                 loginInput.error = true;
                                 inputError = true;
                             }

                             if (response.message.password) {
                                 passwordInput.errorMessage = response.message.password;
                                 passwordInput.error = true;
                                 inputError = true;
                             }

                             if (!inputError) {
                                 root.error(response.message);
                             }

                         });
        }

        onInProgressChanged: SignalBus.setGlobalProgressVisible(d.inProgress, 0);
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

                Keys.onReturnPressed: d.confirmGuest();
                Keys.onEnterPressed: d.confirmGuest();
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
                onClicked: d.confirmGuest();
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
