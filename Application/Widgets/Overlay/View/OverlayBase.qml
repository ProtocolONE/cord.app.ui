import QtQuick 1.1
import Tulip 1.0
import GameNet.Components.Widgets 1.0

import "../../../Core/User.js" as User
import "../../../Core/App.js" as App
import "OverlayBase.js" as Overlay

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
        console.log('Overlay game init ', width, height);
        over.width = width;
        over.height = height;

        if (width < browserRoot.width ||
            height < browserRoot.height) {
            App.setOverlayEnabled(false);
        }
    }

    onShowMoney: App.navigate("gogamenetmoney");

    Component.onCompleted: {
        Overlay.setBlockFunc(function(block) {
            over.inputBlock = block;
        });
    }

    function setBlockInput(name, value) {
        Overlay.setBlockInput(name, value);
    }

    Connections {
        target: User.getInstance()

        onBalanceChanged: {
           over.sendMessage("custom.accountFunding", {amount: balance});
        }
    }

    WidgetContainer {
        widget: 'Money'

        width: 1002
        height: 697
        anchors.centerIn: parent
        visible: false
        onVisibleChanged: {
            over.setBlockInput('money', (visible ? Overlay.MouseAndKeyboard : Overlay.None));
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
