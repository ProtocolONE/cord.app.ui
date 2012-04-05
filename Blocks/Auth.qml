import QtQuick 1.1
import Tulip 1.0

import "." as Blocks
import "../Elements" as Elements
import "../Models" as Models
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

    openHeight: 291
    state: "AuthPage"
    onFinishClosing: {
        registrationPage.state = "Normal"
        if (authRegisterMoveUpPage.hasGuestInfo) {
            authRegisterMoveUpPage.state = "AuthPage";
        }
    }

    Item {
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
    }

    // Авторизация
    Item {
        anchors.fill: parent

        Rectangle {
            height: 1
            color: "#8CC671"
            anchors { left: parent.left; right: parent.right; top: parent.top }
        }

        // Страница авторизации
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

                var mid = Marketing.mid();
                console.log('Guest login mid - ', mid);
                var gameId,
                    auth = new Authorization.ProviderGuest(mid);
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

            visible: authRegisterMoveUpPage.state === "AuthPage"
            anchors { fill: parent; topMargin: 1 }

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
                columns: 2

                Rectangle {
                    width: 396
                    height: 226
                    color: "#339900"

                    Column {
                        spacing: 10
                        anchors { fill: parent; leftMargin: 42; topMargin: 22 }

                        Text {
                            text: qsTr("AUTH_LOGIN_TITLE")
                            font { family: "Segoe UI Light"; pixelSize: 20 }
                            wrapMode: Text.WordWrap
                            color: "#FFFFFF"
                            smooth: true
                        }

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

                        Row {
                            height: 28
                            spacing: 5

                            Elements.Button {
                                height: 28
                                width: 70
                                buttonText: qsTr("AUTH_LOGIN_BUTTON")
                                enabled: true
                                fontFamily: "Segoe UI Light"
                                onButtonPressed: {
                                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'General Login');
                                    authPage.startGenericAuth();
                                }
                            }

                            Elements.Button4 {
                                height: 28
                                width: 80
                                buttonColor: "#339900"
                                buttonHighlightColor: "#0f6100"
                                buttonText: qsTr("AUTH_CANCEL_BUTTON")
                                isEnabled: true
                                fontFamily: "Segoe UI Light"
                                onButtonClicked: {
                                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Auth Cancel');
                                    authRegisterMoveUpPage.switchAnimation();
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: 404
                    height: 226
                    color: "#288e00"

                    Image {
                        visible: !(authRegisterMoveUpPage.guestAuthEnabled && authRegisterMoveUpPage.selectedGame)
                        source: installPath + "images/registration_logo.png";
                        anchors {
                            verticalCenter: parent.verticalCenter;
                            horizontalCenter: parent.horizontalCenter
                            verticalCenterOffset: oldGuestLoginForm.visible ? -50 : 0
                        }
                    }

                    Column {
                        id: guestCreationForm

                        visible: authRegisterMoveUpPage.guestAuthEnabled &&
                                 (authRegisterMoveUpPage.selectedGame != undefined)
                        spacing: 10
                        anchors { fill: parent; leftMargin: 20; topMargin: 22 }

                        Text {
                            font { family: "Segoe UI Light"; pixelSize: 20 }
                            text: qsTr("AUTH_GUEST_TITLE")
                            wrapMode: Text.WordWrap
                            color: "#FFFFFF"
                            smooth: true
                        }

                        Item {
                            height: 57
                            width: 100

                            Image {
                                anchors.centerIn: parent
                                source: selectedGame ? installPath + selectedGame.imageLogoSmall : ""
                            }
                        }

                        //высота выверена кровью и болью=(
                        Item {
                            height: 29
                            width: 324
                            Text {
                                id: someText

                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 16
                                color: "#FFFF66"
                                wrapMode: Text.WordWrap
                                text: authRegisterMoveUpPage.guestAuthTimerStarted
                                      ? qsTr("AUTH_GUEST_TIMER_MESSAGE").arg(authPage.autoGuestLoginTimout)
                                      : qsTr("AUTH_GUEST_DESCRIPTION");

                            }
                        }

                        Row {
                            height: 28
                            spacing: 10

                            Elements.Button4 {
                                height: 28
                                width: 120
                                isEnabled: !authRegisterMoveUpPage.isInProgress
                                buttonColor: "#339900"
                                buttonHighlightColor: "#0f6100"
                                buttonText: qsTr("AUTH_GUEST_LOGIN_BUTTON")
                                fontFamily: "Segoe UI Light"
                                onButtonClicked: {
                                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Guest Login');
                                    authPage.startGuestAuth();
                                }
                            }

                            Elements.Button4 {
                                height: 28
                                width: 109
                                visible: guestAutoStartTimer.running
                                isEnabled: !authRegisterMoveUpPage.isInProgress
                                buttonColor: "#339900"
                                buttonHighlightColor: "#0f6100"
                                buttonText: qsTr("AUTH_GUEST_AUTO_LOGIN_CANCEL")
                                fontFamily: "Segoe UI Light"
                                onButtonClicked: {
                                    GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Guest Cancel Auto Login');
                                    authPage.stopGuestAutoStart();
                                }
                            }
                        }
                    }

                    Item {
                        id: oldGuestLoginForm

                        width: parent.width
                        height: 110
                        visible: !guestCreationForm.visible && authRegisterMoveUpPage.hasGuestInfo
                        anchors.bottom: parent.bottom

                        Text {
                            anchors { leftMargin: 20; left: parent.left; right: parent.right; rightMargin: 20 }
                            color: "#FFFFFF"
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap
                            text: qsTr("OLD_GUEST_CAPTION")
                        }

                        Elements.Button {
                            anchors { bottom: parent.bottom; bottomMargin: 32; left: parent.left; leftMargin: 20 }
                            height: 28
                            width: 70
                            buttonText: qsTr("OLD_GUEST_AUTH_BUTTON")
                            enabled: true
                            fontFamily: "Segoe UI Light"
                            onButtonPressed: {
                                GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Recovery Guest Login');
                                authRegisterMoveUpPage.startAutoLogin();
                            }
                        }
                    }
                }

                Elements.Button4 {
                    width: 396
                    height: 64
                    isEnabled: true
                    borderWidth: 0
                    buttonColor: "#146b00"
                    buttonHighlightColor: "#0f6100"
                    buttonText:""

                    onButtonClicked: {
                        authPage.stopGuestAutoStart();
                        registrationPage.state = "Normal"
                        authRegisterMoveUpPage.state = "RegistrationPage";
                        GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Switch To Registration');
                    }

                    Text {
                        text: qsTr("AUTH_REGISTER_BUTTON")
                        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 42 }
                        color: "#FFFFFF"
                        font { pixelSize: 20; family: "Segoe UI Light" }
                    }
                }

                Elements.Button4 {
                    width: 404
                    height: 64
                    isEnabled: true
                    borderWidth: 0
                    buttonColor: "#1e8100"
                    buttonHighlightColor: "#187800"
                    onButtonClicked: {
                        GoogleAnalytics.trackEvent('/Auth', 'Auth', 'Vk Login');
                        authPage.startVkAuth();
                    }

                    Row {
                        anchors { fill: parent; leftMargin: 20 }
                        spacing: 5

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: installPath + "images/button_vk.png"
                        }

                        Text {
                            text: qsTr("AUTH_VK_LOGIN_BUTTON")
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#FFFFFF"
                            font { pixelSize: 20; family: "Segoe UI Light" }
                        }
                    }
                }
            }
        }

        // Страница ошибки
        Rectangle {
            id: failPage

            property string errorMessage;

            anchors { fill: parent; topMargin: 1 }
            color: "#339900"
            visible: false

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
                        onButtonPressed: {
                            GoogleAnalytics.trackEvent('/AuthFail', 'Auth', 'Confirm Ok');
                            authRegisterMoveUpPage.state = (authRegisterMoveUpPage.state === "FailAuthPage")
                                         ? "AuthPage"
                                         : "RegistrationPage";
                        }
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

        // Страница регистрации
        Rectangle {
            id: registrationPage

            function startRegister() {
                authRegisterMoveUpPage.isInProgress = true;
                var register = new Authorization.ProviderRegister(),
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
                if (registrationPage.state === "Normal") {
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
                    var provider = new Authorization.ProviderVk(registerPageRightButton);
                    provider.link(function(error, message) {
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

            color: "#146b00"
            anchors { fill: parent; topMargin: 1 }
            visible: authRegisterMoveUpPage.state === "RegistrationPage"
            state: "ForceOnLogout"

            Text {
                id: registerPageTitle

                font { family: "Segoe UI Light"; pixelSize: 20 }
                anchors { left: parent.left; top: parent.top; leftMargin: 42; topMargin: 22 }
                text: qsTr("AUTH_REGISTER_TITLE")
                wrapMode: Text.WordWrap
                color: "#FFFFFF"
                smooth: true
            }

            Row {
                anchors { fill: parent; leftMargin: 42; topMargin: 56; bottomMargin: 64 }
                spacing: 30

                Column {
                    width: 207
                    height: 142

                    Column  {
                        anchors { left: parent.left; right: parent.right }
                        height:  55
                        spacing: 2

                        Elements.Input {
                            id: registerLoginTextInput

                            width: 208
                            height: 28
                            textEchoMode: TextInput.Normal
                            editDefaultText: qsTr("PLACEHOLDER_LOGIN_INPUT")
                            focus: true
                            onEnterPressed: registrationPage.registerButtonClicked();
                            textEditComponent.onTextChanged: {
                                if (authRegisterMoveUpPage.guestAutoStart)
                                    authPage.stopGuestAutoStart();
                            }

                            onTabPressed: registerPasswordTextInput.textEditComponent.focus = true;
                        }

                        Text {
                            text: qsTr("AUTH_REGISTER_LOGIN_CAPTION")
                            font { family: "Segoe UI Light"; pixelSize: 12 }
                            wrapMode: Text.WordWrap
                            color: "#b9d3b3"
                            smooth: true
                        }
                    }

                    Column {
                        anchors { left: parent.left; right: parent.right }
                        height:  55
                        spacing: 2

                        Elements.Input {
                            id: registerPasswordTextInput

                            width: 208
                            height: 28
                            textEchoMode: TextInput.Password
                            editDefaultText: qsTr("PLACEHOLDER_PASSWORD_INPUT")
                            focus: true
                            onEnterPressed: registrationPage.registerButtonClicked();
                            textEditComponent.onTextChanged: {
                                if (authRegisterMoveUpPage.guestAutoStart)
                                    authPage.stopGuestAutoStart();
                            }

                            onTabPressed: registerLoginTextInput.textEditComponent.focus = true;
                        }

                        Text {
                            font { family: "Segoe UI Light"; pixelSize: 12 }
                            text: qsTr("AUTH_REGISTER_PASSWORD_CAPTION")
                            wrapMode: Text.WordWrap
                            color: "#b9d3b3"
                            smooth: true
                        }
                    }

                    Elements.Button {
                        height: 28
                        width: 169
                        buttonText: qsTr("AUTH_START_REGISTER_BUTTON")
                        enabled: true
                        fontFamily: "Segoe UI Light"
                        onButtonPressed: registrationPage.registerButtonClicked()
                    }
                }

                Item {
                    anchors.top: parent.top
                    height: 142
                    width: 360

                    Text {
                        id: registryPageStatusMessage

                        text: qsTr("AUTH_NORMAL_REGISTER_MESSAGE")
                        anchors { left: parent.left; top: parent.top; right: parent.right }
                        color: "#FFFFFF"
                        wrapMode: Text.WordWrap
                        font { pixelSize: 12; family: "Segoe UI Light" }
                        onLinkActivated: Qt.openUrlExternally(link);
                    }

                    Text {
                        text: qsTr("AUTH_REGISTER_LICENSE_MESSAGE")
                        anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
                        color: "#b9d3b3"
                        smooth: true
                        font { family: "Segoe UI Light"; pixelSize: 12 }
                        wrapMode: Text.WordWrap
                        onLinkActivated: Qt.openUrlExternally(link);
                    }
                }
            }

            Row {
                anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 226 }
                height: 64

                Elements.Button4 {
                    id: registerPageLeftButton

                    width: 396
                    height: 64
                    isEnabled: true
                    borderWidth: 0
                    buttonColor: "#339900"
                    buttonHighlightColor: "#2f9500"
                    buttonText: qsTr("AUTH_LEFT_BUTTON")
                    fontSize: 20
                    fontFamily: "Segoe UI Light"
                    onButtonClicked: registrationPage.bottomLeftButtonClicked()
                }

                Elements.Button4 {
                    id: registerPageRightButton

                    width: 404
                    height: 64
                    isEnabled: true
                    borderWidth: 0
                    buttonColor: "#1e8100"
                    buttonHighlightColor: "#187800"
                    onButtonClicked: registrationPage.bottomRightButtonClicked()

                    Row {
                        anchors { fill: parent; leftMargin: 20 }
                        spacing: 5

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: installPath + "images/button_vk.png"
                        }

                        Text {
                            text: qsTr("AUTH_VK_LOGIN_BUTTON")
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#FFFFFF"
                            font { pixelSize: 20; family: "Segoe UI Light" }
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

    MouseArea {
        x: 10
        y: 215
        width: 10
        height: 10
        z: 100
        onClicked: cat.visible = true
    }

    AnimatedImage {
        id: cat

        x: 10
        y: 200
        visible: false
        playing: visible
        source: installPath + "images/catrun.gif"
        onCurrentFrameChanged: {
            if (currentFrame == frameCount - 1) {
                visible = false;
            }
        }
    }

    states: [
        State {
            name: "AuthPage"
            PropertyChanges { target: failPage; visible: false }
        },

        State {
            name: "FailAuthPage"
            PropertyChanges { target: failPage; visible: true }
        },

        State {
            name: "FailRegistrationPage"
            PropertyChanges { target: failPage; visible: true }
        },

        State {
            name: "RegistrationPage"
            PropertyChanges { target: failPage; visible: false }
        }
    ]

}
