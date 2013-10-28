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

import "../../Elements" as Elements
import "../../js/Authorization.js" as Authorization
import "../../js/GoogleAnalytics.js" as GoogleAnalytics
import "../../js/restapi.js" as RestApi

Item {
    id: registrationPage

    function startRegister() {
        authRegisterMoveUpPage.isInProgress = true;
        var login = registerLoginTextInput.editText,
            password = registerPasswordTextInput.editText;

        registerPasswordTextInput.clear();
        Authorization.register(login, password, function(error, response) {
            if (error === Authorization.Result.Success) {
                registerLoginTextInput.clear();
                Authorization.loginByGameNet(login, password, function(error, response) {
                    authPage.authCallback(error, response, true, false);
                    if (error !== Authorization.Result.Success) {
                        authRegisterMoveUpPage.state = "FailRegistrationPage";
                        if (!response) {
                            failPage.errorMessage = qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR");
                            return;
                        }

                        var map = {
                            0: qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR"),
                        };
                        map[RestApi.Error.AUTHORIZATION_FAILED] = qsTr("AUTH_FAIL_MESSAGE_WRONG");
                        map[RestApi.Error.INCORRECT_FORMAT_EMAIL] = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");

                        failPage.errorMessage = map[response.code] || map[0];
                    }
                });
                return;
            }

            authRegisterMoveUpPage.isInProgress = false;
            authRegisterMoveUpPage.state = "FailRegistrationPage";

            if (response.message.login) {
                registerLoginTextInput.failState = true;
            }

            if (response.message.password) {
                registerPasswordTextInput.failState = true;
            }

            failPage.errorMessage =
                (response.message.login ? response.message.login + "<br/>" : "") +
                (response.message.password || "");
        });
    }

    function registerButtonClicked() {
        if (registrationPage.state === "Normal" || !authRegisterMoveUpPage.isAuthed) {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Registration');
            registrationPage.startRegister();
        } else {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state,
                                       'Auth', 'Registration Confirm Guest');
            authRegisterMoveUpPage.isInProgress = true;

            var provider = new Authorization.ProviderGuest(),
                    login = registerLoginTextInput.editText,
                    password = registerPasswordTextInput.editText;
            registerPasswordTextInput.clear();

            provider.confirm(authRegisterMoveUpPage.userId,
                             authRegisterMoveUpPage.appKey,
                             login,
                             password,
                             function(error, response) {
                                 authRegisterMoveUpPage.isInProgress = false;
                                 if (error !== Authorization.Result.Success) {
                                     authRegisterMoveUpPage.state = "FailRegistrationPage";
                                     if (!response || !response.message) {
                                         failPage.errorMessage = qsTr("LINK_GUEST_UNKNOWN_ERROR");
                                         return;
                                     }

                                     failPage.errorMessage = response.message;
                                     return;
                                 }

                                 Marketing.send(Marketing.GuestAccountConfirm, "0",
                                                {
                                                    method: "Generic",
                                                    recoveryCount: authPage.guestRecoveryCounter()
                                                });
                                 authPage.authSuccess(response.userId,
                                                      response.appKey,
                                                      response.cookie,
                                                      true, false);
                                 authRegisterMoveUpPage.linkGuestDone();
                                 return;

                             });
        }
    }

    function bottomLeftButtonClicked() {
        if (registrationPage.state === "ForceOnLogout") {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Guest Logout');
            resetCredential();
            logoutDone();
            switchAnimation();
        } else if (registrationPage.state === "ForceOnStartGame"
                   || registrationPage.state === "ForceOnOpenWeb"
                   || registrationPage.state === "ForceOnRequest") {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Guest Confirm Cancel');
            authRegisterMoveUpPage.linkGuestCanceled();
            authRegisterMoveUpPage.switchAnimation();
        } else {
            authRegisterMoveUpPage.state = "AuthPage";
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Switch To Auth');
        }
    }

    function bottomRightButtonClicked() {
        if (registrationPage.state === "Normal") {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Vk Login');
            authPage.startVkAuth();
        } else {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Guest Vk Confirm');
            authRegisterMoveUpPage.isInProgress = true;
            Authorization.linkVkAccount(registerPageRightButton, function(error, message) {
                authRegisterMoveUpPage.isInProgress = false;

                if (error === Authorization.Result.Success) {
                    Marketing.send(Marketing.GuestAccountConfirm, "0",
                                   {
                                       method: "VK",
                                       recoveryCount: authPage.guestRecoveryCounter()
                                   });
                    authPage.authSuccess(authRegisterMoveUpPage.userId,
                                         authRegisterMoveUpPage.appKey,
                                         authRegisterMoveUpPage.cookie,
                                         true, false);
                    authRegisterMoveUpPage.linkGuestDone();
                    return;
                }

                authRegisterMoveUpPage.state = "FailRegistrationPage";

                failPage.errorMessage = message || qsTr("GUEST_VK_LINK_UNKNOWN_ERROR");
                authRegisterMoveUpPage.linkGuestCanceled();
            });
        }
    }

    state: "ForceOnLogout"

    Grid {
        anchors { fill: parent; topMargin: 47 }
        columns: 2

        Item {
            width: parent.width
            height: parent.height

            Elements.Button {
                anchors { top: parent.top; right: parent.right; rightMargin: 62; topMargin: 31 }
                text: qsTr("VK_LOGIN_BUTTON_TEXT")

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: installPath + "images/button_vk.png"
                }

                onClicked: {
                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Vk Login');
                    authPage.startVkAuth();
                }
            }

            Column {
                anchors { fill: parent; topMargin: 30 }
                spacing: 30

                Row {
                    x: 30
                    width: parent.width

                    LabelText {
                        color: (authRegisterMoveUpPage.state === "RegistrationPage"
                                && authRegisterMoveUpPage.authedAsGuest) ? "#ffff66" : "#ffffff"

                        text: authRegisterMoveUpPage.authedAsGuest
                              ? qsTr("AUTH_GUEST_REGISTER_MESSAGE")
                              : qsTr("AUTH_REGISTER_NORMAL_MESSAGE_DESC")
                    }

                    Column {
                        width: parent.width
                        spacing: 6

                        Text {
                            text: qsTr("AUTH_REGISTER_LOGIN_LABEL")
                            font { family: "Arial"; pixelSize: 16 }
                            wrapMode: Text.WordWrap
                            color: "#FFFFFF"
                            smooth: true
                        }

                        Column {
                            width: parent.width
                            spacing: 1

                            Elements.Input {
                                id: registerLoginTextInput

                                width: 208
                                height: 28
                                textEchoMode: TextInput.Normal
                                editDefaultText: qsTr("PLACEHOLDER_LOGIN_INPUT")
                                focus: true
                                onEnterPressed: {
                                    if (!registerPasswordTextInput.textEditComponent.text) {
                                        registerPasswordTextInput.textEditComponent.focus = true;
                                        return;
                                    }

                                    registrationPage.registerButtonClicked();
                                }

                                textEditComponent.onTextChanged: {
                                    if (authRegisterMoveUpPage.guestAutoStart)
                                        authPage.stopGuestAutoStart();
                                }

                                onTabPressed: registerPasswordTextInput.textEditComponent.focus = true;
                            }

                            Text {
                                text: qsTr("AUTH_REGISTER_LOGIN_CAPTION")
                                font { family: "Arial"; pixelSize: 12 }
                                wrapMode: Text.WordWrap
                                color: "#b9d3b3"
                                smooth: true
                            }
                        }

                        Text {
                            text: qsTr("AUTH_REGISTER_PASSWORD_LABEL")
                            font { family: "Arial"; pixelSize: 16 }
                            wrapMode: Text.WordWrap
                            color: "#FFFFFF"
                            smooth: true
                        }

                        Column {
                            width: parent.width
                            spacing: 1

                            Elements.Input {
                                id: registerPasswordTextInput

                                width: 208
                                height: 28
                                textEchoMode: TextInput.Password
                                editDefaultText: qsTr("PLACEHOLDER_PASSWORD_INPUT")
                                showKeyboardLayout: true
                                focus: true
                                onEnterPressed: registrationPage.registerButtonClicked();
                                textEditComponent.onTextChanged: {
                                    if (authRegisterMoveUpPage.guestAutoStart)
                                        authPage.stopGuestAutoStart();
                                }

                                onTabPressed: registerLoginTextInput.textEditComponent.focus = true;
                            }


                            Text {
                                font { family: "Arial"; pixelSize: 12 }
                                text: qsTr("AUTH_REGISTER_PASSWORD_CAPTION")
                                wrapMode: Text.WordWrap
                                color: "#b9d3b3"
                                smooth: true
                            }
                        }

                        Item {
                            width: 1
                            height: 1
                        }

                        Text {
                            width: 270
                            font { family: "Arial"; pixelSize: 12 }
                            text: qsTr("AUTH_REGISTER_LICENSE_MESSAGE")
                            wrapMode: Text.WordWrap
                            color: "#b9d3b3"
                            smooth: true
                            onLinkActivated: Qt.openUrlExternally(link);
                        }

                        Row {
                            spacing: 8

                            Elements.Button {
                                text: qsTr("AUTH_START_REGISTER_BUTTON")
                                onClicked: registrationPage.registerButtonClicked()
                            }

                            Elements.Button {
                                text: qsTr("AUTH_CANCEL_REGISTER_BUTTON")
                                onClicked: registrationPage.bottomLeftButtonClicked()
                            }
                        }
                    }
                }
            }
        }


        states: [
            State {
                name: "Normal"
                PropertyChanges { target: registerPageTitle; text: qsTr("AUTH_REGISTER_TITLE") }
                PropertyChanges { target: registerPageLeftButton; buttonText: qsTr("AUTH_LEFT_BUTTON") }
                PropertyChanges { target: registryPageStatusMessage; text: qsTr("AUTH_NORMAL_REGISTER_MESSAGE") }
                PropertyChanges { target: registryPageStatusMessage; color: "#ffffff" }
            },

            State {
                name: "ForceOnLogout"
                PropertyChanges { target: registerPageTitle; text: qsTr("AUTH_REGISTER_TITLE_GUEST_LOGOUT") }
                PropertyChanges { target: registerPageLeftButton; buttonText: qsTr("AUTH_LEFT_BUTTON_GUEST_LOGOUT") }
                PropertyChanges { target: registryPageStatusMessage; text: qsTr("AUTH_GUEST_LOGOUT_REGISTER_MESSAGE") }
                PropertyChanges { target: registryPageStatusMessage; color: "#FFFF66" }
            },

            State {
                name: "ForceOnStartGame"
                PropertyChanges { target: registerPageTitle; text: qsTr("AUTH_REGISTER_TITLE_GUEST_EXPIRED") }
                PropertyChanges { target: registerPageLeftButton; buttonText: qsTr("AUTH_LEFT_BUTTON_GUEST_EXPIRED") }
                PropertyChanges { target: registryPageStatusMessage; text: qsTr("AUTH_GUEST_EXPIRED_REGISTER_MESSAGE") }
                PropertyChanges { target: registryPageStatusMessage; color: "#FFFF66" }
            },

            State {
                name: "ForceOnOpenWeb"
                PropertyChanges { target: registerPageTitle; text: qsTr("AUTH_REGISTER_TITLE_GUEST_OPEN_URL") }
                PropertyChanges { target: registerPageLeftButton; buttonText: qsTr("AUTH_LEFT_BUTTON_GUEST_OPEN_URL") }
                PropertyChanges { target: registryPageStatusMessage; text: qsTr("AUTH_GUEST_OPEN_URL_REGISTER_MESSAGE") }
                PropertyChanges { target: registryPageStatusMessage; color: "#FFFF66" }
            },

            State {
                name: "ForceOnRequest"
                PropertyChanges { target: registerPageTitle; text: qsTr("AUTH_REGISTER_TITLE_GUEST_REQUEST_CONFIGRM") }
                PropertyChanges { target: registerPageLeftButton; buttonText: qsTr("AUTH_LEFT_BUTTON_GUEST_REQUEST_CONFIGRM") }
                PropertyChanges { target: registryPageStatusMessage; text: qsTr("AUTH_GUEST_REQUEST_CONFIGRM_REGISTER_MESSAGE") }
                PropertyChanges { target: registryPageStatusMessage; color: "#FFFF66" }
            }
        ]
    }
}
