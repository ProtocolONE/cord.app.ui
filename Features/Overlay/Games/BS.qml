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

    property bool charInfoLoaded: false
    property bool showLoadingCharWindow: over.bsGameState == "CharSelect" && !over.charInfoLoaded
    property bool loadingCharTooLong: false

    property bool isDemonion: false
    property int charCount: -1

    function setBsGameState(bsState) {
        over.bsGameState = bsState;
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
    }

    onCustomMessage: {
        // HACK ближе к лайву возможно убрать или частично убрать.
        // console.log('Overlay custom message ', name, arg);

        var handlers = {
            'BSCreateWindow': over.onBsWindowCreate,
            'BSDestroyWindow': over.onBsWindowDestroy,
            'BSNetworkPacket': over.onBSNetworkPacket
        }

        if (handlers.hasOwnProperty(name)) {
            handlers[name](name, arg);
        } else {
            console.log('Unhandled message ', name, arg);
        }
    }

    Component.onDestruction: over.setBlockInput('BS', Overlay.None);

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
            source: installPath + "/Assets/Images/GameOverlay/BS/charactersLoading.gif"
        }

        AnimatedImage {
            visible: over.showLoadingCharWindow && over.loadingCharTooLong
            anchors { centerIn: parent }
            playing: true
            source: installPath + "/Assets/Images/GameOverlay/BS/charactersLoadingFail.gif"
        }

        Image {
            visible: over.isDemonion
                     && over.bsGameState == "CharSelect"
                     && over.charInfoLoaded
                     && over.charCount == 0
            anchors.centerIn: parent
            source: installPath + "/Assets/Images/GameOverlay/BS/event_only.png"
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

            source: installPath + "/Assets/Images/GameOverlay/BS/no_char.png"

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
    }
}

