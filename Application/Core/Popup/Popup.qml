pragma Singleton

import QtQuick 2.4
import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core.Styles 1.0

import "./Popup.js" as Js

Item {
    id: root

    signal open(string widgetName, string widgetView, int popupId)
    signal close(int popupId)

    property alias isShown: root.visible

    function hide() {
        root.state = "close";
        root.visible = false;
    }

    function activateWidget(widgetName, widgetView, popupId, widgetPage) {
        Tooltip.releaseAll();

        d.widgetName = widgetName;
        d.widgetView = widgetView;
        d.popupId = popupId;
        d.widgetPage = widgetPage;

        firstContainer.force(d.widgetName, d.widgetView, d.widgetPage);
        root.open(d.widgetName, d.widgetView, d.popupId);
    }

    function init(layer) {
        root.parent = layer;
    }

    function show(widgetName, view, priority, wpage) {
       Js._queue.push({widgetName: widgetName, view: view || '', priority: priority || 0, popupId: ++d._internalPopupId, wpage : wpage || ''});
       Js._queue.sort(function(a, b){
            if (a.priority < b.priority) {
                return 1;
            }
            if (a.priority == b.priority) {
                return 0;
            }
            return -1;
        });

        if (!root.isShown) {
            refresh();
        }

        return d._internalPopupId;
    }

    function refresh() {
        if (Js._queue.length == 0) {
            root.hide();
            return;
        }

        var _currentWidget = Js._queue.shift();

        root.activateWidget(_currentWidget.widgetName, _currentWidget.view, _currentWidget.popupId, _currentWidget.wpage);
    }

    function isPopupOpen() {
        return root.isShown;
    }

    function signalBus() {
        return root;
    }

    anchors.fill: parent
    opacity: 0
    visible: false

    onClose: root.refresh();

    QtObject {
        id: d

        property int _internalPopupId: 0

        property variant widgetName
        property variant widgetView
        property variant widgetPage

        property int popupId

        function privateClose() {
            //Clean up here
            firstContainer.clear();
        }
    }

    SequentialAnimation {
        id: hideWidgetAnimation

        ParallelAnimation {
            PropertyAnimation { target: firstContainer; property: "opacity"; from: 1; to: 0; duration: 200 }
        }

        ScriptAction {
            script: {
                firstContainer.clear();
                firstContainer.reset();
                outerMouserLockTimer.stop();
            }
        }

        onStopped: {
            if (d.widgetName == '') {
                root.close(d.popupId);
                return;
            }

            firstContainer.force(d.widgetName, d.widgetView);
        }
    }

    SequentialAnimation {
        id: showWidgetAnimation

        PropertyAction { target: outerMouser; property: "locked"; value: true }
        ParallelAnimation {
            PropertyAnimation { target: firstContainer; property: "opacity"; from: 0; to: 1; duration: 200 }
        }
        ScriptAction {
            script: outerMouserLockTimer.restart();
        }
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.9
        color: Styles.applicationBackground
    }

    MouseArea {
        id: outerMouser

        property bool locked: true

        acceptedButtons: Qt.AllButtons
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor
        onClicked: {
            if (locked) {
                return;
            }

            locked = true;
            d.widgetName = '';
            hideWidgetAnimation.start();
        }

        Timer {
            id: outerMouserLockTimer

            interval: 250
            running: false
            repeat: false
            onTriggered: outerMouser.locked = false;
        }
    }

    MouseArea {
        anchors.centerIn: parent
        width: firstContainer.width
        height: firstContainer.height
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor
        visible: firstContainer.opacity > 0
        acceptedButtons: Qt.LeftButton | Qt.RightButton
    }

    WidgetContainer {
        id: firstContainer

        anchors.centerIn: parent
        onViewReady: {
            showWidgetAnimation.start();

            if (!root.isShown) {
                root.state = "open";
            }

            viewInstance.forceActiveFocus();
            viewInstance.close.connect(function() {
                root.close(d.popupId);
            });

            firstContainer.sendGoogleAnalalitics(firstContainer.view, "show");            
        }
    }

    transitions: [
        Transition {
            from: "*"
            to: "open"

            SequentialAnimation {
                PropertyAction { target: root; property: "visible"; value: true }
                PropertyAnimation { target: root; property: "opacity"; duration: 150 }                
            }
        },
        Transition {
            from: "*"
            to: "close"

            SequentialAnimation {
                PropertyAnimation { target: root; property: "opacity"; duration: 150 }
                ScriptAction {
                    script: d.privateClose()
                }
                PropertyAction { target: outerMouser; property: "locked"; value: true }
                PropertyAction { target: root; property: "visible"; value: false }
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
