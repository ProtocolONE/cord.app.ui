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
import "../../../js/Authorization.js" as Authorization
import "../../../js/restapi.js" as RestApi
import "../../../js/Core.js" as Core

import "../../../Application/Core/App.js" as AppProxy

Item {
    id: root

    property alias login: loginInput.text
    property alias loginSuggestion: loginSuggestion.dictionary

    signal switchToRegistration();
    signal codeRequired();
    signal error(string message);
    signal authDone(string userId, string appKey, string cookie, bool remember);

    implicitHeight: 473
    implicitWidth: 500

    QtObject {
        id: d

        property bool captchaRequired: false

        property alias login: loginInput.text
        property alias password: passwordInput.text
        property alias captcha: captchInput.text
        property alias remember: rememberAuth.checked

        function authSuccess(response) {
            d.captchaRequired = false;
            root.authDone(response.userId, response.appKey, response.cookie, d.remember);
        }

        function genericAuth() {
            Core.setGlobalProgressVisible(true);

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
                Core.setGlobalProgressVisible(false);

                if (Authorization.isSuccess(error)) {
                    d.authSuccess(response);
                    return;
                }

                if (error === Authorization.Result.CaptchaRequired) {
                    d.refreshCaptcha();
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

                if (response.code == RestApi.Error.INCORRECT_FORMAT_EMAIL) {
                    loginInput.errorMessage = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");
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

    }

    Column {
        anchors.fill: parent
        spacing: 20

        Item {
            width: parent.width
            height: 45

            Text {
                text: qsTr("AUTH_BODY_TITLE")
                font { family: "Arial"; pixelSize: 20 }
                color: "#363636"
                anchors { baseline: parent.top; baselineOffset: 35 }
            }
        }

        LoginInput {
            id: loginInput

            function nextBackTabItem() {
                if (d.captchaRequired) {
                    captchInput.focus = true;
                } else {
                    passwordInput.focus = true;
                }
            }

            width: parent.width
            placeholder: qsTr("AUTH_BODY_LOGIN_PLACEHOLDER")

            Keys.onTabPressed: passwordInput.focus = true;
            Keys.onBacktabPressed: nextBackTabItem();

            onTextChanged: d.captchaRequired = false;
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
                    captchInput.focus = true;
                } else {
                    loginInput.focus = true;
                }
            }

            width: parent.width
            placeholder: qsTr("AUTH_BODY_PASSWORD_PLACEHOLDER")

            Keys.onTabPressed: nextTabItem();
            Keys.onBacktabPressed: loginInput.focus = true;
            Keys.onEnterPressed: d.genericAuth();
            Keys.onReturnPressed: d.genericAuth();
        }

        CaptchaInput {
            id: captchInput

            visible: d.captchaRequired

            Keys.onTabPressed: loginInput.focus = true;
            Keys.onBacktabPressed: passwordInput.focus = true;
            Keys.onEnterPressed: d.genericAuth();
            Keys.onReturnPressed: d.genericAuth();

            onRefresh: d.refreshCaptcha();
        }

        Row {
            width: parent.width
            height: 16
            spacing: 20

            CheckBox {
                id: rememberAuth

                height: parent.height
                checked: true
                text: qsTr("AUTH_BODY_REMEMBER_TEXT")
                //toolTip: qsTr("AUTH_BODY_REMEMBER_TOOLTIP")
                fontSize: 14
                style: ButtonStyleColors {
                    normal: "#1ADC9C"
                    hover: "#019074"
                    disabled: "#1ADC9C"
                }
            }

            TextButton {
                anchors { baseline: parent.bottom; baselineOffset: -2 }
                height: parent.height
                text: qsTr("AUTH_BODY_AMNESIA_TEXT")

                fontSize: 14
                style: ButtonStyleColors {
                    normal: "#3498db"
                    hover: "#3670DC"
                    disabled: "#3498db"
                }

                onClicked: AppProxy.openExternalUrl("http://gamenet.ru/restore/?login=" + d.login);
            }
        }

        Row {
            width: parent.width
            height: 48
            spacing: 30

            Button {
                width: 200
                height: parent.height
                text: qsTr("AUTH_BODY_LOGIN_BUTTON")
                onClicked: d.genericAuth();
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
                    text: qsTr("AUTH_BODY_REGISTER_TEXT")
                    font { family: "Arial"; pixelSize: 12 }
                }

                TextButton {
                    anchors { baseline: parent.bottom; baselineOffset: -21 }
                    height: parent.height
                    text: qsTr("AUTH_BODY_REGISTER_BUTTON")
                    style: ButtonStyleColors {
                        normal: "#3498db"
                        hover: "#3670DC"
                        disabled: "#3498db"
                    }

                    onClicked: root.switchToRegistration();
                    fontSize: 12
                }
            }
        }
    }
}
