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

import "." as Blocks
import "../Elements" as Elements
import "../Models" as Models
import "Auth"
import "../js/Authorization.js" as Authorization
import "../js/GoogleAnalytics.js" as GoogleAnalytics
import "../js/restapi.js" as RestApi
import "../js/UserInfo.js" as UserInfo

Blocks.MoveUpPage {
    id: root

    property variant selectedGame
    property bool isAuthed: false
    property string userId
    property string appKey
    property string cookie
    property string lastState: ''
    property string savePrefix: "second_"
    property string nickname

    onStateChanged: {
        if (state != 'FailAuthPage' &&
            state != 'FailRegistrationPage') {
            lastState = state;
        }
    }

    signal authDone(string userId, string appKey, string cookie);
    signal logoutDone();
    signal autoLoginFailed();

    function logout() {
        resetCredential();
        logoutDone();
        root.state = "GenericAuthPage";
    }

    function resetCredential() {
        CredentialStorage.resetEx(root.savePrefix);
        root.isAuthed = false;
        root.userId = '';
        root.appKey = '';
        root.cookie = '';
    }

    function authDoneCallback(userId, appKey, cookie) {
        if (UserInfo.userId() == userId) {
            resetCredential();
            return;
        }

        root.userId = userId;
        root.appKey = appKey;
        root.cookie = cookie;
        root.isAuthed = true;
        root.closeMoveUpPage();
        root.authDone(userId, appKey, cookie);
        RestApi.Core.execute('user.getProfile',
                             {
                                profileId: root.userId,
                                shortInfo: 1,
                                userId: root.userId,
                                appKey: root.appKey,
                             },
                             false,
                             function(response) {
                                 if (!response || !response.userInfo || response.userInfo.length < 1) {
                                     return;
                                 }

                                 var info = response.userInfo[0].shortInfo;
                                 root.nickname = info.nickname;
                                 // UNDONE handle error
                             },
                             function(error) {
                             });
    }

    function startAutoLogin() {
        root.isAuthed = false;
        root.userId = '';
        root.appKey = '';
        root.cookie = '';

        var savedAuth = CredentialStorage.loadEx(root.savePrefix);
        if (!savedAuth || !savedAuth.userId || !savedAuth.appKey || !savedAuth.cookie) {
            autoLoginFailed();
            return;
        }

        root.authDoneCallback(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
    }

    function saveAuthorizedLogins(login) {
        var currentValue = JSON.parse(Settings.value("qml/auth/", "authedLogins", "{}"));
        currentValue[login] = +new Date();
        Settings.setValue("qml/auth/" , "authedLogins", JSON.stringify(currentValue));
    }

    openHeight: 464
    state: "GenericAuthPage"
    onFinishClosing: {
        registrationPage.state = "Normal";
        if (root.hasGuestInfo) {
            root.state = "GenericAuthPage";
        }
    }

    Item {
        anchors.fill: parent

        Column {
            width: parent.width

            Rectangle {
                width: parent.width
                height: 1
                color: "#4f8434"
            }

            Rectangle {
                width: parent.width
                height: 48
                color: '#236501'

                Text {
                    function registerHeaderText() {
                        if (root.state === "RegistrationPage") {
                            if (root.authedAsGuest) {
                                return qsTr("AUTH_GUEST_REGISTER_HEADER");
                            }

                            return qsTr("AUTH_NORMAL_REGISTER_HEADER");
                        }

                        return qsTr("AUTH_LOGIN_TITLE");
                    }

                    function registerHeaderColor() {
                        if (root.state === "RegistrationPage" && root.authedAsGuest) {
                            return "#ffff66";
                        }

                        return  "#ffffff";
                    }

                    anchors { left: parent.left; leftMargin: 30; verticalCenter: parent.verticalCenter }
                    text: registerHeaderText()
                    font { family: "Arial"; pixelSize: 22 }
                    wrapMode: Text.WordWrap
                    color: registerHeaderColor()
                    smooth: true
                }
            }

            Rectangle {
                width: parent.width
                height: openHeight - 49
                color: "#2d8700"
            }
        }

        AuthBlock {
            id: authPage

            visible: root.state === "GenericAuthPage"
            anchors { fill: parent; topMargin: 1 }

            onIsInProgressChanged: root.isInProgress = authPage.isInProgress

            onError: {
                root.state = "FailAuthPage";
                failPage.errorMessage = message;
            }

            onOpenRegistration: {
                registrationPage.state = "Normal"
                root.state = "RegistrationPage";
            }

            onCancel: root.closeMoveUpPage();

            onAuthSuccess: {
                if (shouldSave) {
                    CredentialStorage.saveEx(root.savePrefix, userId, appKey, cookie, false);
                }

                root.switchAnimation();
                root.authDoneCallback(userId, appKey, cookie);
            }

            onSaveLogin: saveAuthorizedLogins(login);
        }

        FailBlock {
            id: failPage

            onBack: root.state = root.lastState;
            anchors.fill: parent
            visible: root.state === 'FailAuthPage' ||
                     root.state === 'FailRegistrationPage'
        }

        Registration {
            id: registrationPage

            userId: root.userId
            appKey: root.appKey
            cookie: root.cookie
            isAuthed: root.isAuthed
            authedAsGuest: false

            anchors.fill: parent
            visible: root.state === "RegistrationPage"

            onIsInProgressChanged: root.isInProgress = registrationPage.isInProgress
            onError: {
                root.state = "FailRegistrationPage";
                failPage.errorMessage = message;
            }

            onAuthSuccess: {
                CredentialStorage.saveEx(root.savePrefix, userId, appKey, cookie, false);
                root.authDoneCallback(userId, appKey, cookie);
            }

            onOpenVkAuth: authPage.startVkAuth();
            onSaveLogin: saveAuthorizedLogins(login);

            onCancel: root.state = "GenericAuthPage";
        }

        MouseArea {
            x: 322
            y: 25
            width: 10
            height: 10
            z: 100
            onClicked: cat.visible = true
        }

        AnimatedImage {
            id: cat

            x: 322
            y: 20
            visible: false
            playing: visible
            source: installPath + "Assets/Images/catrun.gif"
            onCurrentFrameChanged: {
                if (currentFrame == frameCount - 1) {
                    visible = false;
                }
            }
        }
    }

    states: [
        State { name: "GenericAuthPage" },
        State { name: "FailAuthPage" },
        State { name: "FailRegistrationPage" },
        State { name: "RegistrationPage" }
    ]
}
