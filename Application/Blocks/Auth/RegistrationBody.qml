import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Core 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Authorization 1.0
import Application.Core.Config 1.0

import "./Controls"
import "./Controls/Inputs"

Form {
    id: root

    property alias login: loginInput.text
    property alias password: passwordInput.text
    property string authToken
    property string userId
    property int loginMaxSize: 254

    property alias inProgress: d.inProgress

    signal error(string message, bool supportButton);
    signal jwtAuthDone(string refreshToken, string refreshTokenExpireTime,
                       string accessToken, string accessTokenExpireTime);

    title: qsTr("REGISTER_BODY_TITLE")
    subTitle: qsTr("REGISTER_BODY_SUB_TITLE")

    footer {
        visible: true
        title: qsTr("REGISTER_BODY_AUTH_TEXT")
        text: qsTr("REGISTER_BODY_AUTH_BUTTON")
    }

    Keys.onTabPressed: loginInput.forceActiveFocus()
    Component.onCompleted: loginInput.focus = true

    QtObject {
        id: d

        property alias login: loginInput.text
        property alias password: passwordInput.text

        property bool inProgress: false

        function register() {
            var login = d.login,
                password = d.password;

            if (d.inProgress) {
                return;
            }

            if (login.length > root.loginMaxSize) {
                loginInput.errorMessage = qsTr("REGISTER_FAIL_LOGIN_TOO_LONG");
                loginInput.error = true;
                return;
            }

            d.password = "";
            d.inProgress = true;

            Authorization.registerUser(login, password, function(error, response) {
                d.inProgress = false;
                console.log('[Register] code: ', error)
                if (error === Authorization.Result.Success) {
                    root.jwtAuthDone(response.refreshToken.value,
                                     response.refreshToken.exp,
                                     response.accessToken.value,
                                     response.accessToken.exp);
                   return;
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

                root.error(qsTr("REGISTER_FAIL_PROTOCOLONE_UNAVAILABLE"), false);
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

                Keys.onReturnPressed: d.register();
                Keys.onEnterPressed: d.register();
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
                onClicked: d.register();
                font {family: "Open Sans Regular"; pixelSize: 15}
                analytics {
                   category: 'Auth Registration'
                   action: 'submit'
                   label: 'Register'
                }
            }

            LicenseText {
                anchors.right: parent.right
                onClicked: App.openExternalUrl(Config.site("/license"));
            }
        }
    }
}
