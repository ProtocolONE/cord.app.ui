import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Controls 1.0
import ProtocolOne.Core 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Authorization 1.0
import Application.Core.Config 1.0

import "./AuthBody.js" as AuthHelper

import "./Controls"
import "./Controls/Inputs"

Form {
    id: root

    property alias login: loginInput.text
    property alias password: passwordInput.text
    property alias captcha: captchInput.text
    property alias remember: rememberAuth.checked
    property string authToken
    property string userId
    property alias loginSuggestion: loginSuggestion.dictionary
    property int loginMaxSize: 254

    property alias inProgress: d.inProgress

    signal error(string message, bool supportButton);

    signal jwtAuthDone(string refreshToken, string refreshTokenExpireTime,
                       string accessToken, string accessTokenExpireTime);

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
            root.jwtAuthDone(response.refreshToken.value,
                             response.refreshToken.exp,
                             response.accessToken.value,
                             response.accessToken.exp);
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
            var captcha = d.captcha;
            d.password = "";
            d.captcha = "";
            root.focus = true;

            Authorization.login(d.login, password, captcha, function(error, response) {
                d.inProgress = false;
                if (error === Authorization.Result.Success) {
                   d.authSuccess(response);
                   return;
                }

                if (error === Authorization.Result.CaptchaRequired) {
                    d.refreshCaptcha();

                    if (d.captchaRequired) {
                        passwordInput.forceActiveFocus();
                        captchInput.errorMessage = qsTr("AUTH_BODY_CAPTCHA_FAILED");
                        captchInput.error = true;
                        return;
                    }

                    captchInput.forceActiveFocus();
                    d.password = password;
                    d.captchaRequired = true;
                    return;
                }

                if (d.captchaRequired) {
                    d.refreshCaptcha();
                }


                if (error === Authorization.Result.InvalidUserNameOrPassword) {
                    if (response.hasOwnProperty('email')) {
                        loginInput.errorMessage = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");
                        loginInput.error = true;
                    }

                    if (response.hasOwnProperty('password')) {
                        passwordInput.errorMessage = qsTr("AUTH_FAIL_MESSAGE_WRONG");
                        passwordInput.error = true;
                    }

                    return;
                }

                root.error(qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR"), false);
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
                    onClicked: App.openExternalUrl(Config.site("/restore/?login=") + d.login);
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
                checked: AuthHelper.rememberAccount !== undefined ? AuthHelper.rememberAccount : true
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
