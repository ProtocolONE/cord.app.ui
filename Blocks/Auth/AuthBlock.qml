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

    implicitHeight: 464
    implicitWidth: 930

    property bool codeRequired: false
    property bool isInProgress: false

    signal cancel();
    signal error(string message);
    signal openRegistration();
    signal authSuccess(string userId, string appKey, string cookie, bool shouldSave);
    signal saveLogin(string login);

    function authCallback(error, response, shouldSave) {
        authPage.isInProgress = false;

        if (error === Authorization.Result.Success) {
            loginForm.captchaRequired = false;
            authPage.authSuccess(response.userId, response.appKey, response.cookie, shouldSave);
        }
    }

    // Login/Password auth
    function startGenericAuth(login, password, captcha) {
        authPage.isInProgress = true;

        if (captcha) {
            Authorization.setCaptcha(captcha);
        }

        Authorization.loginByGameNet(login, password, function(error, response) {
            authPage.authCallback(error, response, loginForm.rememberChecked);

            if (error === Authorization.Result.Success) {
                if (loginForm.rememberChecked) {
                    authPage.saveLogin(loginForm.login)
                } else {
                    loginForm.clearLogin();
                }

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

            var msg = {
                0: qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR"),
            };

            msg[RestApi.Error.AUTHORIZATION_FAILED] = qsTr("AUTH_FAIL_MESSAGE_WRONG");
            msg[RestApi.Error.INCORRECT_FORMAT_EMAIL] = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");
            msg[Authorization.Result.ServiceAccountBlocked] = qsTr("AUTH_FAIL_ACCOUNT_BLOCKED");
            msg[Authorization.Result.WrongLoginOrPassword] = qsTr("AUTH_FAIL_MESSAGE_WRONG");

            var errorMessage;
            if (msg[error]) {
                errorMessage = msg[error];
            } else {
                errorMessage = response ? (msg[response.code] || msg[0]) : msg[0];
            }

            authPage.error(errorMessage);
        });
    }

    function startVkAuth() {
        authPage.isInProgress = true;

        Authorization.loginByVk(authPage, function(error, response) {
            authPage.authCallback(error, response, true);

            if (error === Authorization.Result.Cancel) {
                return;
            }

            if (error === Authorization.Result.ServiceAccountBlocked) {
                authPage.error(qsTr("AUTH_FAIL_ACCOUNT_BLOCKED"));
                return;
            }

            if (error !== Authorization.Result.Success) {
                authPage.error(qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_VK_ERROR"));
            }
        });
    }

    Item {
        anchors { fill: parent; topMargin: 47 }

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
                        authPage.cancel();
                    }
                    onShowProgress: authPage.isInProgress = show;
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

                    width: parent.width
                    onLoginMe: authPage.startGenericAuth(login, password, captcha);
                    onCancel: {
                        loginForm.captchaRequired = false;
                        authPage.cancel();
                    }
                }
            }

            Auth.Footer {
                width: parent.width
                onClicked: {
                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Switch To Registration');
                    authPage.openRegistration();
                }
            }
        }
    }
}
