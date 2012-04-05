// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/PopupHelper.js" as PopupHelper

Item {
    id: popupItem

    property bool isShown: false
    property int destroyInterval: 0

    signal anywhereClicked();
    signal closed();

    property alias containsMouse: mouser.containsMouse

    function shadowDestroy() {
        closeAnimation.start();
    }

    function startFadeIn() {
        fadeInAnimation.start();
    }

    function forceDestroy() {
        anywhereClicked();
        shadowDestroy();
    }

    opacity: 0
    transform: [
        Rotation { angle: 180; },
        Translate { y:height }
    ]

    width: 211
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
        onCompleted: {
            popupItem.destroy()
            PopupHelper.destroy(popupItem);
            closed();
        }
    }

    MouseArea {
        id: mouser
        hoverEnabled: true
        anchors.fill: parent
        onClicked: forceDestroy()
    }

    Timer {
        running: destroyInterval > 0 && isShown
        interval: destroyInterval
        onTriggered: shadowDestroy();
    }
}
