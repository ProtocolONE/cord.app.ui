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
import "../../Proxy/App.js" as App

Item {
    id: registrationPage

    property string userId
    property string appKey
    property string cookie
    property bool isAuthed
    property bool authedAsGuest: false

    property bool isInProgress: false

    signal cancel();
    signal linkGuestCanceled();
    signal logoutLinkGuestCanceled();

    signal error(string message);

    signal authSuccess(string userId, string appKey, string cookie);
    signal linkGuestDone();
    signal openVkAuth();
    signal saveLogin(string login);

    function startRegister() {
        registrationPage.isInProgress = true;
        var login = registerLoginTextInput.editText,
            password = registerPasswordTextInput.editText;

        registerPasswordTextInput.clear();
        Authorization.register(login, password, function(error, response) {
            if (error === Authorization.Result.Success) {
                registerLoginTextInput.clear();
                Authorization.loginByGameNet(login, password, function(error, response) {
                    registrationPage.isInProgress = false;

                    if (error === Authorization.Result.Success) {
                        registrationPage.authSuccess(response.userId, response.appKey, response.cookie);
                        registrationPage.saveLogin(login);
                    } else {

                        var errorMessage;

                        if (!response) {
                            errorMessage = qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR");
                        } else {
                            var map = {
                                0: qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR"),
                            };
                            map[RestApi.Error.AUTHORIZATION_FAILED] = qsTr("AUTH_FAIL_MESSAGE_WRONG");
                            map[RestApi.Error.INCORRECT_FORMAT_EMAIL] = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");
                            errorMessage = map[response.code] || map[0];
                        }

                        registrationPage.error(errorMessage);
                    }
                });
                return;
            }

            registrationPage.isInProgress = false;

            if (response.message.login) {
                registerLoginTextInput.failState = true;
            }

            if (response.message.password) {
                registerPasswordTextInput.failState = true;
            }

            registrationPage.error((response.message.login ? response.message.login + "<br/>" : "") +
                                   (response.message.password || ""));
        });
    }

    function registerButtonClicked() {
        if (registrationPage.state === "Normal" || !registrationPage.isAuthed) {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Registration');
            registrationPage.startRegister();
        } else {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state,
                                       'Auth', 'Registration Confirm Guest');
            registrationPage.isInProgress = true;

            var provider = new Authorization.ProviderGuest(),
                login = registerLoginTextInput.editText,
                password = registerPasswordTextInput.editText;
            registerPasswordTextInput.clear();

            provider.confirm(registrationPage.userId,
                             registrationPage.appKey,
                             login,
                             password,
                             function(error, response) {
                                 registrationPage.isInProgress = false;
                                 if (error !== Authorization.Result.Success) {
                                     var errorMessage = (!response || !response.message)
                                             ? qsTr("LINK_GUEST_UNKNOWN_ERROR")
                                             : response.message;

                                     registrationPage.error(errorMessage);
                                     return;
                                 }

                                 Marketing.send(Marketing.GuestAccountConfirm, "0",
                                                {
                                                    method: "Generic",
                                                    recoveryCount: 0 // так как гостя отрубаем, не будем и считать
                                                });

                                 registrationPage.authSuccess(response.userId,
                                                              response.appKey,
                                                              response.cookie);

                                 registrationPage.saveLogin(login);
                                 registrationPage.linkGuestDone();
                                 return;

                             });
        }
    }

    function cancelRegistrationClicked() {
        if (registrationPage.state === "ForceOnLogout") {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Guest Logout');
            registrationPage.logoutLinkGuestCanceled();
        } else if (registrationPage.state === "ForceOnStartGame"
                   || registrationPage.state === "ForceOnOpenWeb"
                   || registrationPage.state === "ForceOnRequest") {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Guest Confirm Cancel');
            registrationPage.linkGuestCanceled();
        } else {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Switch To Auth');
            registrationPage.cancel();
        }
    }

    function vkButtonClicked() {
        if (registrationPage.state === "Normal") {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Vk Login');
            registrationPage.openVkAuth();
        } else {
            GoogleAnalytics.trackEvent('/Registration/' + registrationPage.state, 'Auth', 'Guest Vk Confirm');
            registrationPage.isInProgress = true;
            Authorization.linkVkAccount(registerPageRightButton, function(error, message) {
                registrationPage.isInProgress = false;

                if (error === Authorization.Result.Success) {
                    Marketing.send(Marketing.GuestAccountConfirm, "0",
                                   {
                                       method: "VK",
                                       recoveryCount: 0//authPage.guestRecoveryCounter()
                                   });

                    registrationPage.authSuccess(registrationPage.userId,
                                                 registrationPage.appKey,
                                                 registrationPage.cookie);
                    registrationPage.linkGuestDone();
                    return;
                }

                registrationPage.error(message || qsTr("GUEST_VK_LINK_UNKNOWN_ERROR"));
            });
        }
    }

    state: "Normal"

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
                    source: installPath + "Assets/Images/button_vk.png"
                }

                onClicked: registrationPage.vkButtonClicked();
            }

            Column {
                anchors { fill: parent; topMargin: 30 }
                spacing: 30

                Row {
                    x: 30
                    width: parent.width

                    LabelText {
                        color: registrationPage.authedAsGuest ? "#ffff66" : "#ffffff"
                        text: registrationPage.authedAsGuest
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
                            onLinkActivated: App.openExternalUrl(link);
                        }

                        Row {
                            spacing: 8

                            Elements.Button {
                                text: qsTr("AUTH_START_REGISTER_BUTTON")
                                onClicked: registrationPage.registerButtonClicked()
                            }

                            Elements.Button {
                                text: qsTr("AUTH_CANCEL_REGISTER_BUTTON")
                                onClicked: registrationPage.cancelRegistrationClicked()
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
