/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Blocks.Auth 1.0
import Application.Blocks.Popup 1.0

import "../../../Core/Authorization.js" as Authorization
import "../../../Core/App.js" as App
import "../../../Core/Styles.js" as Styles
import "../../../Core/User.js" as User

PopupBase {
    id: root

    title: qsTr("SECOND_ACCOUNT_ACTIVATION_TITLE")

    defaultTitleColor: Styles.style.popupText

    QtObject {
        id: d

        property string savePrefix: "second_"
        property bool vkAuthInProgress: false

        function startVkAuth() {
            App.setGlobalProgressVisible(true);
            d.vkAuthInProgress = true;

            Authorization.loginByVk(root, function(error, response) {
                App.setGlobalProgressVisible(false);
                d.vkAuthInProgress = false;

                if (Authorization.isSuccess(error)) {
                    d.authSuccess(response.userId, response.appKey, response.cookie, true);
                    return;
                }

                if (error === Authorization.Result.Cancel) {
                    return;
                }

                if (error === Authorization.Result.ServiceAccountBlocked) {
                    d.showError(qsTr("AUTH_FAIL_ACCOUNT_BLOCKED"));
                    return;
                }

                d.showError(qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_VK_ERROR"));
            });
        }

        function loginSuggestion() {
            var logins = {};
            try {
                logins = JSON.parse(Settings.value("qml/auth/", "authedLogins", "{}"));
            } catch (e) {
            }

            return logins;
        }

        function saveAuthorizedLogins(login) {
            var currentValue = d.loginSuggestion();
            currentValue[login] = +new Date();
            Settings.setValue("qml/auth/" , "authedLogins", JSON.stringify(currentValue));
            auth.loginSuggestion = currentValue;
        }

        function authSuccess(userId, appKey, cookie, remember, login) {
            if (userId != User.userId()) {
                if (remember) {
                    CredentialStorage.saveEx(d.savePrefix, userId, appKey, cookie, false);
                    if (login) {
                        d.saveAuthorizedLogins(login);
                    }
                }

                App.secondAuthDone(userId, appKey, cookie);
            }

            root.close();
        }
    }

    Column {
        id: formContainer

        anchors {
            left: parent.left
            right: parent.right
        }

        AuthBody {
            id: auth

            visible: false
            onFooterPrimaryButtonClicked:  root.state = "registration"
            onCodeRequired: {
                codeForm.codeSended = false;
                root.state = "code"
            }
            onError: d.showError(message);
            loginSuggestion: d.loginSuggestion();

            onAuthDone: {
                d.authSuccess(userId, appKey, cookie, remember, auth.login);
                if (!remember) {
                    auth.login = "";
                }
            }
            vkButtonInProgress: d.vkAuthInProgress
            onFooterVkClicked: d.startVkAuth();
        }

        RegistrationBody {
            id: registration

            visible: false
            onFooterPrimaryButtonClicked:  root.state = "auth"
            onError: d.showError(message);
            onAuthDone: d.authSuccess(userId, appKey, cookie, true, registration.login);
            vkButtonInProgress: d.vkAuthInProgress
            onFooterVkClicked: d.startVkAuth();
        }

        CodeBody {
            id: codeForm

            visible: false
            login: auth.login
            onCancel: root.state = "auth"
            onSuccess: root.state = "auth"
            vkButtonInProgress: d.vkAuthInProgress
            onFooterVkClicked: d.startVkAuth();
        }

        MessageBody {
            id: messageBody

            property string backState

            visible: false
            onClicked: root.state = messageBody.backState;
        }
    }

    state: "auth"
    states: [
        State {
            name :"Initial"
            PropertyChanges {target: auth; visible: false}
            PropertyChanges {target: registration; visible: false}
            PropertyChanges {target: codeForm; visible: false}
            PropertyChanges {target: messageBody; visible: false}
        },
        State {
            name: "auth"
            extend: "Initial"
            PropertyChanges {target: auth; visible: true}
            StateChangeScript {
                script: auth.forceActiveFocus();
            }
        },
        State {
            name: "registration"
            extend: "Initial"
            PropertyChanges {target: registration; visible: true}
            StateChangeScript {
                script: registration.forceActiveFocus();
            }
        },
        State {
            name: "code"
            extend: "Initial"
            PropertyChanges {target: codeForm; visible: true}
        },
        State {
            name: "message"
            extend: "Initial"
            PropertyChanges {target: messageBody; visible: true}
        }
    ]
}
