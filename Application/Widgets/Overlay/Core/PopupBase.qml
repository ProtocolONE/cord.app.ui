/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import "./Popup.js" as TrayPopup

Item {
    id: popupItem

    property alias containsMouse: mouseArea.containsMouse
    property bool isShown: false
    property bool keepIfActive: false
    property int destroyInterval: 0

    signal anywhereClicked()
    signal closed()
    signal timeoutClosed();

    function restartDestroyTimer() {
        destroyTimer.restart();
    }

    function shadowDestroy() {
        closeAnimation.start();
    }

    function startFadeIn() {
        fadeInAnimation.start();
    }

    function forceDestroy() {
        destroyTimer.stop();
        popupItem.anywhereClicked();
        popupItem.shadowDestroy();
    }

    opacity: 0
    transform: [
        Rotation { angle: 180 },
        Translate { y: height }
    ]

    width: 250
    height: 106

    SequentialAnimation {
        id: fadeInAnimation

        running: true

        PauseAnimation { duration: 200 }
        PropertyAnimation {
            target: popupItem
            property: "opacity"
            from: 0.1
            to: 1
            duration: 150
        }
    }

    PropertyAnimation {
        id: closeAnimation

        target: popupItem
        property: "opacity"
        from: 1
        to: 0.2
        duration: 100
        running: false
        onStopped: {
            destroyTimer.stop();
            TrayPopup.destroy(popupItem);
            popupItem.closed();
            popupItem.destroy();
        }
    }

    MouseArea {
        id: mouseArea

        hoverEnabled: true
        anchors.fill: parent
        onClicked: if (!closeAnimation.running) popupItem.forceDestroy();
    }

    Timer {
        id: destroyTimer

        running: destroyInterval > 0 && isShown && (keepIfActive ? !containsMouse : true)
        interval: destroyInterval
        onTriggered: {
            popupItem.timeoutClosed();
            popupItem.shadowDestroy();
        }
    }
}
