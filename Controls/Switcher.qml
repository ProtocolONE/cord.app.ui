import QtQuick 1.1
import "./Switcher.js" as Js

Item {
    default property alias child: stash.data

    function switchTo(nextItem) {
        nextItem.visible = 1;

        if (!Js.currentItem) {
            Js.currentItem = nextItem;
            Js.currentItem.parent = bottomLayer;
            return;
        }

        topLayer.opacity = 1;

        Js.previousItem = Js.currentItem;
        Js.previousItem.parent = topLayer;

        Js.currentItem = nextItem;
        Js.currentItem.parent = bottomLayer;

        switchAnimation.start();
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

        ParallelAnimation {
            PropertyAnimation {
                target: topLayer
                property: "opacity"
                to: 0
                duration: 300
            }
        }

        ScriptAction {
            script: {
                Js.previousItem.parent = stash;
                Js.previousItem.visible = false;
                Js.previousItem = null;
            }
        }
    }
}
