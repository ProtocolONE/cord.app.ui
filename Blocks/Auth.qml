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
import "../js/Core.js" as Core
import "../Proxy/App.js" as AppProxy

Blocks.MoveUpPage {
    id: authRegisterMoveUpPage

    property variant selectedGame
    property bool isAuthed: false
    property string userId
    property string appKey
    property string cookie
    property bool authedAsGuest: false
    property bool guestAuthEnabled: false
    property string lastState: ''

    onStateChanged: {
        if (state != 'FailAuthPage' &&
            state != 'FailRegistrationPage') {
            lastState = state;
        }
    }

    property bool hasGuestInfo: false
    property variant guestInfo

    signal authDone(string userId, string appKey, string cookie);
    signal logoutDone();
    signal linkGuestDone();
    signal linkGuestCanceled();
    signal autoLoginFailed();

    Component.onCompleted: {
        var mid = Marketing.mid();
        Authorization.setup({ mid: mid, hwid: encodeURIComponent(Host.hwid())});

        console.log('Authorization use mid `' + mid + '`');

        //Uncomment for qmlviewer
        //authRegisterMoveUpPage.openMoveUpPage();
    }

    onLogoutDone: {
        if (!authedAsGuest) {
            return;
        }

        guestAuthEnabled = true;
        authedAsGuest = false;
    }

    function openSecondaryAuthPage() {
        state = 'GenericAuthPage';
        isSecondaryAuth = true;
        switchAnimation();
    }

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

    function startAutoLogin() {
        authRegisterMoveUpPage.isAuthed = false;
        authRegisterMoveUpPage.userId = '';
        authRegisterMoveUpPage.appKey = '';
        authRegisterMoveUpPage.cookie = '';
        var savedAuth = CredentialStorage.load();
        if (!savedAuth || !savedAuth.userId || !savedAuth.appKey || !savedAuth.cookie) {
            var guest = CredentialStorage.loadGuest();
            if (!guest || !guest.userId || !guest.appKey || !guest.cookie) {
                autoLoginFailed();
                return;
            }

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

        Authorization.refreshCookie(savedAuth.userId, savedAuth.appKey, function(error, response) {
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
        if (AppProxy.isSilentMode()) {
            var serviceId = Core.currentGame() ? Core.currentGame().serviceId : "";
            var auth = new Authorization.ProviderGuest();
            auth.login(serviceId, function(code, response) {
                if (!Authorization.isSuccess(code)) {
                    authRegisterMoveUpPage.openMoveUpPage();
                    return;
                }

                CredentialStorage.save(response.userId, response.appKey, response.cookie, true);

                authRegisterMoveUpPage.authedAsGuest = true;
                authRegisterMoveUpPage.authDoneCallback(response.userId, response.appKey, response.cookie);
            });

            return;
        }

        authRegisterMoveUpPage.state = "AuthPage";
        if (!authRegisterMoveUpPage.isOpen)
            authRegisterMoveUpPage.switchAnimation();
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

    function saveAuthorizedLogins(login) {
        var currentValue = JSON.parse(Settings.value("qml/auth/", "authedLogins", "{}"));
        currentValue[login] = +new Date();
        Settings.setValue("qml/auth/" , "authedLogins", JSON.stringify(currentValue));
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
        interval: 3600000
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

            Authorization.refreshCookie(authRegisterMoveUpPage.userId, authRegisterMoveUpPage.appKey, function(error, response) {
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

        // Страница ошибки
        Rectangle {
            id: failPage

            property string errorMessage

            function trigger() {
                GoogleAnalytics.trackEvent('/AuthFail', 'Auth', 'Confirm Ok');
                authRegisterMoveUpPage.state = (authRegisterMoveUpPage.state === "FailAuthPage")
                             ? "AuthPage"
                             : "RegistrationPage";
            }

            anchors { fill: parent; topMargin: 1 }
            color: "#339900"
            visible: false
            focus: visible

            Keys.onEnterPressed: failPage.trigger();
            Keys.onReturnPressed: failPage.trigger();

            Item {
                id: authError

                height: 200
                anchors { left: parent.left; top: parent.top; right: parent.right }
                anchors { leftMargin: 316; topMargin: 30; rightMargin: 20 }

                Column {
                    spacing: 10
                    anchors.fill: parent

                    Text {
                        id: authErrorText

                        color: "#ffff66"
                        anchors { left: parent.left; right: parent.right }
                        text: failPage.errorMessage
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        width: 500
                        font { family: "Segoe UI Light"; pixelSize: 13; bold: false }
                        onLinkActivated: Qt.openUrlExternally(link);
                    }

                    Elements.Button {
                        id: forgotPasswordOKbutton

                        buttonText: qsTr("BUTTON_OK")
                        width: 68
                        focus: true
                        fontFamily: "Segoe UI Light"
                        onButtonPressed: failPage.trigger();
                    }

                    Text {
                        color: "#ffff66"
                        anchors { left: parent.left;  }
                        text: qsTr("RESTORE_PASSWORD_LINK")
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        font { family: "Segoe UI Light"; pixelSize: 13; bold: false }
                        onLinkActivated: Qt.openUrlExternally(link);

                        Elements.CursorShapeArea { anchors.fill: parent }
                    }
                }
            }
        }

        Item {
            id: hubPage

            function startRegister() {
                authRegisterMoveUpPage.isInProgress = true;
                var register = new Authorization.ProviderRegister(Marketing.mid()),
                    login = registerLoginTextInput.editText,
                    password = registerPasswordTextInput.editText;
                registerPasswordTextInput.clear();
                register.register(login, password, function(error, response) {
                                      if (error === Authorization.Result.Success) {
                                          registerLoginTextInput.clear();
                                          var auth = new Authorization.ProviderGameNet();
                                          auth.login(login, password, function(error, response) {
                                                         authPage.authCallback(error, response, true, false);
                                                         if (error !== Authorization.Result.Success) {
                                                             authRegisterMoveUpPage.state = "FailRegistrationPage";
                                                             if (!response) {
                                                                 failPage.errorMessage = qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR");
                                                                 return;
                                                             }

            Hub {
                id: hubWidget

                anchors { fill: parent; topMargin: 49 }

                onGenericAuth: authRegisterMoveUpPage.state = "GenericAuthPage"
                onVkAuth: {
                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Vk Login');
                    authPage.startVkAuth();
                }

                onRegister: authRegisterMoveUpPage.state = "RegistrationPage";
            }

            Elements.Button {
                anchors { right: parent.right; top: parent.top; topMargin: 10; rightMargin: 30 }
                text: qsTr("AUTH_CANCEL_BUTTON")
                hoverColor: '#ff9900'
                onClicked: authRegisterMoveUpPage.closeMoveUpPage();
            }
        }

        AuthBlock {
            id: authPage

            visible: authRegisterMoveUpPage.state === "GenericAuthPage"
            anchors { fill: parent; topMargin: 1 }

            onIsInProgressChanged: authRegisterMoveUpPage.isInProgress = authPage.isInProgress

            onError: {
                authRegisterMoveUpPage.state = "FailAuthPage";
                failPage.errorMessage = message;
            }

            onOpenRegistration: {
                registrationPage.state = "Normal"
                authRegisterMoveUpPage.state = "RegistrationPage";
            }

            onCancel: authRegisterMoveUpPage.state = "AuthPage";

            onAuthSuccess: {
                if (shouldSave) {
                    CredentialStorage.save(userId, appKey, cookie, false);
                }

                authRegisterMoveUpPage.authedAsGuest = false;
                authRegisterMoveUpPage.switchAnimation();
                authRegisterMoveUpPage.authDoneCallback(userId, appKey, cookie);
            }

            onSaveLogin: saveAuthorizedLogins(login);
        }

        FailBlock {
            id: failPage

            onBack: authRegisterMoveUpPage.state = authRegisterMoveUpPage.lastState;

            anchors { fill: parent }
            visible: authRegisterMoveUpPage.state === 'FailAuthPage' ||
                     authRegisterMoveUpPage.state === 'FailRegistrationPage'
        }

        Registration {
            id: registrationPage

            userId: authRegisterMoveUpPage.userId
            appKey: authRegisterMoveUpPage.appKey
            cookie: authRegisterMoveUpPage.cookie
            isAuthed: authRegisterMoveUpPage.isAuthed
            authedAsGuest: authRegisterMoveUpPage.authedAsGuest

            anchors { fill: parent }
            visible: authRegisterMoveUpPage.state === "RegistrationPage"

            onIsInProgressChanged: authRegisterMoveUpPage.isInProgress = registrationPage.isInProgress
            onError: {
                authRegisterMoveUpPage.state = "FailRegistrationPage";
                failPage.errorMessage = message;
            }

            onAuthSuccess: {
                CredentialStorage.save(userId, appKey, cookie, false);

                authRegisterMoveUpPage.authedAsGuest = false;
                authRegisterMoveUpPage.switchAnimation();
                authRegisterMoveUpPage.authDoneCallback(userId, appKey, cookie);
            }

            onOpenVkAuth: authPage.startVkAuth();

            onLinkGuestDone: authRegisterMoveUpPage.linkGuestDone();
            onSaveLogin: saveAuthorizedLogins(login);
            onLogoutLinkGuestCanceled: authRegisterMoveUpPage.switchAnimation();

            onLinkGuestCanceled: {
                authRegisterMoveUpPage.linkGuestCanceled();
                authRegisterMoveUpPage.switchAnimation();
            }

            onCancel: authRegisterMoveUpPage.state = "AuthPage";
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
        State { name: "AuthPage" },
        State { name: "GenericAuthPage" },
        State { name: "FailAuthPage" },
        State { name: "FailRegistrationPage" },
        State { name: "RegistrationPage" }
    ]
}
