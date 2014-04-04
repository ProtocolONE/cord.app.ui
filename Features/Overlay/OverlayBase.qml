import QtQuick 1.1
import Tulip 1.0
import "../../Features/Money/Money.js" as Js
import "../../Features/Money" as Money
import "../../js/UserInfo.js" as UserInfo


Overlay {
    id: over

    signal showMoney();

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

        if (width < browserRoot.width ||
            height < browserRoot.height) {
            Js.isOverlayEnable = false;
        }
    }

    onShowMoney: mainWindow.navigate("gogamenetmoney");

    Money.Money {
        id: browserRoot

        anchors { centerIn: parent }
        visible: false
        width: 1002
        height: 697
        z: 1

        onVisibleChanged: over.inputBlock = visible ? Overlay.MouseAndKeyboard : Overlay.None;

        onClose: visible = false;
        onUpdateBalance: over.sendMessage("custom.accountFunding", {amount: balance});

        function getMoneyUrl() {
            return UserInfo.getUrlWithCookieAuth("http://www.gamenet.ru/money");
            //return UserInfo.getUrlWithCookieAuth("http://www.sabirov.dev/money");

        }

        function urlEncondingHack(url) {
            return "<html><head><script type='text/javascript'>window.location='" + url + "';</script></head><body></body></html>";
        }

        function show() {
            browserRoot.addPage(urlEncondingHack(getMoneyUrl()));
            browserRoot.visible = true;
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
}
