import QtQuick 2.4
//import Tulip 1.0
import Tulip.Overlay 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0

import "./Chat"

import "OverlayBase.js" as OverlayBase

Overlay {
    id: over

    width: 1024
    height: 1024
    visible: true

    inputCapture: Overlay.MouseAndKeyboard
    inputBlock: Overlay.None

    drawFps: false
    opacity: 1
    onGameInit: {
        console.log('Overlay game init ', width, height);
        over.width = width;
        over.height = height;

//        if (width < browserRoot.width ||
//            height < browserRoot.height) {
//            App.setOverlayEnabled(false);
//        }

        var messenger = WidgetManager.getWidgetByName('Messenger');
        if (messenger) {
            loader.sourceComponent = chatComponent;
        } 
    }

    Component.onCompleted: {
        OverlayBase.setBlockFunc(function(block) {
            over.inputBlock = block;
        });
    }

    function setBlockInput(name, value) {
        OverlayBase.setBlockInput(name, value);
    }

    Connections {
        target: User

        onBalanceChanged: {
            over.sendMessage("custom.accountFunding", JSON.stringify({amount: balance}));
        }
    }

// INFO Выклюено ибо не используется. Если надо будет включить, необходимо будет заменить браузер под капотом.
//    WidgetContainer {
//        id: browserRoot

//        property bool viewVisible: viewInstance.visible

//        widget: 'Money'
//        width: 1002
//        height: 697
//        anchors.centerIn: parent
//        onViewVisibleChanged: {
//            over.setBlockInput('money', (viewVisible ? Overlay.MouseAndKeyboard : Overlay.None));
//        }
//    }

    Loader {
        id: loader

        anchors.fill: parent
        onLoaded: {
            var messenger = WidgetManager.getWidgetByName('Messenger');
            loader.item.messenger = messenger.model;
            loader.item.init();

            over.keyReleased.connect(loader.item.keyDown);
        }
    }

    Component {
        id: chatComponent

        Chat {
            id: chat

            anchors.fill: parent

            settings: WidgetManager.getWidgetSettings('Overlay')

            onBlockMouse: over.setBlockInput('chat', Overlay.Mouse);
            onBlockNone: over.setBlockInput('chat', Overlay.None);

            onIsShownChanged: {
                over.setBlockInput('chat', (isShown ? Overlay.MouseAndKeyboard : Overlay.None));

                App.setOverlayChatVisible(isShown);

                if (!isShown) {
                    chat.forceActiveFocus();
                }
            }
        }
    }

    // Попробуем таймер для проверки работает ли вообще репейнт на ноуте.
    // Хак работает - решить оставить ли его
//    Timer {
//        id: timerRepaint

//        interval: 1000
//        running: true
//        repeat: true
//        onTriggered: over.repaint();
//    }
}

