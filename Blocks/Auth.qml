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

Blocks.MoveUpPage {
    id: authRegisterMoveUpPage

    property variant selectedGame
    property bool isAuthed: false
    property string userId
    property string appKey
    property string cookie
    property bool authedAsGuest: false
    property bool guestAuthEnabled: false
    property bool guestAuthTimerStarted: false

    property bool hasGuestInfo: false
    property variant guestInfo

    signal authDone(string userId, string appKey, string cookie);
    signal logoutDone();
    signal linkGuestDone();
    signal linkGuestCanceled();
    signal autoLoginFailed();

    onLogoutDone: authedAsGuest = false;

    function logout() {
        if (authRegisterMoveUpPage.authedAsGuest) {
            registrationPage.state = "ForceOnLogout"
            authRegisterMoveUpPage.state = "RegistrationPage";
            if (!authRegisterMoveUpPage.isOpen)
                authRegisterMoveUpPage.switchAnimation();
        } else {
            resetCredential();
            logoutDone();
            authRegisterMoveUpPage.state = "AuthPage";
            registrationPage.state = "Normal";
        }
    }

    function resetCredential() {
        CredentialStorage.reset();
        authRegisterMoveUpPage.isAuthed = false;
        authRegisterMoveUpPage.userId = '';
        authRegisterMoveUpPage.appKey = '';
        authRegisterMoveUpPage.cookie = '';
    }

    function authDoneCallback(userId, appKey, cookie) {
        authRegisterMoveUpPage.userId = userId;
        authRegisterMoveUpPage.appKey = appKey;
        authRegisterMoveUpPage.cookie = cookie;
        authRegisterMoveUpPage.isAuthed = true;
        authRegisterMoveUpPage.closeMoveUpPage();
        authRegisterMoveUpPage.authDone(userId, appKey, cookie);
    }

    function authByMainGna() {
        var oldAuth = CredentialStorage.loadOldAuth();
        if (oldAuth && oldAuth.login && oldAuth.hash) {
            Marketing.send(Marketing.AuthByOldGnaInfo, "0", {});
            var provider = new Authorization.ProviderGameNet();
            provider.loginByHash(
                        oldAuth.login,
                        oldAuth.hash,
                        function(error, response) {
                            if (error === Authorization.Result.Success) {
                                authRegisterMoveUpPage.authedAsGuest = false;
                                CredentialStorage.save(response.userId, response.appKey, response.cookie, false);
                                authRegisterMoveUpPage.authDoneCallback(response.userId,
                                                                        response.appKey,
                                                                        response.cookie);
                            } else {
                                autoLoginFailed();
                            }
                        });
        } else {
            autoLoginFailed();
        }
    }

    function startAutoLogin() {
        authRegisterMoveUpPage.isAuthed = false;
        authRegisterMoveUpPage.userId = '';
        authRegisterMoveUpPage.appKey = '';
        authRegisterMoveUpPage.cookie = '';
        var savedAuth = CredentialStorage.load();
        if (!savedAuth || !savedAuth.userId || !savedAuth.appKey || !savedAuth.cookie) {
            var guest = CredentialStorage.loadGuest();
            if (!guest || !guest.userId || !guest.appKey || !guest.cookie) {
                if (authRegisterMoveUpPage.guestAuthEnabled) {
                    authByMainGna();
                } else {
                    autoLoginFailed();
                }

                return;
            }

            authPage.increaseGuestRecoveryCounter();
            authRegisterMoveUpPage.guestInfo = guest;
            authRegisterMoveUpPage.hasGuestInfo = true;
            savedAuth = guest;
            CredentialStorage.save(guest.userId, guest.appKey, guest.cookie, true);
            savedAuth.guest = true;
        } else {
            var guest = CredentialStorage.loadGuest();
            if (!guest || !guest.userId || !guest.appKey || !guest.cookie) {
                authRegisterMoveUpPage.hasGuestInfo = false;
            } else {
                authRegisterMoveUpPage.guestInfo = guest;
                authRegisterMoveUpPage.hasGuestInfo = true;
            }
        }

        authRegisterMoveUpPage.authedAsGuest = savedAuth.guest;

        var lastRefresh = Settings.value("qml/auth/", "refreshDate", -1);
        var currentDate = Math.floor(+new Date() / 1000);

        if (lastRefresh != -1 && (currentDate - lastRefresh < 432000)) {
            authRegisterMoveUpPage.authDoneCallback(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
            return;
        }

        var provider = new Authorization.ProviderGameNet();
        provider.refreshCookie(savedAuth.userId, savedAuth.appKey,
                               function(error, response) {
                                   if (error === Authorization.Result.Success) {
                                       Settings.setValue("qml/auth/", "refreshDate", currentDate);
                                       CredentialStorage.save(
                                                   savedAuth.userId,
                                                   savedAuth.appKey,
                                                   response.cookie,
                                                   authRegisterMoveUpPage.authedAsGuest);
                                       authRegisterMoveUpPage.authDoneCallback(savedAuth.userId, savedAuth.appKey, response.cookie);
                                   } else {
                                       authRegisterMoveUpPage.authDoneCallback(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
                                   }
                               })
    }

    function openLinkGuestOnStartGame() {
        registrationPage.state = "ForceOnStartGame"
        authRegisterMoveUpPage.state = "RegistrationPage";
        if (!authRegisterMoveUpPage.isOpen)
            authRegisterMoveUpPage.switchAnimation();
    }

    function openLinkGuestOnOpenPage() {
        registrationPage.state = "ForceOnOpenWeb"
        authRegisterMoveUpPage.state = "RegistrationPage";
        if (!authRegisterMoveUpPage.isOpen)
            authRegisterMoveUpPage.switchAnimation();
    }

    function openLinkGuest() {
        registrationPage.state = "ForceOnRequest"
        authRegisterMoveUpPage.state = "RegistrationPage";
        if (!authRegisterMoveUpPage.isOpen)
            authRegisterMoveUpPage.switchAnimation();
    }

    function openAuthWithGuestTimer() {
        authRegisterMoveUpPage.state = "AuthPage";
        if (!authRegisterMoveUpPage.isOpen)
            authRegisterMoveUpPage.switchAnimation();
        authPage.startGuestAutoStart();
    }

    function updateGuestStatus(guest) {
        authRegisterMoveUpPage.authedAsGuest = (guest == "1");

        if (guest != "0") {
            console.log('Guest login ', authRegisterMoveUpPage.userId);
            CredentialStorage.saveGuest(
                        authRegisterMoveUpPage.userId,
                        authRegisterMoveUpPage.appKey,
                        authRegisterMoveUpPage.cookie,
                        authRegisterMoveUpPage.authedAsGuest);

            authRegisterMoveUpPage.hasGuestInfo = true;
            authRegisterMoveUpPage.guestInfo = {
                userId: authRegisterMoveUpPage.userId,
                appKey: authRegisterMoveUpPage.appKey,
                cookie: authRegisterMoveUpPage.cookie,
            }

            return;
        }

        var guestInfo = CredentialStorage.loadGuest();
        if (guestInfo && guestInfo.userId == authRegisterMoveUpPage.userId) {
            CredentialStorage.saveGuest(authRegisterMoveUpPage.userId, '', '');
            authRegisterMoveUpPage.hasGuestInfo = false;
            authRegisterMoveUpPage.guestInfo = null;
        }
    }

    openHeight: 464
    state: "AuthPage"
    onFinishClosing: {
        registrationPage.state = "Normal"
        if (authRegisterMoveUpPage.hasGuestInfo) {
            authRegisterMoveUpPage.state = "AuthPage";
        }
    }

    Timer {
        running: true
        interval: 3600
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            if (!authRegisterMoveUpPage.isAuthed)
                return;

            var lastRefresh = Settings.value("qml/auth/", "refreshDate", -1);
            var currentDate = Math.floor(+new Date() / 1000);

            if (lastRefresh != -1 && (currentDate - lastRefresh < 432000)) {
                return;
            }

            var provider = new Authorization.ProviderGameNet();
            provider.refreshCookie(authRegisterMoveUpPage.userId, authRegisterMoveUpPage.appKey,
                                   function(error, response) {
                                       if (error === Authorization.Result.Success) {
                                           CredentialStorage.save(
                                                       authRegisterMoveUpPage.userId,
                                                       authRegisterMoveUpPage.appKey,
                                                       response.cookie,
                                                       authRegisterMoveUpPage.authedAsGuest);

                                           Settings.setValue("qml/auth/", "refreshDate", currentDate);
                                           authRegisterMoveUpPage.authDoneCallback(
                                                       authRegisterMoveUpPage.userId,
                                                       authRegisterMoveUpPage.appKey,
                                                       response.cookie);
                                       }
                                   })
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
                        if (authRegisterMoveUpPage.state === "RegistrationPage") {
                            if (authRegisterMoveUpPage.authedAsGuest) {
                                return qsTr("AUTH_GUEST_REGISTER_HEADER");
                            }

                            return qsTr("AUTH_NORMAL_REGISTER_HEADER");
                        }

                        return qsTr("AUTH_LOGIN_TITLE");
                    }

                    function registerHeaderColor() {
                        if (authRegisterMoveUpPage.state === "RegistrationPage" &&
                                authRegisterMoveUpPage.authedAsGuest) {
                            return "#ffff66";
                        }

                        return  "#ffffff"
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

        Item {
            id: hubPage

            width: parent.width
            height: openHeight
            visible: authRegisterMoveUpPage.state === "AuthPage"

            Hub {
                id: hubWidget

                anchors { fill: parent; topMargin: 49 }

                guestEnable: authRegisterMoveUpPage.guestAuthEnabled
                guestDescText: (!!authRegisterMoveUpPage.selectedGame) ? qsTr("GUEST_WIDGET_HEAD_DESC") :
                                                                         qsTr("GUEST_WIDGET_HEAD_DESC_NOT_GAME")
                autoGuestLoginTimout: authPage.autoGuestLoginTimout

                onGuestLogin: {
                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Guest Login');
                    authPage.startGuestAuth();
                }

                onGenericAuth: {
                    authRegisterMoveUpPage.state = "GenericAuthPage"
                }

                onVkAuth: {
                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Vk Login');
                    authPage.startVkAuth();
                }
                onRegister: {
                    authRegisterMoveUpPage.state = "RegistrationPage";
                }
            }

            Elements.Button {
                anchors { right: parent.right; top: parent.top; topMargin: 10; rightMargin: 30 }
                text: qsTr("AUTH_CANCEL_BUTTON")
                onClicked: authRegisterMoveUpPage.switchAnimation();
            }
        }

        AuthBlock {
            id: authPage

            visible: authRegisterMoveUpPage.state === "GenericAuthPage"
            anchors { fill: parent; topMargin: 1 }

            property alias authRegisterMoveUpPage: authRegisterMoveUpPage
        }

        FailBlock {
            id: failPage

            property alias authRegisterMoveUpPage: authRegisterMoveUpPage

            anchors { fill: parent }
            visible: authRegisterMoveUpPage.state === 'FailAuthPage' ||
                     authRegisterMoveUpPage.state === 'FailRegistrationPage'
        }

        Registration {
            id: registrationPage

            anchors { fill: parent }
            visible: authRegisterMoveUpPage.state === "RegistrationPage"

            property alias authRegisterMoveUpPage: authRegisterMoveUpPage
        }

        MouseArea {
            x: 322
            y: 25
            width: 10
            height: 10
            anchors.fill: parent
            z: 100
            onClicked: cat.visible = true
        }

        AnimatedImage {
            id: cat

            x: 322
            y: 20
            visible: false
            playing: visible
            source: installPath + "images/catrun.gif"
            onCurrentFrameChanged: {
                if (currentFrame == frameCount - 1) {
                    visible = false;
                }
            }
        }
    }

    states: [
        State { name: "AuthPage" },
        State { name: "FailAuthPage" },
        State { name: "FailRegistrationPage" },
        State { name: "RegistrationPage" }
    ]
}
