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
import "../../../Core/User.js" as User

PopupBase {
    id: root

    title: qsTr("SECOND_ACCOUNT_ACTIVATION_TITLE")
    implicitWidth: 540

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

    Item {
        width: root.width
        height: 433

        Item {
            id: authContainer

            anchors {
                fill: parent
                leftMargin: 20
                rightMargin: 20
                topMargin: -20
            }

            Switcher {
                id: centralSwitcher

                anchors.fill: parent

                AuthBody {
                    id: auth

                    anchors.fill: parent
                    onSwitchToRegistration: authContainer.state = "registration"
                    onCodeRequired: {
                        codeForm.codeSended = false;
                        authContainer.state = "code"
                    }
                    onError: d.showError(message);
                    loginSuggestion: d.loginSuggestion();

                    onAuthDone: {
                        d.authSuccess(userId, appKey, cookie, remember, auth.login);
                        if (!remember) {
                            auth.login = "";
                        }
                    }
                }

                RegistrationBody {
                    id: registration

                    width: parent.width
                    height: 330
                    onSwitchToLogin: authContainer.state = "auth"
                    onError: d.showError(message);
                    onAuthDone: d.authSuccess(userId, appKey, cookie, true, registration.login);
                }

                CodeBody {
                    id: codeForm

                    anchors.fill: parent
                    login: auth.login
                    onCancel: authContainer.state = "auth"
                    onSuccess: authContainer.state = "auth"
                }

                MessageBody {
                    id: messageBody

                    property string backState

                    anchors.fill: parent
                    onClicked: authContainer.state = messageBody.backState;
                }
            }

            Footer {
                id: footer

                anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                vkButtonInProgress: d.vkAuthInProgress
                onOpenVkAuth: d.startVkAuth();
            }

            state: "auth"
            states: [
                State {
                    name: "auth"

                    StateChangeScript {
                        script: centralSwitcher.switchTo(auth);
                    }
                },
                State {
                    name: "registration"

                    StateChangeScript {
                        script: centralSwitcher.switchTo(registration);
                    }
                },
                State {
                    name: "code"

                    StateChangeScript {
                        script: centralSwitcher.switchTo(codeForm);
                    }
                },
                State {
                    name: "message"

                    StateChangeScript {
                        script: centralSwitcher.switchTo(messageBody);
                    }
                }
            ]
        }
    }
}
