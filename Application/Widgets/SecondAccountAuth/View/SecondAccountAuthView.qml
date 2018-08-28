import QtQuick 2.4
import Tulip 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Blocks.Auth 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.Authorization 1.0
import Application.Core.Settings 1.0
import Application.Core.MessageBox 1.0

PopupBase {
    id: root

    title: qsTr("SECOND_ACCOUNT_ACTIVATION_TITLE")

    defaultTitleColor: Styles.popupText
    defaultSpacing: 0
    defaultImplicitHeightAddition: 10

    QtObject {
        id: d

        property string savePrefix: "second_"
        property bool vkAuthInProgress: false

        function showError(message, supportButton) {

            MessageBox.show(qsTr("INFO_CAPTION"), message,
                MessageBox.button.ok | (supportButton ? MessageBox.button.support : 0),
                function(result) {
                    if (result === MessageBox.button.support) {
                        App.openExternalUrl("https://support.gamenet.ru");
                    }});
        }

        function startOAuth(network) {
            var authFunction, gaMarker;

            switch(network) {
            case 'ok': {
                authFunction = Authorization.loginByOk;
                gaMarker = 'Ok Login'
                break;
                }
            case 'vk': {
                authFunction = Authorization.loginByVk;
                gaMarker = 'Vk Login'
                break;
                }
            case 'fb': {
                authFunction = Authorization.loginByFb;
                gaMarker = 'Fb Login'
                break;
                }
            default: {
                console.log("Warning. Unknown social network", network);
                return;
            }
            }

            SignalBus.setGlobalProgressVisible(true, 0);
            d.vkAuthInProgress = true;

            function oAuthResultCallback(error, response) {
                            SignalBus.setGlobalProgressVisible(false, 0);
                            d.vkAuthInProgress = false;

                            if (Authorization.isSuccess(error)) {
                                d.authSuccess(response.userId, response.appKey, response.cookie, true);
                                return;
                            }

                            if (error === Authorization.Result.Cancel) {
                                return;
                            }

                            if (error === Authorization.Result.ServiceAccountBlocked) {
                                d.showError(qsTr("AUTH_FAIL_ACCOUNT_BLOCKED"), true);
                                return;
                            }

                            d.showError(qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_VK_ERROR"));
                        }

            authFunction(root, oAuthResultCallback);
            Ga.trackEvent('SecondAuth', 'click', gaMarker)
        }

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

                SignalBus.secondAuthDone(userId, appKey, cookie);
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

            onSecurityCodeRequired: {
                authSecurityCodeBody.appCode = appCode;
                authSecurityCodeBody.login = auth.login;
                authSecurityCodeBody.password = auth.password;
                authSecurityCodeBody.captcha = auth.captcha;
                authSecurityCodeBody.remember = auth.remember;
                authSecurityCodeBody.authToken = auth.authToken;
                authSecurityCodeBody.userId = auth.userId;
                auth.password = "";
                root.state = "securityCode";
            }

            onCodeRequired: {
                codeForm.codeSended = false;
                root.state = "code"
            }
            onError: d.showError(message, supportButton);
            loginSuggestion: d.loginSuggestion();

            onAuthDone: {
                d.authSuccess(userId, appKey, cookie, remember, auth.login);
                if (!remember) {
                    auth.login = "";
                }
            }
            vkButtonInProgress: d.vkAuthInProgress
            onFooterOAuthClicked: d.startOAuth(network);
        }

        RegistrationBody {
            id: registration

            visible: false
            onFooterPrimaryButtonClicked:  root.state = "auth"
            onError: d.showError(message, supportButton);
            onAuthDone: d.authSuccess(userId, appKey, cookie, true, registration.login);
            vkButtonInProgress: d.vkAuthInProgress
            onFooterOAuthClicked: d.startOAuth(network);

            onCaptchaRequired: {
                auth.setLogin(registration.login);
                registration.password = "";
                root.state = "auth";
                auth.showCaptcha();
            }

            onCodeRequired: {
                auth.setLogin(registration.login);
                registration.login = "";
                codeForm.codeSended = false;
                root.state = "code"
            }
        }

        AuthSecurityCodeBody {
            id: authSecurityCodeBody

            visible: false

            onCancel: {
                root.state = "auth";
            }
            onError: {
                root.state = "auth";
                d.showError(message);
            }
            onAuthDone: {
                d.authSuccess(userId, appKey, cookie, remember, auth.login);
                if (!remember) {
                    auth.login = "";
                }
            }
        }

        CodeBody {
            id: codeForm

            visible: false
            login: auth.login
            onCancel: root.state = "auth"
            onSuccess: root.state = "auth"
            vkButtonInProgress: d.vkAuthInProgress
            onFooterOAuthClicked: d.startOAuth(network);
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
            PropertyChanges {target: authSecurityCodeBody; visible: false}
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
            name: "securityCode"
            extend: "Initial"
            PropertyChanges {target: authSecurityCodeBody; visible: true}
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
