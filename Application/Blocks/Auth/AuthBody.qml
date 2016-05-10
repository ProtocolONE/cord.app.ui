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
import Application.Core.Authorization 1.0

import "./AuthBody.js" as AuthHelper

import "./Controls"
import "./Controls/Inputs"

Form {
    id: root

    property alias login: loginInput.text
    property alias password: passwordInput.text
    property alias loginSuggestion: loginSuggestion.dictionary
    property int loginMaxSize: 254
    property bool guestMode

    property alias inProgress: d.inProgress

    signal codeRequired();
    signal error(string message);
    signal authDone(string userId, string appKey, string cookie, bool remember);

    function showCaptcha() {
        d.captchaRequired = true;
        d.refreshCaptcha();
    }

    function setLogin(login) {
        root.login = login;
        loginInput.suggestionsVisible = false;
    }

    title: qsTr("AUTH_BODY_TITLE")
    subTitle: qsTr("AUTH_BODY_SUB_TITLE")

    footer {
        visible: true
        title: qsTr("AUTH_BODY_REGISTER_TEXT")
        text: qsTr("AUTH_BODY_REGISTER_BUTTON")
        guestMode: root.guestMode
    }

    Keys.onTabPressed: loginInput.forceActiveFocus()
    Component.onCompleted: loginInput.focus = true

    QtObject {
        id: d

        property bool captchaRequired: false

        property alias login: loginInput.text
        property alias password: passwordInput.text
        property alias captcha: captchInput.text
        property alias remember: rememberAuth.checked

        property bool inProgress: false

        function authSuccess(response) {
            d.captchaRequired = false;
            root.authDone(response.userId, response.appKey, response.cookie, d.remember);
        }

        function genericAuth() {
            if (d.inProgress || !App.authAccepted) {
                return;
            }

            if (d.login.length > root.loginMaxSize) {
                loginInput.errorMessage = qsTr("REGISTER_FAIL_LOGIN_TOO_LONG");
                loginInput.error = true;
                return;
            }

            d.inProgress = true;

            var password = d.password;
            d.password = "";
            root.focus = true;

            // UNDONE сбрасывать ли состояния ошибок.
//            passwordInput.error = false;
//            loginInput.error = false;
//            captchInput.error = false;

            if (d.captchaRequired) {
                Authorization.setCaptcha(d.captcha);
                d.captcha = "";
            }

            Authorization.loginByGameNet(d.login, password, function(error, response) {
                d.inProgress = false;


                if (Authorization.isSuccess(error)) {
                    d.authSuccess(response);
                    return;
                }

                if (error === Authorization.Result.CaptchaRequired) {
                    d.refreshCaptcha();
                    passwordInput.forceActiveFocus();
                    if (d.captchaRequired) {
                        captchInput.errorMessage = qsTr("AUTH_BODY_CAPTCHA_FAILED");
                        captchInput.error = true;
                        return;
                    }

                    d.captchaRequired = true;
                    return;
                }

                if (d.captchaRequired) {
                    d.refreshCaptcha();
                }

                if (error === Authorization.Result.CodeRequired) {
                    d.captchaRequired = false;
                    root.codeRequired();
                    return;
                }

                if (!response) {
                    root.error(qsTr("AUTH_FAIL_GAMENET_UNAVAILABLE"));
                    return;
                }

                if (response.code == RestApi.Error.INCORRECT_FORMAT_EMAIL) {
                    loginInput.errorMessage = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");
                    loginInput.error = true;
                    return;
                }

                if (response.code == RestApi.Error.ACCOUNT_NOT_EXISTS) {
                    loginInput.errorMessage = qsTr("AUTH_FAIL_MESSAGE_ACCOUNT_NOT_EXISTS");
                    loginInput.error = true;
                    return;
                }

                if (response.code == RestApi.Error.AUTHORIZATION_FAILED) {
                    passwordInput.errorMessage = qsTr("AUTH_FAIL_MESSAGE_WRONG");
                    passwordInput.error = true;
                    loginInput.errorMessage = "";
                    loginInput.error = true;
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

                root.error(errorMessage);
            });
        }

        function refreshCaptcha() {
            captchInput.source = Authorization.getCaptchaImageSource(d.login);
        }

        onInProgressChanged: SignalBus.setGlobalProgressVisible(d.inProgress, 0);
    }

    Column {
        width: parent.width
        spacing: 15

        Column {
            spacing: 24
            width: parent.width
            z: 1

            LoginInput {
                id: loginInput

                function nextBackTabItem() {
                    if (d.captchaRequired) {
                        captchInput.forceActiveFocus();
                    } else {
                        passwordInput.forceActiveFocus();
                    }
                }

                width: parent.width
                placeholder: qsTr("AUTH_BODY_LOGIN_PLACEHOLDER")

                onTabPressed: passwordInput.forceActiveFocus();
                onBackTabPressed: loginInput.nextBackTabItem();
                maximumLength: loginMaxSize + 1

                onTextChanged: {
                    if (loginInput.text.length > root.loginMaxSize) {
                      loginInput.errorMessage = qsTr("REGISTER_FAIL_LOGIN_TOO_LONG");
                      loginInput.error = true;
                    }

                    d.captchaRequired = false;
                }
                z: 1

                typeahead: TypeaheadBehaviour {
                    id: loginSuggestion

                    function sortFunction(a, b) {
                        return (b.data || 0) - (a.data || 0);
                    }
                }
            }

            PasswordInput {
                id: passwordInput

                function nextTabItem() {
                    if (d.captchaRequired) {
                        captchInput.forceActiveFocus();
                    } else {
                        loginInput.forceActiveFocus();
                    }
                }

                width: parent.width
                placeholder: qsTr("AUTH_BODY_PASSWORD_PLACEHOLDER")

                onTabPressed: passwordInput.nextTabItem();
                onBackTabPressed: loginInput.forceActiveFocus();

                Keys.onEnterPressed: d.genericAuth();
                Keys.onReturnPressed: d.genericAuth();

                TextButton {
                    anchors {
                        right: parent.right
                        bottom: parent.top
                        bottomMargin: 5
                    }
                    text: qsTr("AUTH_BODY_AMNESIA_TEXT")

                    analytics {
                        category: 'Auth'
                        action: 'outer link'
                        label: 'Restore password'
                    }
                    fontSize: 12
                    onClicked: App.openExternalUrl("https://gamenet.ru/restore/?login=" + d.login);
                }
            }

            CaptchaInput {
                id: captchInput

                visible: d.captchaRequired

                onTabPressed: loginInput.forceActiveFocus();
                onBackTabPressed: passwordInput.forceActiveFocus();
                Keys.onEnterPressed: d.genericAuth();
                Keys.onReturnPressed: d.genericAuth();
                onRefresh: d.refreshCaptcha();
            }
        }

        Item {
            width: parent.width
            height: 48

            CheckBox {
                id: rememberAuth

                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                checked: AuthHelper.rememberAccount != undefined ? AuthHelper.rememberAccount : true
                text: qsTr("AUTH_BODY_REMEMBER_TEXT")
                enabled: !d.inProgress
                onToggled: AuthHelper.rememberAccount = rememberAuth.checked;
            }

            PrimaryButton {
                width: 170
                height: parent.height
                anchors.right: parent.right
                text: qsTr("AUTH_BODY_LOGIN_BUTTON")
                font {family: "Open Sans Regular"; pixelSize: 15}
                inProgress: d.inProgress
                onClicked: d.genericAuth();
                analytics {
                   category: 'Auth'
                   label: 'Login button pressed'
                }
            }
        }
    }
}
