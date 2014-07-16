import QtQuick 1.1
import "./Switcher.js" as Js

Item {
    id: root

    property bool forceFocus: false

    default property alias child: stash.data

    signal switchFinished();

    function switchTo(nextItem) {
        nextItem.visible = 1;

        if (root.forceFocus) {
            nextItem.forceActiveFocus();
        }

        if (!Js.currentItem) {
            Js.currentItem = nextItem;
            Js.currentItem.parent = bottomLayer;
            root.switchFinished();
            return;
        }

        topLayer.opacity = 1;

        Js.previousItem = Js.currentItem;
        Js.previousItem.parent = topLayer;

        Js.currentItem = nextItem;
        Js.currentItem.parent = bottomLayer;

        switchAnimation.restart();
    }

    Item {
        id: stash

        clip: true
        visible: false
    }

    Item {
        id: bottomLayer

        anchors.fill: parent
    }

    Item {
        id: topLayer

        anchors.fill: parent
    }

    SequentialAnimation {
        id: switchAnimation

        PropertyAnimation {
            target: topLayer
            property: "opacity"
            easing.type: Easing.OutQuart
            to: 0
            duration: 250
        }

        ScriptAction {
            script: {
                Js.previousItem.parent = stash;
                Js.previousItem.visible = false;
                Js.previousItem = null;
                root.switchFinished();

                showNext.start();
            }
        }
    }

    // INFO Используется для обхода ошибки рендера. Если код из таймера выполнить в анимации, то до следующего repaint
    // на сцене будут артефакты.
     // Альтернативынй варинт что-то отрисовать  ненадолго
    Timer {
        id: showNext

        interval: 1
        running: false
        repeat: false
        onTriggered: {
//            Js.previousItem.parent = stash;
//            Js.previousItem.opacity = 0;
//            Js.previousItem.visible = false;
//            Js.previousItem = null;
//            root.switchFinished();

            hack.visible = true;
            hack.visible = false;
        }
    }

    Rectangle {
        id: hack

        color: "#00000000"
        visible: false;
        anchors.fill: parent
    }

}
