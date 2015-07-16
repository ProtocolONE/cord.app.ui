/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
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
    }

    function activateWidget(widgetName, widgetView, popupId) {
        Tooltip.releaseAll();

        d.widgetName = widgetName;
        d.widgetView = widgetView;
        d.popupId = popupId;

        firstContainer.force(d.widgetName, d.widgetView);
        root.open(d.widgetName, d.widgetView, d.popupId);
    }

    function init(layer) {
        root.parent = layer;
    }

    function show(widgetName, view, priority) {
       Js._queue.push({widgetName: widgetName, view: view || '', priority: priority || 0, popupId: ++d._internalPopupId});
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

        root.activateWidget(_currentWidget.widgetName, _currentWidget.view, _currentWidget.popupId);
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
        property int popupId

        function privateClose() {
            //Clean up here
            firstContainer.clear();
        }
    }

    SequentialAnimation {
        id: hideWidgetAnimation

        PropertyAction { target: outerMouser; property: "visible"; value: false }
        ParallelAnimation {
            PropertyAnimation { target: firstContainer; property: "opacity"; from: 1; to: 0; duration: 200 }
            PropertyAnimation { target: substrate; property: "opacity"; from: 1; to: 0; duration: 200 }
        }

        ScriptAction {
            script: {
                firstContainer.clear();
                firstContainer.reset();
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

        ParallelAnimation {
            PropertyAnimation { target: firstContainer; property: "opacity"; from: 0; to: 1; duration: 200 }
            PropertyAnimation { target: substrate; property: "opacity"; from: 0; to: 1; duration: 200 }
        }
        PropertyAction { target: outerMouser; property: "visible"; value: true }
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.9
        color: Styles.applicationBackground
    }

    CursorMouseArea {
        id: outerMouser

        visible: false
        anchors.fill: parent
        hoverEnabled: true
        cursor: Qt.ArrowCursor
        onClicked: {
            d.widgetName = '';
            hideWidgetAnimation.start();
        }
    }

    Rectangle {
        id: substrate

        anchors.centerIn: parent
        color: '#071928'

        width: firstContainer.width
        height: firstContainer.height

        Behavior on width {
             NumberAnimation { duration: 125 }
        }

        Behavior on height {
             NumberAnimation { duration: 125 }
        }

        CursorMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursor: Qt.ArrowCursor
        }
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
                    script: d.privateClose()
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
