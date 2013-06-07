import QtQuick 1.1
import "../Elements" as Elements
import "../js/Core.js" as Core

Item {
    id: page

    implicitWidth: Core.clientWidth
    implicitHeight: Core.clientHeight

    default property alias content: mainContainer.data
    property int openHeight: 300
    property real openBackgroundOpacity: 0.5
    property bool isOpen: false;
    property bool isInProgress: false

    signal finishOpening();
    signal finishClosing();
    signal startClosing();

    signal backgroundMousePressed(int mouseX, int mouseY);
    signal backgroundMousePositionChanged(int mouseX, int mouseY);

    function switchAnimation() {
        if (openBlockAnimation.running || closeBlockAnimation.running)
            return;

        if (isOpen)
            closeBlockAnimation.start();
        else
            openBlockAnimation.start();
    }

    function openMoveUpPage() {
        if (!isOpen)
            openBlockAnimation.start();
    }

    function closeMoveUpPage() {
        if (isOpen) {
            startClosing();
            closeBlockAnimation.start();
        }
    }

    Rectangle {
        id: backGroundShadow

        color: "#000000"
        opacity: 0;
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true
            onPressed: backgroundMousePressed(mouseX, mouseY);
            onPositionChanged: {
                if (pressedButtons & Qt.LeftButton === Qt.LeftButton) {
                    backgroundMousePositionChanged(mouseX, mouseY);
                }
            }
        }
    }

    Item {
        id: mainContainer
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    }

    SequentialAnimation {
        id: openBlockAnimation;

        ParallelAnimation {
            NumberAnimation {
                target: mainContainer;
                property: "height";
                easing.type: Easing.InQuad;
                from: 0;
                to: openHeight;
                duration: 350;
            }

            NumberAnimation {
                target: backGroundShadow;
                property: "opacity";
                from: 0;
                to: openBackgroundOpacity;
                duration: 350;
            }
        }

        onStarted: {
            visible = true;
            isOpen = true;
        }

        onCompleted: finishOpening();
    }

    SequentialAnimation {
        id: closeBlockAnimation;

        ParallelAnimation {
            NumberAnimation {
                target: backGroundShadow;
                property: "opacity";
                from: openBackgroundOpacity;
                to: 0;
                duration: 350;
            }

            NumberAnimation {
                target: mainContainer;
                property: "height";
                easing.type: Easing.InQuad;
                from: openHeight;
                to: 0;
                duration: 350;
            }
        }

        onStarted: isOpen = false;
        onCompleted: {
            visible = false;
            finishClosing();
        }
    }

    Elements.WorkInProgress {
        active: page.isInProgress
        interval: 150
    }
}
