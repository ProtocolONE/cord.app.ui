/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import "./Popup.js" as Popup
import "./App.js" as App

Item {
    id: root

    property alias isShown: root.visible

    signal close()
    signal viewReady();
    signal blink();


    function hide() {
        root.state = "close";
    }

    function activateWidget(widgetName, widgetView) {
        App.activateWindow();

        d.widgetName = widgetName;
        d.widgetView = widgetView;

        if (root.isShown) {
            hideWidgetAnimation.start();
        } else {
            container.force(d.widgetName, d.widgetView);
        }
    }

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

        ScriptAction { script: container.clear(); }

        onCompleted: container.force(d.widgetName, d.widgetView);
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

    MouseArea {
        id: outerMouser

        visible: false
        anchors.fill: parent
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
