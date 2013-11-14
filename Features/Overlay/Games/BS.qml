import QtQuick 1.1
import Tulip 1.0
import QtWebKit 1.0

import "../../../Elements" as Elements
import ".." as OverlayBase

import "../../../js/UserInfo.js" as UserInfo
import "../../../Proxy/App.js" as App

OverlayBase.OverlayBase {
    id: over

    property bool charSelectInitializing: false
    property bool worldInitializing: false
    property string bsGameState: "None"

    property bool isShopOpened: false
    property bool charInfoLoaded: false
    property bool showLoadingCharWindow: over.bsGameState == "CharSelect" && !over.charInfoLoaded
    property bool loadingCharTooLong: false

    property bool isDemonion: false
    property int charCount: -1

    property bool errorOnLastShopOpen: false

    property string silver;
    property int money;
    property int coupon;
    property int bonus;
    property int goldOnChar;
    property int silverOnChar;

    property string exchangeSilver;
    property int exchangeGoldOnChar;
    property int exchangeSilverOnChar;
    property int exchangeMoney;

    function openShop() {
        blockInputTurnOffDelay.stop();

        if (over.errorOnLastShopOpen) {
            over.errorOnLastShopOpen = false;
            webShopView.reloadShop();
        }

        over.isShopOpened = true;
        over.inputBlock = Overlay.MouseAndKeyboard;
    }

    function closeShop() {
        if (!over.isShopOpened) {
            return;
        }

        over.isShopOpened = false;
        over.sendMessage("BSCloseShop", "");
        blockInputTurnOffDelay.restart();
    }

    function switchShop() {
        if (over.isShopOpened) {
            over.closeShop();
        } else {
            over.openShop();
        }
    }

    function setBsGameState(bsState) {
        over.bsGameState = bsState;
        if (bsState != 'EnteredWorld') {
            over.closeShop();
            over.errorOnLastShopOpen = true;
        } else {
            webShopView.reloadShop();
            over.errorOnLastShopOpen = true;
        }
    }

    function onBsWindowCreate(name, arg) {
        if (arg === 'Loading') {
            over.setBsGameState("Loading");
            return;
        }

        if (arg === 'SystemBack') {
            over.worldInitializing = true;
            return;
        }

        if (arg === 'OptWin') {
            over.charSelectInitializing = true;
            return;
        }
    }

    function onBsWindowDestroy(name, arg) {
        if (arg === 'Loading') {
            if (over.charSelectInitializing) {
                over.setBsGameState("CharSelect");
                return;
            }

            if (over.worldInitializing) {
                over.setBsGameState("EnteredWorld");
                return;
            }

            over.setBsGameState("None");
            return;
        }

        if (arg === 'SystemBack') {
            over.worldInitializing = false;
            return;
        }

        if (arg === 'OptWin') {
            over.charSelectInitializing = false;
            return;
        }
    }

    function onBSNetworkPacket(name, arg) {
        var packet = JSON.parse(arg);
        var packetType = packet.type;

        if (packetType === 'NS_CreateRole') {
            over.charCount += 1;
            return;
        }

        if (packetType === 'NS_DeleteRole') {
            over.charCount -= 1;
            return;
        }

        if (packetType === 'NS_ServerInfo') {
            over.isDemonion = (packet.demonion == 1);
            return;
        }

        if (packetType === 'NS_EnumRole') {
            over.loadingCharTooLong = false;
            over.charInfoLoaded = true;
            over.charCount = packet.charCount;
            loadingCharTimer.stop();
            return;
        }

        if (packetType === 'NS_SynchronismTime') {
            over.loadingCharTooLong = false;
            over.charInfoLoaded = false;
            loadingCharTimer.start();
            return;
        }

        if (packetType === 'NS_BagSilver') {
            over.silver = packet.totalSilver;
            over.silverOnChar = packet.silver;
            over.goldOnChar = packet.gold;
            console.log('Current total silver: ', packet.silver, ' Gold: ', packet.gold, ' Silver: ', packet.silver);
        }

        if (packetType === 'NS_BagYuanBao') {
            over.money = packet.yuanBao;
            console.log('Current money: ', packet.yuanBao);
        }

        if (packetType === 'NS_ExchangeVolume') {
            over.coupon = packet.nCurExVolume;
            console.log('Current coupon: ', packet.nCurExVolume);
        }

        if (packetType === 'NS_Mark') {
            over.bonus = packet.nCurMark;
            console.log('Current bonus: ', packet.nCurMark);
        }

        if (packetType === 'NS_GetYBAccount') {
            over.exchangeMoney = packet.yuanBao;
            over.exchangeSilver = packet.totalSilver;
            over.exchangeSilverOnChar = packet.silver;
            over.exchangeGoldOnChar = packet.gold;
            console.log('Current exchange total silver: ', over.exchangeSilver,
                        ' Gold: ', over.exchangeGoldOnChar,
                        ' Silver: ', over.exchangeSilverOnChar,
                        ' Money: ', over.exchangeMoney);
        }

        if (packetType === 'NS_SynAccoutSilver') {
            over.exchangeSilver = packet.totalSilver;
            over.exchangeSilverOnChar = packet.silver;
            over.exchangeGoldOnChar = packet.gold;
            console.log('Current exchange total silver: ', over.exchangeSilver,
                        ' Gold: ', over.exchangeGoldOnChar,
                        ' Silver: ', over.exchangeSilverOnChar,
                        ' Money: ', over.exchangeMoney);
        }

        if (packetType === 'NS_SynAccoutYB') {
            over.exchangeMoney = packet.yuanBao;
            console.log('Current exchange total silver: ', over.exchangeSilver,
                        ' Gold: ', over.exchangeGoldOnChar,
                        ' Silver: ', over.exchangeSilverOnChar,
                        ' Money: ', over.exchangeMoney);
        }

    }

    function onBSOpenMall(name, arg) {
        if (arg === "1") {
            over.openShop();
        }
    }


    function clearCookie() {
        WebViewHelper.setCookiesFromUrl('', 'http://www.gamenet.ru')
        WebViewHelper.setCookiesFromUrl('', 'http://gamenet.ru')
        WebViewHelper.setCookiesFromUrl('', 'https://gnlogin.ru')
    }

    onKeyPressed: {
        if (key == Qt.Key_Escape && over.isShopOpened) {
            over.closeShop();
        }
    }

    onCustomMessage: {
        // HACK ближе к лайву возможно убрать или частично убрать.
        // console.log('Overlay custom message ', name, arg);

        var handlers = {
            'BSCreateWindow': over.onBsWindowCreate,
            'BSDestroyWindow': over.onBsWindowDestroy,
            'BSNetworkPacket': over.onBSNetworkPacket,
            'BSOpenMall': over.onBSOpenMall,
        }

        if (handlers.hasOwnProperty(name)) {
            handlers[name](name, arg);
        } else {
            console.log('Unhandled message ', name, arg);
        }
    }

    onGameInit: {
        if (!App.isPublicVersion()) {
            over.sendMessage("BSEnableWebShop", "");
        }
    }

    Timer {
        id: blockInputTurnOffDelay

        interval: 500
        running: false
        repeat: false
        onTriggered: over.inputBlock = Overlay.None;
    }

    Rectangle {
        anchors.fill: parent
        color: "#00000000"
        opacity: 1

        Timer {
            id: loadingCharTimer

            interval: 600000
            running: false
            repeat: false
            onTriggered: over.loadingCharTooLong = true;
        }

        AnimatedImage {
            visible: over.showLoadingCharWindow && !over.loadingCharTooLong
            anchors { centerIn: parent }
            playing: true
            source: installPath + "/images/GameOverlay/BS/charactersLoading.gif"
        }

        AnimatedImage {
            visible: over.showLoadingCharWindow && over.loadingCharTooLong
            anchors { centerIn: parent }
            playing: true
            source: installPath + "/images/GameOverlay/BS/charactersLoadingFail.gif"
        }

        Image {
            visible: over.isDemonion
                     && over.bsGameState == "CharSelect"
                     && over.charInfoLoaded
                     && over.charCount == 0
            anchors.centerIn: parent
            source: installPath + "/images/GameOverlay/BS/event_only.png"
        }

        Image {
            id: noCharImage

            visible: !over.isDemonion
                     && over.bsGameState == "CharSelect"
                     && over.charInfoLoaded
                     && over.charCount == 0

            opacity: visible ? 1 : 0

            anchors {
                right: parent.right
                rightMargin: 210
                top: parent.top
                topMargin: 25
            }

            source: installPath + "/images/GameOverlay/BS/no_char.png"

            Behavior on opacity {
                NumberAnimation { duration: 1000 }
            }

            SequentialAnimation {
                running: noCharImage.visible
                loops: Animation.Infinite

                PropertyAnimation {
                    target: noCharImage
                    property: "anchors.rightMargin"
                    duration: 350
                    easing.type: Easing.Linear
                    from: 210
                    to: 225
                }

                PropertyAnimation {
                    target: noCharImage
                    property: "anchors.rightMargin"
                    from: 225
                    to: 210
                    duration: 350
                    easing.type: Easing.Linear
                }
            }
        }

        WebView {
            id: webShopView

            function getShopUrl() {
                return UserInfo.getUrlWithCookieAuth("http://shop.gamenet.ru/bs");
            }

            function urlEncondingHack(url) {
                return "<html><head><script type='text/javascript'>window.location='" + url + "';</script></head><body></body></html>";
            }

            function reloadShop() {
                webShopView.html = urlEncondingHack(getShopUrl());
            }

            Component.onCompleted: clearCookie();

            html: ""
            anchors.centerIn: parent
            preferredWidth: 1002
            preferredHeight: 697
            width: 1002
            height: 697

            scale: 1

            visible: over.isShopOpened
            opacity: over.isShopOpened ? 1 : 0

            settings {
                pluginsEnabled: false
                autoLoadImages: true
                javaEnabled: false
                javascriptEnabled: true
            }

            javaScriptWindowObjects: QtObject {
                WebView.windowObjectName: "overlay"

                function closeShopWindow() {
                    over.closeShop();
                }

                function openExternalWindow(url) {
                    App.openExternalBrowser(url);
                }

                function getMoney() {
                    var result = {
                        silverOnChar: over.silverOnChar,
                        goldOnChar: over.goldOnChar,
                        realMoney: over.money,
                        coupon: over.coupon,
                        bonus: over.bonus,
                        exchangeMoney: over.exchangeMoney,
                        exchangeSilver: over.exchangeSilver,
                        exchangeSilverOnChar: over.exchangeSilverOnChar,
                        exchangeGoldOnChar: over.exchangeGoldOnChar
                    };

                    console.log('BS current balance', JSON.stringify(result));
                    return result;
                }

                function isShopOpened() {
                    return webShopView.visible;
                }
            }

            onLoadFailed: {
                console.log('Webview Load failed ');
                over.closeShop();
                over.errorOnLastShopOpen = true;
            }

            // Disable context menu hack
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
            }
        }

    }
}
