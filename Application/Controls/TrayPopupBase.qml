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
import Application.Core 1.0
import QtQuick.Window 2.2

Item {
    id: popupItem

    default property alias data: container.data

    property alias containsMouse: mouseArea.containsMouse
    property bool isShown: false
    property bool keepIfActive: false
    property int destroyInterval: 0

    property bool _closed: false

    signal anywhereClicked() // killed by anywhereClickDestroy
    signal closed() // emited when popup closed but still visible
    signal timeoutClosed(); // killed by timeout


    function restartDestroyTimer() {
        destroyTimer.restart();
    }

    function shadowDestroy() {
        if (popupItem._closed) {
            return;
        }

        popupItem._closed = true;
        destroyTimer.stop();
        popupItem.closed();
    }

    function anywhereClickDestroy() {
        if (popupItem._closed) {
            return;
        }

        popupItem.anywhereClicked();
        popupItem.shadowDestroy();
    }

    function timeoutDestroy() {
        if (popupItem._closed) {
            return;
        }

        popupItem.timeoutClosed();
        popupItem.shadowDestroy();
    }

    opacity: 0
    width: 240
    height: 92

    Timer {
        id: destroyTimer

        running: destroyInterval > 0 && isShown && (keepIfActive ? !containsMouse : true)
        interval: destroyInterval
        onTriggered: popupItem.timeoutDestroy()
    }

    Window {
        id: window

        color: "#00000000"
        visible: popupItem.visible
        x: popupItem.x
        y: popupItem.y
        width: popupItem.width
        height: popupItem.height
        flags: Qt.Window | Qt.FramelessWindowHint | Qt.Tool | Qt.WindowMinimizeButtonHint
               | Qt.WindowMaximizeButtonHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint

        MouseArea {
            id: mouseArea

            hoverEnabled: true
            anchors.fill: parent
            onClicked: popupItem.anywhereClickDestroy();
        }

        Item {
            id: container

            opacity: popupItem.opacity

            width: popupItem.width
            height: popupItem.height

            Behavior on height {
                NumberAnimation {
                    duration: 250
                }
            }
        }

        // block double close
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            hoverEnabled: true
            visible: popupItem._closed
        }
    }
}
