pragma Singleton

import QtQuick 2.4
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Core 1.0

import "./MessageBox.js" as Js

Item {
    id: root

    property MessageBoxButtons button: MessageBoxButtons{}
    property alias isShown: root.visible

    signal close()
    signal viewReady();
    signal blink();

    function init(layer) {
        root.parent = layer;
    }

    function buttonNames() {
        return Js.buttonNames;
    }

    function setButtonNames(value) {
        Js.buttonNames = value;
    }

    function hide() {
        root.state = "close";
    }

    function activateWidget(widgetName, widgetView) {
        App.activateWindow();

        d.widgetName = widgetName;
        d.widgetView = widgetView || '';

        if (root.isShown) {
            hideWidgetAnimation.start();
        } else {
            container.force(d.widgetName, d.widgetView);
        }
    }


    function registerModel(model) {
        Js._model = model;
        Js._model.callback.connect(function(button) {
            var callback = Js._currentWidget.callback;

            Js._currentWidget = null;
            if (callback) {
                callback(button);
            }
            refresh();
        });
    }

    function show(message, text, buttons, callback) {
        Js._queue.push({id: Js._messageId++, message: message, text: text, buttons: buttons, callback: callback});
        if (!root.isShown && !Js._currentWidget) {
            refresh();
        }
    }

    function refresh() {
        if (Js._queue.length == 0) {
            root.hide();
            return;
        }

        Js._currentWidget = Js._queue.shift();
        root.activateWidget('AlertAdapter');
    }

    onClose: root.refresh();
    onViewReady: Js._model.activate(Js._currentWidget);
    onBlink: Js._model.blink();

    opacity: 0
    anchors.fill: parent
    visible: false

    QtObject {
        id: d

        property variant widgetName
        property variant widgetView

        function privateClose() {
            //Clean up here
            container.clear();
        }
    }

    SequentialAnimation {
        id: hideWidgetAnimation

        PropertyAction { target: outerMouser; property: "visible"; value: false }

        ParallelAnimation {
            PropertyAnimation { target: container; property: "opacity"; from: 1; to: 0; duration: 250 }
            PropertyAnimation { target: substrate; property: "opacity"; from: 1; to: 0; duration: 250 }
        }

        ScriptAction { script: container.clear() }

        onStopped: container.force(d.widgetName, d.widgetView);
    }

    SequentialAnimation {
        id: showWidgetAnimation

        ParallelAnimation {
            PropertyAnimation { target: container; property: "opacity"; from: 0; to: 1; duration: 250 }
            PropertyAnimation { target: substrate; property: "opacity"; from: 0; to: 1; duration: 250 }
        }

        PropertyAction { target: outerMouser; property: "visible"; value: true }
    }

    MouseArea {
        visible: true
        anchors.fill: parent
    }

    CursorMouseArea {
        id: outerMouser

        visible: false
        anchors.fill: parent
        hoverEnabled: true
        cursor: Qt.ArrowCursor
        onClicked: root.blink();
    }

    Item {
        id: substrate

        property int saveX: 0
        property int saveY: 0

        property int saveWindowX: 0
        property int saveWindowY: 0

        x: container.x
        y: container.y

        width: container.width
        height: container.height

        MouseArea {
            anchors.fill: parent

            function startDrag(mouse) {
                var coord = mapToItem(root, mouse.x, mouse.y);

                substrate.saveX = coord.x;
                substrate.saveY = coord.y;

                substrate.saveWindowX = container.x;
                substrate.saveWindowY = container.y;
            }

            onPressed: startDrag(mouse);

            onPositionChanged: {
                var coord = mapToItem(root, mouse.x, mouse.y),
                    newCoordX = substrate.saveWindowX + (coord.x - substrate.saveX),
                    newCoordY = substrate.saveWindowY + (coord.y - substrate.saveY);

                if (newCoordX + container.width < 20 ||
                    newCoordY + container.height < 20 ||
                    newCoordX > (root.width - 20) ||
                    newCoordY > (root.height - 20)) {
                    startDrag(mouse);
                    return;
                }

                container.x = newCoordX;
                container.y = newCoordY;
            }
        }
    }

    WidgetContainer {
        id: container

        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2

        width: viewInstance ? viewInstance.width : 0
        height: viewInstance ? viewInstance.height : 0

        function resetCoord() {
            container.x = parent.width / 2 - width / 2;
            container.y = parent.height / 2 - height / 2;
        }

        onViewReady: {
            root.viewReady();
            showWidgetAnimation.start();
            resetCoord();

            //UNDONE
            if (!root.isShown) {
                root.state = "open";
            }

            viewInstance.close.connect(function() {
                root.close();
            });
        }
    }

    transitions: [
        Transition {
            from: "*"
            to: "open"

            SequentialAnimation {
                PropertyAction { target: root; property: "visible"; value: true }
                PropertyAnimation { target: root; property: "opacity"; duration: 150 }
                PropertyAction { target: outerMouser; property: "visible"; value: true }
            }
        },
        Transition {
            from: "*"
            to: "close"

            SequentialAnimation {
                PropertyAction { target: outerMouser; property: "visible"; value: false }
                PropertyAnimation { target: root; property: "opacity"; duration: 150 }
                PropertyAction { target: root; property: "visible"; value: false }

                ScriptAction {
                    script: {
                        d.privateClose()
                        root.refresh();
                    }
                }
            }
        }
    ]

    states: [
        State {
            name: "open"
            PropertyChanges { target: root; opacity: 1 }
        },
        State {
            name: "close"
            PropertyChanges { target: root; opacity: 0 }
        }
    ]
}
