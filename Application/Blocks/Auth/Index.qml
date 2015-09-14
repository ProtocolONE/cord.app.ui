/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0
import GameNet.Core 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0
import Application.Core.Authorization 1.0

import "./Controls"
import "./Controls/Inputs"

import "./AuthBody.js" as AuthHelper

Item {
    id: root

    implicitWidth: 1000
    implicitHeight: 600

    property bool serviceLoading: authContainer.state === 'serviceLoading'

    Component.onCompleted: d.autoLogin();

    Image {
        anchors.fill: parent
        smooth: true
        fillMode: Image.PreserveAspectCrop
        source: installPath + '/Assets/Images/Application/Blocks/Auth/background.jpg'
    }

    Header {
        anchors { left: parent.left; right: parent.right }
        visible: !root.serviceLoading
        state: authContainer.state
    }

    SupportButton {
        anchors { verticalCenter: parent.verticalCenter; right: parent.right }
        visible: !root.serviceLoading
        onClicked: App.openSupportUrl("/kb");
    }

    Rectangle {
        x: authContainer.x -1
        y: authContainer.y -1
        width: authContainer.width + 1
        height: authContainer.height + 1
        color: "#00000000"
        border.color: Styles.light
        opacity: Styles.blockInnerOpacity
    }

    Item {
        id: authContainer

        anchors {
            left:parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 30
            leftMargin: 200
            rightMargin: 200
        }
        height: formContainer.height

        ContentBackground {
            anchors.fill: parent
            opacity: 0.85
        }

        Column {
            id: formContainer

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 50
                rightMargin: 50
            }

            AuthBody {
                id: auth

                visible: false
                guestMode: isGuestExists()

                function isGuestExists() {
                    var guest = CredentialStorage.loadGuest();
                    return !!guest && !!guest.userId && !!guest.appKey && !!guest.cookie;
                }

                function loadGuest() {
                    var guest = CredentialStorage.loadGuest();
                    if (!guest || !guest.userId || !guest.appKey || !guest.cookie) {
                        return;
                    }

                    d.startLoadingServices(guest.userId, guest.appKey, guest.cookie);
                }

                onCodeRequired: {
                    codeForm.codeSended = false;
                    authContainer.state = "code"
                }
                onError: d.showError(message);
                onAuthDone: {
                    d.startLoadingServices(userId, appKey, cookie);

                    if (remember) {
                        CredentialStorage.save(userId, appKey, cookie, false);
                        d.saveAuthorizedLogins(auth.login);
                    } else {
                        auth.login = "";
                    }
                }
                onFooterPrimaryButtonClicked: {
                    if (!auth.inProgress) {
                        Ga.trackEvent('Auth', 'click', 'Switch To Registration')
                        auth.password = "";
                        authContainer.state = "registration";
                    }
                }

                onFooterGuestButtonClicked: loadGuest()
                onFooterVkClicked: d.startVkAuth()
                loginSuggestion: d.loginSuggestion()
                vkButtonInProgress: d.vkAuthInProgress
            }

            RegistrationBody {
                id: registration

                visible: false
                onError: d.showError(message);
                onAuthDone: {
                    d.startLoadingServices(userId, appKey, cookie);

                    CredentialStorage.save(userId, appKey, cookie, false);
                    d.saveAuthorizedLogins(registration.login);
                }

                onFooterPrimaryButtonClicked: {
                    if (!registration.inProgress) {
                        Ga.trackEvent('Auth', 'click', 'Switch To Login')
                        registration.password = "";
                        authContainer.state = "auth";
                     }
                }
                onFooterVkClicked: d.startVkAuth()
                vkButtonInProgress: d.vkAuthInProgress
            }

            CodeBody {
                id: codeForm

                visible: false
                login: auth.login
                onCancel: authContainer.state = "auth"
                onSuccess: authContainer.state = "auth"
                onFooterVkClicked: d.startVkAuth()
                vkButtonInProgress: d.vkAuthInProgress
            }

            MessageBody {
                id: messageBody

                property string backState

                visible: false
                onClicked: authContainer.state = messageBody.backState;
            }
        }

        states: [
            State {
                name :"Initial"
                PropertyChanges { target: formContainer; visible: true }
                PropertyChanges {target: auth; visible: false}
                PropertyChanges {target: registration; visible: false}
                PropertyChanges {target: codeForm; visible: false}
                PropertyChanges {target: messageBody; visible: false}
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
                name: "code"
                extend: "Initial"
                PropertyChanges {target: codeForm; visible: true}
            },
            State {
                name: "message"
                extend: "Initial"
                PropertyChanges {target: messageBody; visible: true}
            },
            State {
                name: "serviceLoading"
                PropertyChanges { target: formContainer; visible: false }
                PropertyChanges { target: serviceLoading; visible: true }
                StateChangeScript {
                    script: serviceLoading.requestServices();
                }
            }
        ]
    }

    Rectangle {
        width: parent.width -1
        height: parent.height -1
        color: "#00000000"
        border.color: Styles.light
        opacity: Styles.blockInnerOpacity
    }

    ServiceLoading {
        id: serviceLoading

        visible: false
        anchors.fill: parent
        onFinished: SignalBus.authDone(userId, appKey, cookie);
    }

    QtObject {
        id: d

        property bool vkAuthInProgress: false

        function isAnyAuthorizationWasDone() {
            var refreshDate = AppSettings.value("qml/auth/", "refreshDate", -1),
                authDone = AppSettings.value("qml/auth/", "authDone", 0);
            return refreshDate > 0 || authDone == 1;
        }

        function showError(message) {
            messageBody.backState = authContainer.state;
            messageBody.message = message;
            authContainer.state = "message";
        }

        function startVkAuth() {
            d.vkAuthInProgress = true;

            Authorization.loginByVk(root, function(error, response) {
                d.vkAuthInProgress = false;

                if (Authorization.isSuccess(error)) {
                    CredentialStorage.save(response.userId, response.appKey, response.cookie);
                    d.startLoadingServices(response.userId, response.appKey, response.cookie);
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

            Ga.trackEvent('Auth', 'click', 'Vk Login')
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

        function startLoadingServices(userId, appKey, cookie) {
            serviceLoading.userId = userId;
            serviceLoading.appKey = appKey;
            serviceLoading.cookie = cookie;

            authContainer.state = "serviceLoading";
        }

        function autoLogin() {
            if (AuthHelper.autoLoginDone) {
                authContainer.state = "auth";
                return;
            }

            AuthHelper.autoLoginDone = true;

            var savedAuth = CredentialStorage.load();
            if (!savedAuth || !savedAuth.userId || !savedAuth.appKey || !savedAuth.cookie) {
                var guest = CredentialStorage.loadGuest();

                if (!guest || !guest.userId || !guest.appKey || !guest.cookie) {
                    authContainer.state = d.isAnyAuthorizationWasDone() ? "auth" : "registration";

                    if (App.isSilentMode()) {
                        var auth = new Authorization.ProviderGuest(),
                            startingServiceId = App.startingService() || "0";

                        if (startingServiceId == "0") {
                            startingServiceId = ApplicationStatistic.installWithService();
                        }

                        auth.login(App.serviceItemByServiceId(startingServiceId).gameId, function(code, response) {
                            if (!Authorization.isSuccess(code)) {
                                // TODO ? Auth failed
                                return;
                            }

                            CredentialStorage.saveGuest(response.userId, response.appKey, response.cookie, true);
                            CredentialStorage.save(response.userId, response.appKey, response.cookie, true);
                            d.startLoadingServices(response.userId, response.appKey, response.cookie);
                        });

                        return;
                    }

                    return;
                }

                savedAuth = guest;
                CredentialStorage.save(guest.userId, guest.appKey, guest.cookie, true);
                savedAuth.guest = true;
            }

            var lastRefresh = AppSettings.value("qml/auth/", "refreshDate", -1);
            var currentDate = Math.floor(+new Date() / 1000);

            if (lastRefresh != -1 && (currentDate - lastRefresh < 432000)) {
                d.startLoadingServices(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
                return;
            }

            Authorization.refreshCookie(savedAuth.userId, savedAuth.appKey, function(error, response) {
               if (Authorization.isSuccess(error)) {
                   AppSettings.setValue("qml/auth/", "refreshDate", currentDate);
                   CredentialStorage.save(
                               savedAuth.userId,
                               savedAuth.appKey,
                               response.cookie,
                               false);
                   d.startLoadingServices(savedAuth.userId, savedAuth.appKey, response.cookie);
               } else {
                   d.startLoadingServices(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
               }
           })
        }

        onVkAuthInProgressChanged: SignalBus.setGlobalProgressVisible(d.vkAuthInProgress, 0);
    }
}
