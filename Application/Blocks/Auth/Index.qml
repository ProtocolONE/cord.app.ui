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

import "../../../Application/Core/Authorization.js" as Authorization
import "../../../Application/Core/User.js" as User
import "../../../Application/Core/App.js" as App

import "./AuthHelper.js" as AuthHelper

import "AnimatedBackground" as AnimatedBackground

Rectangle {
    id: root

    width: 1000
    height: 600

    color: "#FAFAFA"

    Component.onCompleted: {
        if (Settings.value("qml/auth/", "authDone", 0) == 0 && !App.isSilentMode()) {
            authContainer.state = "registration";
            return;
        }

        d.autoLogin();
    }

    QtObject {
        id: d

        function showError(message) {
            messageBody.backState = authContainer.state;
            messageBody.message = message;
            authContainer.state = "message";
        }

        function startVkAuth() {
            App.setGlobalProgressVisible(true);

            Authorization.loginByVk(root, function(error, response) {
                App.setGlobalProgressVisible(false);

                if (Authorization.isSuccess(error)) {
                    d.startLoadingServices(userId, appKey, cookie);
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

        function startLoadingServices(userId, appKey, cookie) {
            serviceLoading.userId = userId;
            serviceLoading.appKey = appKey;
            serviceLoading.cookie = cookie;

            authContainer.state = "serviceLoading";
        }

        function autoLogin() {
            if (AuthHelper.autoLoginDone) {
                authContainer.state = "auth";
                return;
            }

            AuthHelper.autoLoginDone = true;

            var savedAuth = CredentialStorage.load();
            if (!savedAuth || !savedAuth.userId || !savedAuth.appKey || !savedAuth.cookie) {
                var guest = CredentialStorage.loadGuest();

                if (!guest || !guest.userId || !guest.appKey || !guest.cookie) {
                    authContainer.state = "auth";

                    if (App.isSilentMode()) {
                        var auth = new Authorization.ProviderGuest(),
                            startingServiceId = App.startingService() || "0";

                        if (startingServiceId == "0") {
                            startingServiceId = Settings.value('qGNA', 'installWithService', "0");
                        }

                        auth.login(App.serviceItemByServiceId(startingServiceId).gameId, function(code, response) {
                            if (!Authorization.isSuccess(code)) {
                                // TODO ? Auth failed
                                return;
                            }

                            CredentialStorage.saveGuest(response.userId, response.appKey, response.cookie, true);
                            CredentialStorage.save(response.userId, response.appKey, response.cookie, true);
                            d.startLoadingServices(response.userId, response.appKey, response.cookie);
                        });

                        return;
                    }

                    return;
                }

                savedAuth = guest;
                CredentialStorage.save(guest.userId, guest.appKey, guest.cookie, true);
                savedAuth.guest = true;
            }

            var lastRefresh = Settings.value("qml/auth/", "refreshDate", -1);
            var currentDate = Math.floor(+new Date() / 1000);

            if (lastRefresh != -1 && (currentDate - lastRefresh < 432000)) {
                d.startLoadingServices(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
                return;
            }

            Authorization.refreshCookie(savedAuth.userId, savedAuth.appKey, function(error, response) {
               if (Authorization.isSuccess(error)) {
                   Settings.setValue("qml/auth/", "refreshDate", currentDate);
                   CredentialStorage.save(
                               savedAuth.userId,
                               savedAuth.appKey,
                               response.cookie,
                               false);
                   d.startLoadingServices(savedAuth.userId, savedAuth.appKey, response.cookie);
               } else {
                   d.startLoadingServices(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
               }
           })
        }
    }

    /*AnimatedBackground.Index {
        id: background

        function registerInfoValid() {
            var loginReg = /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,4})$/;
            return registration.password.length >= 6 && loginReg.test(registration.login);
        }

        anchors.fill: parent
        isDoggyVisible: footer.vkButtonContainsMouse
        goodSignActive: background.registerInfoValid();
    }*/

    Header {
        id: header

        anchors { left: parent.left; right: parent.right }
        visible: authContainer.state !== 'serviceLoading'
    }

    Item {
        id: authContainer

        anchors {
            left: parent.left
            leftMargin: 250
            right: parent.right
            rightMargin: 250
            top: header.bottom
            bottom: footer.top
        }

        Switcher {
            id: centralSwitcher

            anchors.fill: parent

            ServiceLoading {
                id: serviceLoading

                property string userId
                property string appKey
                property string cookie

                anchors.fill: parent

                onFinished: App.authDone(userId, appKey, cookie);
            }

            AuthBody {
                id: auth

                anchors.fill: parent
                onSwitchToRegistration: authContainer.state = "registration"
                onCodeRequired: {
                    codeForm.codeSended = false;
                    authContainer.state = "code"
                }
                onError: d.showError(message);

                onAuthDone: {
                    d.startLoadingServices(userId, appKey, cookie);

                    if (remember) {
                        CredentialStorage.save(userId, appKey, cookie, false);
                        d.saveAuthorizedLogins(auth.login);
                    } else {
                        auth.login = "";
                    }
                }

                loginSuggestion: d.loginSuggestion();
            }

            RegistrationBody {
                id: registration

                anchors.fill: parent
                onError: d.showError(message);
                onSwitchToLogin: {
                    authContainer.state = "auth"
                }

                onAuthDone: {
                    d.startLoadingServices(userId, appKey, cookie);

                    CredentialStorage.save(userId, appKey, cookie, false);
                    d.saveAuthorizedLogins(registration.login);
                }
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

        state: ""
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
            },
            State {
                name: "serviceLoading"

                StateChangeScript {
                    script: centralSwitcher.switchTo(serviceLoading);
                }
            }
        ]
    }

    Footer {
        id: footer

        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        onOpenVkAuth: d.startVkAuth();
        visible: authContainer.state !== 'serviceLoading'
    }

    Button {
        function loadGuest() {
            var guest = CredentialStorage.loadGuest();

            if (!guest || !guest.userId || !guest.appKey || !guest.cookie) {
                return;
            }

            d.startLoadingServices(guest.userId, guest.appKey, guest.cookie);
        }

        function isGuestExists() {
            var guest = CredentialStorage.loadGuest();

            if (!guest || !guest.userId || !guest.appKey || !guest.cookie) {
                return false;
            }

            return true;
        }

        width: 160
        height: 25

        visible: isGuestExists() && authContainer.state == "auth";

        anchors {
            bottom: parent.bottom
            bottomMargin: 20
            right: parent.right
            rightMargin: 320
        }

        text: qsTr("LOGIN_BY_GUEST_BUTTON_TEXT")
        onClicked: loadGuest();
    }

    Button {
        width: 32
        height: 146
        anchors { verticalCenter: parent.verticalCenter; right: parent.right }
        visible: authContainer.state !== 'serviceLoading'

        style: ButtonStyleColors {
            normal: "#ffae02"
            hover: "#ffcc02"
        }

        onClicked: {
            App.openExternalUrl("http://support.gamenet.ru");
        }

        Column {
            anchors.fill: parent

            Item {
                width: parent.width
                height: parent.height - width - 1

                Item {
                    anchors.centerIn: parent
                    rotation: -90
                    width: parent.height
                    height: parent.width

                    Text {
                        anchors.centerIn: parent
                        text: "Задать вопрос"
                        color: "#FFFFFF"
                        font {
                            family: "Arial"
                            pixelSize: 14
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#FFFFFF"
                opacity: 0.2
            }

            Item {
                width: parent.width
                height: width

                Image {
                    anchors.centerIn: parent
                    source: installPath + "Assets/Images/Auth/support.png"
                }
            }
        }
    }
}
