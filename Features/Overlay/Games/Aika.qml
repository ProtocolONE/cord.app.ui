import QtQuick 1.1
import Tulip 1.0

import "../" as OverlayBase

OverlayBase.OverlayBase {
    id: over

    function onAikaShowWindow(name, arg) {
        if (arg !== 'Hide' && arg !== 'Show') {
            return;
        }

        aikaShopButton.visible = (arg === 'Show');
    }

    function onAikaOpenWindow(name, arg) {
        if (arg !== 'Opened' && arg !== 'Closed') {
            return;
        }

        aikaShopButton.opened = (arg === 'Opened');
    }

    onCustomMessage: {
        // HACK ближе к лайву возможно убрать или частично убрать.
        console.log('Overlay custom message ', name, arg);

        var handlers = {
            'AikaShowWindow': over.onAikaShowWindow,
            'AikaOpenWindow': over.onAikaOpenWindow,
        }

        if (handlers.hasOwnProperty(name)) {
            handlers[name](name, arg);
        } else {
            console.log('Unhandled message ', name, arg);
        }
    }

    Item {
        id: aikaShopButton

        property bool opened: false

        anchors { right: parent.right; top: parent.top }
        anchors { rightMargin: 204; topMargin: 45 }
        width: 72
        height: 72
        visible: false
        onVisibleChanged: console.log('Shop button visible', aikaShopButton.visible)

        Component.onCompleted: console.log('On start shop button visible', aikaShopButton.visible)

        Image {
            source: installPath + "/Assets/Images/GameOverlay/Aika/" + (aikaShopButton.opened ? "shopDown.png" : ( mouser.containsMouse ? "shopHover.png" : "shop.png" ))
        }

        MouseArea {
            id: mouser

            anchors.fill: parent
            hoverEnabled: true
            onClicked: over.sendMessage("AikaShop", "")
            onEntered: over.inputBlock = Overlay.Mouse
            onExited: over.inputBlock = Overlay.None
        }
    }
}
