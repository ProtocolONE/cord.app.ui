import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

import "../../../js/Core.js" as Core
import "../../../js/Authorization.js" as Authorization
import "../../../js/UserInfo.js" as UserInfo

import "../../../Application/Core/App.js" as AppProxy

import "AnimatedBackground" as AnimatedBackground

Rectangle {
    id: root

    width: 1000
    height: 600

    color: "#FAFAFA"

    Component.onCompleted: {
        var mid = Marketing.mid();
        // UNDONE получение хвида попытатьяс вынести в воркер
        //Authorization.setup({ mid: mid, hwid: encodeURIComponent(App.hwid())});
//        console.log('Authorization use mid `' + mid + '`');
        d.autoLogin();
    }

    QtObject {
        id: d

        function showError(message) {
            messageBody.backState = authContainer.state;
            messageBody.message = message;
            authContainer.state = "message";
        }

        function startVkAuth() {
            Core.setGlobalProgressVisible(true);

            Authorization.loginByVk(root, function(error, response) {
                Core.setGlobalProgressVisible(false);

                if (Authorization.isSuccess(error)) {
                    UserInfo.authDone(userId, appKey, cookie);
                    return;
                }

                if (error === Authorization.Result.Cancel) {
                    return;
                }

                if (error === Authorization.Result.ServiceAccountBlocked) {
                    d.showError(qsTr("AUTH_FAIL_ACCOUNT_BLOCKED"));
                    return;
                }

                d.showError(qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_VK_ERROR"));
            });
        }

        function loginSuggestion() {
            var logins = {};
            try {
                logins = JSON.parse(Settings.value("qml/auth/", "authedLogins", "{}"));
            } catch (e) {
            }

            return logins;
        }

        function saveAuthorizedLogins(login) {
            var currentValue = d.loginSuggestion();
            currentValue[login] = +new Date();
            Settings.setValue("qml/auth/" , "authedLogins", JSON.stringify(currentValue));
            auth.loginSuggestion = currentValue;
        }

        function autoLogin() {
            var savedAuth = CredentialStorage.load();
            if (!savedAuth || !savedAuth.userId || !savedAuth.appKey || !savedAuth.cookie) {
                var guest = CredentialStorage.loadGuest();
                if (!guest || !guest.userId || !guest.appKey || !guest.cookie) {
                    //autoLoginFailed();

                    return;
                }

                savedAuth = guest;
                CredentialStorage.save(guest.userId, guest.appKey, guest.cookie, true);
                savedAuth.guest = true;
            }

            var lastRefresh = Settings.value("qml/auth/", "refreshDate", -1);
            var currentDate = Math.floor(+new Date() / 1000);

            if (lastRefresh != -1 && (currentDate - lastRefresh < 432000)) {
                UserInfo.authDone(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
                return;
            }

            Authorization.refreshCookie(savedAuth.userId, savedAuth.appKey, function(error, response) {
               if (Authorization.isSuccess(error)) {
                   Settings.setValue("qml/auth/", "refreshDate", currentDate);
                   CredentialStorage.save(
                               savedAuth.userId,
                               savedAuth.appKey,
                               response.cookie,
                               false);
                   UserInfo.authDone(savedAuth.userId, savedAuth.appKey, response.cookie);
               } else {
                   UserInfo.authDone(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
               }
           })

            // UNDONE autorefresh cookie
        }
    }


    Timer {
        running: true
        interval: 3600000
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            if (!UserInfo.isAuthorized())
                return;

            var lastRefresh = Settings.value("qml/auth/", "refreshDate", -1);
            var currentDate = Math.floor(+new Date() / 1000);

            if (lastRefresh != -1 && (currentDate - lastRefresh < 432000)) {
                return;
            }

            Authorization.refreshCookie(UserInfo.userId(), UserInfo.appKey(), function(error, response) {
                if (Authorization.isSuccess(error)) {
                    CredentialStorage.save(
                               UserInfo.userId(),
                               UserInfo.appKey(),
                               response.cookie,
                               UserInfo.isGuest());

                   Settings.setValue("qml/auth/", "refreshDate", currentDate);
//                   authRegisterMoveUpPage.authDoneCallback(
//                               authRegisterMoveUpPage.userId,
//                               authRegisterMoveUpPage.appKey,
//                               response.cookie);
                }
            })
        }
    }
    /*AnimatedBackground.Index {
        id: background

        function registerInfoValid() {
            var loginReg = /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,4})$/;
            return registration.password.length >= 6 && loginReg.test(registration.login);
        }

        anchors.fill: parent
        isDoggyVisible: footer.vkButtonContainsMouse
        goodSignActive: background.registerInfoValid();
    }*/

    Header {
        id: header

        anchors { left: parent.left; right: parent.right }
    }

    Item {
        id: authContainer

        anchors {
            left: parent.left
            leftMargin: 250
            right: parent.right
            rightMargin: 250
            top: header.bottom
            bottom: footer.top
        }

        Switcher {
            id: centralSwitcher

            anchors.fill: parent

            AuthBody {
                id: auth

                anchors.fill: parent
                onSwitchToRegistration: authContainer.state = "registration"
                onCodeRequired: {
                    codeForm.codeSended = false;
                    authContainer.state = "code"
                }
                onError: d.showError(message);

                onAuthDone: {
                    UserInfo.authDone(userId, appKey, cookie);

                    if (remember) {
                        CredentialStorage.save(userId, appKey, cookie, false);
                        d.saveAuthorizedLogins(auth.login);
                    } else {
                        auth.login = "";
                    }
                }

                loginSuggestion: d.loginSuggestion();
            }

            RegistrationBody {
                id: registration

                anchors.fill: parent
                onError: d.showError(message);
                onSwitchToLogin: {
                    authContainer.state = "auth"
                }

                onAuthDone: {
                    UserInfo.authDone(userId, appKey, cookie);

                    CredentialStorage.save(userId, appKey, cookie, false);
                    d.saveAuthorizedLogins(registration.login);
                }
            }

            CodeBody {
                id: codeForm

                anchors.fill: parent
                login: auth.login
                onCancel: authContainer.state = "auth"
                onSuccess: authContainer.state = "auth"
            }

            MessageBody {
                id: messageBody

                property string backState

                anchors.fill: parent
                onClicked: authContainer.state = messageBody.backState;
            }
        }

        state: "auth"
        states: [
            State {
                name: "auth"

                StateChangeScript {
                    script: centralSwitcher.switchTo(auth);
                }
            },
            State {
                name: "registration"

                StateChangeScript {
                    script: centralSwitcher.switchTo(registration);
                }
            },
            State {
                name: "code"

                StateChangeScript {
                    script: centralSwitcher.switchTo(codeForm);
                }
            },
            State {
                name: "message"

                StateChangeScript {
                    script: centralSwitcher.switchTo(messageBody);
                }
            }
        ]
    }

    Footer {
        id: footer

        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        onOpenVkAuth: d.startVkAuth();
    }

    Button {
        width: 32
        height: 146
        anchors { verticalCenter: parent.verticalCenter; right: parent.right }

        style: ButtonStyleColors {
            normal: "#ffae02"
            hover: "#ffcc02"
        }

        onClicked: {
            AppProxy.openExternalUrl("http://support.gamenet.ru");
        }

        Column {
            anchors.fill: parent

            Item {
                width: parent.width
                height: parent.height - width - 1

                Item {
                    anchors.centerIn: parent
                    rotation: -90
                    width: parent.height
                    height: parent.width

                    Text {
                        anchors.centerIn: parent
                        text: "Задать вопрос"
                        color: "#FFFFFF"
                        font {
                            family: "Arial"
                            pixelSize: 14
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#FFFFFF"
                opacity: 0.2
            }

            Item {
                width: parent.width
                height: width

                Image {
                    anchors.centerIn: parent
                    source: installPath + "Assets/Images/Auth/support.png"
                }
            }

        }
    }
}
