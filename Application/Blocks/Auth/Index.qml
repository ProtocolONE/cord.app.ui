import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Config 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0
import Application.Core.Authorization 1.0
import Application.Core.MessageBox 1.0

import "./Controls"
import "./Controls/Inputs"

import "./AuthBody.js" as AuthHelper

Item {
    id: root

    implicitWidth: 1000
    implicitHeight: 600

    property bool serviceLoading: authContainer.state === 'serviceLoading'
    property variant socialButtons: []

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

                onError: d.showError(message, supportButton);
                onJwtAuthDone: {
                    User.setTokenRemember(auth.remember);

                    d.tokenReceived(refreshToken, refreshTokenExpireTime,
                                    accessToken, accessTokenExpireTime);

                    if (auth.remember) {
                        d.saveAuthorizedLogins(auth.login);
                    } else {
                        auth.login = '';
                    }
                }

                onFooterPrimaryButtonClicked: {
                    if (!auth.inProgress) {
                        Ga.trackEvent('Auth', 'click', 'Switch To Registration')
                        auth.password = "";
                        authContainer.state = "registration";
                    }
                }

                onFooterOAuthClicked: d.startOAuth(network, url)
                loginSuggestion: d.loginSuggestion()

                socialButtons: root.socialButtons
            }

            RegistrationBody {
                id: registration

                visible: false
                onError: d.showError(message, supportButton);

                onJwtAuthDone: {
                    User.setTokenRemember(true);
                    d.tokenReceived(refreshToken, refreshTokenExpireTime,
                                    accessToken, accessTokenExpireTime);
                    d.saveAuthorizedLogins(registration.login);
                }

                onFooterPrimaryButtonClicked: {
                    if (!registration.inProgress) {
                        Ga.trackEvent('Auth', 'click', 'Switch To Login')
                        registration.password = "";
                        authContainer.state = "auth";
                     }
                }

                onFooterOAuthClicked: d.startOAuth(network, url)

                socialButtons: root.socialButtons
            }

            MessageBody {
                id: messageBody

                property string backState

                visible: false
                onClicked: authContainer.state = messageBody.backState;
                socialButtons: root.socialButtons
            }
        }

        states: [
            State {
                name :"Initial"
                PropertyChanges { target: formContainer; visible: true }
                PropertyChanges {target: auth; visible: false}
                PropertyChanges {target: registration; visible: false}
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
        width: parent.width - 1
        height: parent.height - 1
        color: "#00000000"
        border.color: Styles.light
        opacity: Styles.blockInnerOpacity
    }

    ServiceLoading {
        id: serviceLoading

        visible: false
        anchors.fill: parent
        onFinished: {
            SignalBus.anotherComputerChanged(serviceLoading.anotherComputer)
            SignalBus.authDone();
            var jwt = User.getAccessToken();
            App.authSuccessSlot(jwt.value, jwt.exp);
        }

    }

    QtObject {
        id: d

        property bool autoLoginInProgress: false
        property bool oauthInProgress: false

        function isAnyAuthorizationWasDone() {
            var refreshDate = AppSettings.value("qml/auth/", "refreshDate", -1),
                authDone = AppSettings.value("qml/auth/", "authDone", 0);
            return refreshDate > 0 || authDone == 1;
        }

        function showError(message, supportButton) {

            MessageBox.show(qsTr("INFO_CAPTION"), message,
                MessageBox.button.ok | (supportButton ? MessageBox.button.support : 0),
                function(result) {
                    if (result === MessageBox.button.support) {
                        App.openExternalUrl("https://support.protocol.one");
                    }});
        }

        function startOAuth(network, url) {
            d.oauthInProgress = true;

            function oAuthResultCallback(error, response) {
                d.oauthInProgress = false;
                if (error == Authorization.Result.Success) {
                    d.tokenReceived(response.refreshToken.value,
                                    response.refreshToken.exp,
                                    response.accessToken.value,
                                    response.accessToken.exp);
                    return;
                }

                d.showError(qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_VK_ERROR"));
            }


            Authorization.loginByOAuth(url, oAuthResultCallback);
            Ga.trackEvent('Auth', 'click', network)
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

        function startLoadingServices(userId, appKey, cookie, anotherComputer) {
            authContainer.state = "serviceLoading";
        }

        function tokenReceived(refreshToken, refreshTokenExpireTime,
                               accessToken, accessTokenExpireTime) {
            AppSettings.setValue("qml/auth/", "authDone", 1);
            User.setTokens(refreshToken, refreshTokenExpireTime,
                           accessToken, accessTokenExpireTime);

            d.startLoadingServices();
        }

        function autoLogin() {
            Authorization.getOAuthServices(d.getOAuthServicesCallback);

            if (AuthHelper.autoLoginDone) {
                authContainer.state = "auth";
                return;
            }

            AuthHelper.autoLoginDone = true;

            var savedAuth = User.loadCredential();
            console.log('AuthSaved:' , JSON.stringify(savedAuth, null,  2))

            if (!savedAuth || !savedAuth.refreshToken || !savedAuth.refreshTokenExpiredTime) {
                authContainer.state = d.isAnyAuthorizationWasDone() ? "auth" : "registration";
                return;
            }

            d.autoLoginInProgress = true;
            var cb = function() {
                console.log('autoLogin changed: ', User.isAuthorized())
                d.autoLoginInProgress = false;
                SignalBus.logoutRequest.disconnect(cb);
                SignalBus.authTokenChanged.disconnect(cb);
                if (!User.isAuthorized()) {
                    // INFO autologin failed
                    authContainer.state = d.isAnyAuthorizationWasDone() ? "auth" : "registration";
                    return;
                }

                d.startLoadingServices();
            }

            User.setTokenRemember(true);
            User.setTokens(savedAuth.refreshToken, savedAuth.refreshTokenExpiredTime);

            SignalBus.logoutRequest.connect(cb);
            SignalBus.authTokenChanged.connect(cb);

            User.refreshTokens();
        }

        function getOAuthServicesCallback(code, response) {
            if (code == Authorization.Result.Success) {
                root.socialButtons = response || [];
            }
        }

        onOauthInProgressChanged: SignalBus.setGlobalProgressVisible(d.oauthInProgress, 0);
    }
}
