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

Item {
    id: authPage

    property int autoGuestLoginTimout: 10

    function authSuccess(userId, appKey, cookie, shouldSave, guest) {
        authRegisterMoveUpPage.isInProgress = false;
        authRegisterMoveUpPage.authedAsGuest = guest;
        if (shouldSave || guest) {
            CredentialStorage.save(userId, appKey, cookie, guest);
        }

        authRegisterMoveUpPage.switchAnimation();
        authRegisterMoveUpPage.authDoneCallback(userId, appKey, cookie);
    }

    function authCallback(error, response, shouldSave, guest) {
        authRegisterMoveUpPage.isInProgress = false;
        if (error === Authorization.Result.Success) {
            authPage.authSuccess(response.userId,
                                 response.appKey,
                                 response.cookie,
                                 shouldSave,
                                 guest);
        }
    }

    function startGuestAutoStart() {
        if (authRegisterMoveUpPage.isAuthed)
            return;

        if (authRegisterMoveUpPage.guestAuthEnabled && authRegisterMoveUpPage.selectedGame) {
            authPage.autoGuestLoginTimout = 10;
            authRegisterMoveUpPage.guestAuthTimerStarted = true;
            guestAutoStartTimer.start();
        }
    }

    function stopGuestAutoStart() {
        authRegisterMoveUpPage.guestAuthTimerStarted = false;
        authPage.autoGuestLoginTimout = 10;
        guestAutoStartTimer.stop();
    }

    // Login/Password auth
    function startGenericAuth() {
        authRegisterMoveUpPage.isInProgress = true;
        stopGuestAutoStart();

        var login = loginTextInput.editText,
                password = passwordTextInput.editText;

        passwordTextInput.clear();
        var auth = new Authorization.ProviderGameNet();
        auth.login(login, password, function(error, response) {
            authPage.authCallback(error, response, rememberCheckBox.isChecked, false);

            if (error !== Authorization.Result.Success) {
                authRegisterMoveUpPage.state = "FailAuthPage";

                if (error === Authorization.Result.ServiceAccountBlocked) {
                    failPage.errorMessage = qsTr("AUTH_FAIL_ACCOUNT_BLOCKED");
                    return;
                }

                if (error === Authorization.Result.WrongLoginOrPassword) {
                    failPage.errorMessage = qsTr("AUTH_FAIL_MESSAGE_WRONG");
                    return;
                }

                if (!response) {
                    failPage.errorMessage = qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR");
                    return;
                }

                switch(response.code) {
                case 110: {
                    failPage.errorMessage = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");
                    break;
                }
                case 100: {
                    failPage.errorMessage = qsTr("AUTH_FAIL_MESSAGE_WRONG");
                    break;
                }
                default: {
                    failPage.errorMessage = qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR");
                    break;
                }
                }
            }
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
        authRegisterMoveUpPage.isInProgress = true;
        stopGuestAutoStart();
        var auth = new Authorization.ProviderVk(authPage);
        auth.login(function(error, response) {
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

    Grid {
        anchors { fill: parent; topMargin: 47 }
        columns: 2

        Item {
            width: parent.width
            height: openHeight

            Elements.Button {
                anchors { top: parent.top; right: parent.right; rightMargin: 62; topMargin: 30 }
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

                Grid {
                    columns: 3
                    x: 30
                    width: parent.width

                    Item {
                        width: 225 + 65
                        height: 100

                        Text {
                            width: parent.width - 55
                            font { family: 'Arial'; pixelSize: 14 }
                            color: "#ffffff"
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: qsTr("REGISTRATION_LEFT_LABEL_TEXT")
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: 11

                        Elements.Input {
                            id: loginTextInput

                            width: 208
                            height: 28
                            textEchoMode: TextInput.Normal
                            editDefaultText: qsTr("PLACEHOLDER_LOGIN_INPUT")
                            focus: true
                            onEnterPressed: authPage.startGenericAuth();

                            textEditComponent.onTextChanged: {
                                if (authRegisterMoveUpPage.guestAuthEnabled)
                                    authPage.stopGuestAutoStart();
                            }

                            onTabPressed: passwordTextInput.textEditComponent.focus = true;
                        }

                        Elements.Input {
                            id: passwordTextInput

                            width: 208
                            height: 28
                            textEchoMode: TextInput.Password
                            editDefaultText: qsTr("PLACEHOLDER_PASSWORD_INPUT")
                            focus: true
                            onEnterPressed: authPage.startGenericAuth();

                            textEditComponent.onTextChanged: {
                                if (authRegisterMoveUpPage.guestAuthEnabled)
                                    authPage.stopGuestAutoStart();
                            }

                            onTabPressed: loginTextInput.textEditComponent.focus = true;
                        }

                        Elements.CheckBox {
                            id: rememberCheckBox
                            Component.onCompleted: rememberCheckBox.setValue(true);
                            buttonText: qsTr("CHECKBOX_REMEMBER_ME")
                        }

                        Item {
                            height: 28 + 6
                            width: 1

                            Row {
                                height: 28
                                spacing: 5
                                y: 6

                                Elements.Button {
                                    text: qsTr("AUTH_LOGIN_BUTTON")
                                    onClicked: {
                                        GoogleAnalytics.trackEvent('/Auth', 'Auth', 'General Login');
                                        authPage.startGenericAuth();
                                    }
                                }

                                Elements.Button {
                                    text: qsTr("AUTH_CANCEL_BUTTON")
                                    onClicked: {
                                        GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Auth Cancel');
                                        authRegisterMoveUpPage.state = "AuthPage";
                                    }
                                }
                            }
                        }
                    }
                }

                Row {
                    width: parent.width

                    Rectangle {
                        y: 5
                        width: parent.width
                        height: 1
                        color: '#4c9926'
                    }
                }

                Text {
                    x: 225 + 65 + 30
                    font { family: 'Arial'; pixelSize: 14; underline: true }
                    color: "#ffffff"
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: qsTr("REGISTER_NEW_USER_LINK")

                    Elements.CursorMouseArea {
                        anchors { fill: parent }
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
    }
}
