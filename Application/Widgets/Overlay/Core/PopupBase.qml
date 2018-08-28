import QtQuick 2.4
import "./Popup.js" as TrayPopup

Item {
    id: popupItem

    property alias containsMouse: mouseArea.containsMouse
    property bool isShown: false
    property bool keepIfActive: false
    property int destroyInterval: 0

    property bool _closed: false

    signal anywhereClicked()
    signal closed()
    signal timeoutClosed();

    function restartDestroyTimer() {
        destroyTimer.restart();
    }

    function shadowDestroy() {
        if (popupItem._closed) {
            return;
        }

        popupItem._closed = true;

        closeAnimation.start();
    }

    function anywhereClickDestroy() {
        if (popupItem._closed) {
            return;
        }

        destroyTimer.stop();
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
        onClicked: popupItem.anywhereClickDestroy();
    }

    Timer {
        id: destroyTimer

        running: destroyInterval > 0 && isShown && (keepIfActive ? !containsMouse : true)
        interval: destroyInterval
        onTriggered: popupItem.timeoutDestroy();
    }
}
