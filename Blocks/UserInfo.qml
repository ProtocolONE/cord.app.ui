import QtQuick 1.1
import "." as Blocks
import "../Elements" as Elements
import "../js/restapi.js" as RestApi
import "../js/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: userInfoPage

    property bool isLoginButtonState: true
    property string balance: "0"

    property string nickname
    property string nametech
    property string avatarLarge
    property string avatarMedium
    property string avatarSmall
    property string level
    property bool guest: false

    signal loginRequest();
    signal logoutRequest();
    signal openMoneyRequest();
    signal confirmGuest();
    signal requestNickname();
    signal openProfileRequest();

    function resetUserInfo() {
        nickname = "";
        nametech = "";
        avatarLarge = "";
        avatarMedium = "";
        avatarSmall = "";
        guest = false;
    }

    function setUserInfo(userInfo) {
        nickname = userInfo.nickname;
        nametech = userInfo.nametech;
        avatarLarge = userInfo.avatarLarge;
        avatarMedium = userInfo.avatarMedium;
        avatarSmall = userInfo.avatarSmall;
        guest = (userInfo.guest == 1);
    }

    function setLevel(_level) {
        level = _level;
    }

    function switchToUserInfo()
    {
        if (!isLoginButtonState)
            return;

        isLoginButtonState = false;
        authOpenButtonAnimation.start();
        balanceTimer.tickCount = 0;
        balanceTimer.start();
        refreshBalance();
    }

    function switchToLoginButton()
    {
        if (isLoginButtonState)
            return;

        isLoginButtonState = true;
        authCloseButtonAnimation.start();
        balanceTimer.stop();
    }

    function closeMenu() {
        if (nickNameView.isMenuOpen)
            nickNameView.switchMenu();
    }

    function refreshBalance() {
        RestApi.User.getBalance(function(response) {
            if (response.error) {
                console.debug(response.error.code)
                return;
            }

            if (response && response.speedyInfo) {
                userInfoPage.balance = response.speedyInfo.balance || "0";
            }

        }, function() {});
    }

    function getUserNickName() {
        if (!nickname) {
            return "";
        }

        if (guest) {
            return qsTr("GUEST_DEFAULT_NICKNAME");
        }

        if (nickname.indexOf("@") === -1) {
            return nickname;
        } else {
            return qsTr("DEFAULT_NICKNAME");
        }
    }

    SequentialAnimation {
        id: authOpenButtonAnimation

        NumberAnimation {
            target: loginButtonRectangle;
            easing.type: Easing.OutQuad;
            property: "anchors.topMargin";
            from: 0;
            to: -95;
            duration: 120;
        }

        ParallelAnimation {
            NumberAnimation {
                target: nickNameView;
                easing.type: Easing.OutQuad;
                property: "anchors.rightMargin";
                from: -nickNameView.width;
                to: -5;
                duration: 200;
            }

            NumberAnimation {
                target: nickNameView;
                easing.type: Easing.OutQuad;
                property: "opacity";
                from: 0;
                to: 1;
                duration: 150;
            }
        }
    }

    SequentialAnimation {
        id: authCloseButtonAnimation

        ParallelAnimation {
            NumberAnimation {
                target: nickNameView;
                easing.type: Easing.OutQuad;
                property: "anchors.rightMargin";
                from: -5;
                to: -nickNameView.width;
                duration: 200;
            }

            NumberAnimation {
                target: nickNameView;
                easing.type: Easing.OutQuad;
                property: "opacity";
                from: 1;
                to: 0;
                duration: 150;
            }
        }

        NumberAnimation {
            target: loginButtonRectangle;
            easing.type: Easing.OutQuad;
            property: "anchors.topMargin";
            from: -95;
            to: 0;
            duration: 120;
        }
    }

    Timer {
        id: balanceTimer

        interval: 60000
        running: false
        repeat: true
        property int tickCount: 0

        onTriggered: {
            balanceTimer.tickCount++;
            if ((mainWindow != undefined && mainWindow.isWindowVisible() && balanceTimer.tickCount >= 2)
              || balanceTimer.tickCount >= 5) {
                balanceTimer.tickCount = 0;
                refreshBalance();
            }
        }
    }

    Blocks.NickNameView {
        id: nickNameView

        anchors { top: parent.top; topMargin: -36; right: parent.right; rightMargin: 100 }
        opacity: 0
        upText: getUserNickName()
        downText: userInfoPage.balance
        level: userInfoPage.level
        avatarSource: avatarMedium != undefined ? avatarMedium : installPath + "images/avatar.png"

        isGuest: userInfoPage.guest
        isNickNameSaved: nickname != undefined && nickname.indexOf('@') == -1

        onQuitClicked: {
            GoogleAnalytics.trackEvent('/NickNameView', 'Auth', 'Logout');
            logoutRequest();
        }

        onMoneyClicked: {
            GoogleAnalytics.trackEvent('/NickNameView', 'Open External Link', 'Money');
            openMoneyRequest();
        }

        onConfirmGuest: {
            GoogleAnalytics.trackEvent('/NickNameView', 'Auth', 'Switch To Confirm Guest');
            userInfoPage.confirmGuest();
        }

        onRequestNickname: {
            GoogleAnalytics.trackEvent('/NickNameView', 'Auth', 'Switch To Set Nickname');
            userInfoPage.requestNickname();
        }

        onProfileClicked: openProfileRequest();
    }

    Elements.LoginButton {
        id: loginButtonRectangle

        anchors { top: parent.top; right: parent.right }
        enabled: true;
        buttonText: qsTr("BUTTON_SHOW_LOG_IN_FORM")
        onMouseClicked: {
            GoogleAnalytics.trackEvent('/NickNameView', 'Auth', 'Switch To Auth');
            loginRequest();
        }
    }
}
