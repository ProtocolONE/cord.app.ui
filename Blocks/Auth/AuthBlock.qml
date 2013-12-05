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

import "./Auth" as Auth
import "../../Elements" as Elements
import "../../js/Authorization.js" as Authorization
import "../../js/GoogleAnalytics.js" as GoogleAnalytics
import "../../js/restapi.js" as RestApi

Item {
    id: authPage

    property int autoGuestLoginTimout: 10
    property bool codeRequired: false

    signal changeState(string state);

    function authCallback(error, response, shouldSave, guest) {
        authRegisterMoveUpPage.isInProgress = false;
        if (error === Authorization.Result.Success) {
            authPage.authSuccess(response.userId, response.appKey, response.cookie, shouldSave, guest);
        }
    }

    function authSuccess(userId, appKey, cookie, shouldSave, guest) {
        if (shouldSave || guest) {
            CredentialStorage.save(userId, appKey, cookie, guest);
        }

        loginForm.captchaRequired = false;
        authRegisterMoveUpPage.isInProgress = false;
        authRegisterMoveUpPage.authedAsGuest = guest;
        authRegisterMoveUpPage.switchAnimation();
        authRegisterMoveUpPage.authDoneCallback(userId, appKey, cookie);

        if (loginForm.rememberChecked) {
            saveAuthorizedLogins();
        } else {
            loginForm.clearLogin();
        }
    }

    function saveAuthorizedLogins() {
        var login = loginForm.login,
            currentValue = JSON.parse(Settings.value("qml/auth/", "authedLogins", "{}"));

        currentValue[login] = +new Date();
        Settings.setValue("qml/auth/" , "authedLogins", JSON.stringify(currentValue));
    }

    function startGuestAutoStart() {
        if (authRegisterMoveUpPage.isAuthed)
            return;

        if (authRegisterMoveUpPage.guestAuthEnabled && authRegisterMoveUpPage.selectedGame) {
            authRegisterMoveUpPage.guestAuthTimerStarted = true;
            authPage.autoGuestLoginTimout = 10;
            guestAutoStartTimer.start();
        }
    }

    function stopGuestAutoStart() {
        authRegisterMoveUpPage.guestAuthTimerStarted = false;
        authPage.autoGuestLoginTimout = 10;
        guestAutoStartTimer.stop();
    }

    // Login/Password auth
    function startGenericAuth(login, password, captcha) {
        authRegisterMoveUpPage.isInProgress = true;
        stopGuestAutoStart();

        if (captcha) {
            Authorization.setCaptcha(captcha);
        }

        Authorization.loginByGameNet(login, password, function(error, response) {
            authPage.authCallback(error, response, loginForm.rememberChecked, false);

            if (error === Authorization.Result.Success) {
                return;
            }

            if (error === Authorization.Result.CaptchaRequired) {
                loginForm.captchaRequired = true;
                return;
            }

            if (error === Authorization.Result.CodeRequired) {
                loginForm.captchaRequired = false;
                authPage.codeRequired = true;
                return;
            }

            authRegisterMoveUpPage.state = "FailAuthPage";



            var msg = {
                0: qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR"),
            };

            msg[RestApi.Error.AUTHORIZATION_FAILED] = qsTr("AUTH_FAIL_MESSAGE_WRONG");
            msg[RestApi.Error.INCORRECT_FORMAT_EMAIL] = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");
            msg[Authorization.Result.ServiceAccountBlocked] = qsTr("AUTH_FAIL_ACCOUNT_BLOCKED");
            msg[Authorization.Result.WrongLoginOrPassword] = qsTr("AUTH_FAIL_MESSAGE_WRONG");

            if (msg[error]) {
                failPage.errorMessage = msg[error];
                return;
            }

            failPage.errorMessage = response ? (msg[response.code] || msg[0]) : msg[0];
        });
    }

    function startGuestAuth() {
        authRegisterMoveUpPage.isInProgress = true;
        stopGuestAutoStart();
        Marketing.send(Marketing.GuestAccountRequest, "0", {});

        var gameId,
            auth = new Authorization.ProviderGuest();

        if (selectedGame && selectedGame.serviceId)
            gameId = selectedGame.serviceId;

        auth.login(gameId, function(error, response) {
            authPage.authCallback(error, response, true, true);
            if (error !== Authorization.Result.Success) {
                authRegisterMoveUpPage.state = "FailAuthPage";
                failPage.errorMessage = qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_GUEST_ERROR");
            }
        });
    }

    function startVkAuth() {
        stopGuestAutoStart();

        authRegisterMoveUpPage.isInProgress = true;

        Authorization.loginByVk(authPage, function(error, response) {
            authPage.authCallback(error, response, true, false);

            if (error === Authorization.Result.Cancel) {
                return;
            }

            if (error === Authorization.Result.ServiceAccountBlocked) {
                authRegisterMoveUpPage.state = "FailAuthPage";
                failPage.errorMessage = qsTr("AUTH_FAIL_ACCOUNT_BLOCKED");
                return;
            }

            if (error !== Authorization.Result.Success) {
                authRegisterMoveUpPage.state = "FailAuthPage";
                failPage.errorMessage = qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_VK_ERROR");
            }
        });
    }

    function increaseGuestRecoveryCounter() {
        var currentValue = Settings.value("qml/auth/", 'GuestRecoveryCount', '0');
        currentValue = parseInt(currentValue, 10);
        currentValue++;
        Settings.setValue("qml/auth/", 'GuestRecoveryCount', currentValue.toString());
    }

    function guestRecoveryCounter() {
        return Settings.value("qml/auth/", 'GuestRecoveryCount', '0');
    }

    Timer {
        id: guestAutoStartTimer

        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            if (authPage.autoGuestLoginTimout > 0) {
                authPage.autoGuestLoginTimout--;
                return;
            }

            authPage.stopGuestAutoStart()
            authPage.startGuestAuth();
        }
    }

    Item {
        anchors { fill: parent; topMargin: 47 }
        width: parent.width
        height: openHeight

        Elements.Button {
            anchors { top: parent.top; right: parent.right; rightMargin: 62; topMargin: 30 }
            analitics: ['/Auth', 'Auth', 'Vk Login']
            text: qsTr("VK_LOGIN_BUTTON_TEXT")

            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: installPath + "images/button_vk.png"
            }

            onClicked: authPage.startVkAuth();
        }

        Column {
            anchors { fill: parent; topMargin: 30 }
            spacing: 30

            Row {
                anchors { left: parent.left; leftMargin: 30 }
                width: parent.width
                visible: authPage.codeRequired

                LabelText {
                    text: qsTr("AUTH_LEFT_LABEL_CODE_REQUIRED")
                }

                Auth.CodeForm {
                    login: loginForm.login
                    onCancel: {
                        authPage.codeRequired = false
                        authRegisterMoveUpPage.state = "AuthPage"
                    }
                    onShowProgress: isInProgress = show;
                    onUnblocked: authPage.codeRequired = false
                }
            }

            Row {
                anchors { left: parent.left; leftMargin: 30 }
                width: parent.width
                visible: !authPage.codeRequired

                LabelText {
                    text: qsTr("REGISTRATION_LEFT_LABEL_TEXT")
                }

                Auth.LoginForm {
                    id: loginForm

                    function stopGuestAutoStart() {
                        if (authRegisterMoveUpPage.guestAuthEnabled) {
                            authPage.stopGuestAutoStart();
                        }
                    }

                    width: parent.width
                    onLoginMe: authPage.startGenericAuth(login, password, captcha);
                    onCancel: {
                        loginForm.captchaRequired = false;
                        authRegisterMoveUpPage.state = "AuthPage";
                    }
                    onLoginChanged: stopGuestAutoStart()
                    onPasswordChanged: stopGuestAutoStart()
                }
            }

            Auth.Footer {
                width: parent.width
                onClicked: {
                    authPage.stopGuestAutoStart();
                    registrationPage.state = "Normal"
                    authRegisterMoveUpPage.state = "RegistrationPage";
                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Switch To Registration');
                }
            }
        }
    }
}
