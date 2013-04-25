import QtQuick 1.1
import Tulip 1.0
import QtWebKit 1.0

import "../Elements" as Elements

import "../js/UserInfo.js" as UserInfo

Item {
    id: root

    width: 800
    height: 800

    // HACK
    //Component.onCompleted: d.createOverlay("300003010000000000");

    Connections {
        target: mainWindow

        onServiceStarted: {
            d.createOverlay(service);
        }
    }

    QtObject {
        id: d

        function createOverlay(service) {
            var overlayEnabled = Settings.value(
                        'gameExecutor/serviceInfo/' + service + "/",
                        "overlayEnabled",
                        1) != 0;

            if (!overlayEnabled) {
                console.log('Overlay disabled for game ', service);
                return;
            }

            if (service != "300003010000000000") {
                return;
            }

            var overlayInstance = overlay.createObject(root,
                                                       {
                                                           width: 1024,
                                                           height: 1024,
                                                           x: -20000,
                                                           y: -20000
                                                       });
            overlayInstance.init();
            overlayInstance.forceActiveFocus();

            var serviceFinishCallback = function(serviceId) {
                if (service == serviceId) {
                    mainWindow.serviceFinished.disconnect(serviceFinishCallback);
                    overlayInstance.destroy();
                }
            }

            mainWindow.serviceFinished.connect(serviceFinishCallback);

            overlayInstance.beforeClosed.connect(function() {
                overlayInstance.destroy();
            });
        }
    }

    Component {
        id: overlay

        Overlay {
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
                }
            }

            function onBsWindowCreate(name, arg) {
                if (arg == 'Loading') {
                    over.setBsGameState("Loading");
                }

                if (arg == 'SystemBack') {
                    over.worldInitializing = true;
                }

                if (arg == 'OptWin') {
                    over.charSelectInitializing = true;
                }
            }

            function onBsWindowDestroy(name, arg) {
                if (arg == 'Loading') {
                    if (over.charSelectInitializing) {
                        over.setBsGameState("CharSelect");
                    } else if (over.worldInitializing) {
                        over.setBsGameState("EnteredWorld");
                    } else {
                        over.setBsGameState("None");
                    }
                }

                if (arg == 'SystemBack') {
                    over.worldInitializing = false;
                }

                if (arg == 'OptWin') {
                    over.charSelectInitializing = false;
                }
            }

            function onBSNetworkPacket(name, arg) {
                var packet = JSON.parse(arg);
                var name = packet.type;

                if (name == 'NS_CreateRole') {
                    over.charCount += 1;
                }
                if (name == 'NS_DeleteRole') {
                    over.charCount -= 1;
                }

                if (name == 'NS_ServerInfo') {
                    over.isDemonion = packet.demonion == 1;
                }

                if (name == 'NS_EnumRole') {
                    over.loadingCharTooLong = false;
                    over.charInfoLoaded = true;
                    over.charCount = packet.charCount;
                    loadingCharTimer.stop();
                }

                if (name == 'NS_SynchronismTime') {
                    over.loadingCharTooLong = false;
                    over.charInfoLoaded = false;
                    loadingCharTimer.start();
                }
            }

            function onBSOpenMall(name, arg) {
                if (arg === "1") {
                    over.openShop();
                }
            }

            flags: Qt.Window | Qt.Tool | Qt.FramelessWindowHint
            width: 1024
            height: 1024
            x: 10
            y: 10
            visible: true

            inputCapture: Overlay.MouseAndKeyboard
            inputBlock: Overlay.None

            drawFps: false
            opacity: 1

            onGameInit: {
                console.log('Overlay game init', width, height);
                over.width = width;
                over.height = height;
            }

            onKeyPressed: {
                if (key == Qt.Key_Escape && over.isShopOpened) {
                    over.closeShop();
                }
            }

            onCustomMessage: {
                // HACK ближе к лайву возможно убрать или частично убрать.
                //console.log('Overlay custom message ', name, arg);

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

            // Попробуем таймер для проверки работает ли вообще репейнт на ноуте.
            // Хак работает - решить оставить ли его
            Timer {
                id: timerRepaint

                interval: 1000
                running: true
                repeat: true
                onTriggered: over.repaint();
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

//                    function getUrlWithCookieAuth(url)
//                    {
//                        var _cookie = '5IXpWXRDnsrRTRTQE2iUmPeju0T3gpYhIqMfYlAx1XicWvaV5BIu8jrPuNCQYVhbl1agUTbaYYlVySbwGwrfulvEBRhzxGnkczncZ66htZN%2FKNeULSDaM6OsDOX7o7d8GVWbLqMXO%2BPWeh70ex7XMTBUoLb0vV6XjhRjxn3W7h6jiVVX96ZZbx0lNih1Oyb3oneGjOog3gob187Knd2%2BR%2FV4b8hNHnbzD2aE62J3hZgLByeN2nm%2BzyCj7zFhpxUtN11v8ule%2BCob6yFB2D%2FzPx%2FTu9T9SId8Bdwk6J0JxxKthnyGwxEeQ8DKcstdNXWul5xlGIE%2BBgMdGerN26UPYetiJRf96m2ReUsLI7JFVkBK0rtbr6r3biLfBCEzM5Kp3BsNwjffSmmt7eZvH1zV7suJJw';
//                        return _cookie ? 'http://gnlogin.sabirov.dev/?auth=' + _cookie + '&rp=' + encodeURIComponent(url) : url;
//                    }

                    function url() {
                        //return "http://mail.ru"
                        return UserInfo.getUrlWithCookieAuth("http://www.gamenet.ru/games/bs/helper");
//                        var q = getUrlWithCookieAuth("http://shop.beletskaya.dev/bs/?serverId=74");
//                        console.log('open url ', q);
//                        return q;
                    }

                    function urlEncondingHack(url) {
                        return "<html><head><script type='text/javascript'>window.location='" + url + "';</script></head><body></body></html>";
                    }

                    function reloadShop() {
                        webShopView.html = urlEncondingHack(url());
                    }

                    html: urlEncondingHack(url())
                    anchors.centerIn: parent
                    preferredWidth: 1000
                    preferredHeight: 700
                    width: 1000
                    height: 700
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
    }
}

