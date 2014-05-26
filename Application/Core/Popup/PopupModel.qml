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

Item {
    id: root

    signal close()

    property alias isShown: root.visible

    function hide() {
        root.state = "close";
    }

    function activateWidget(widgetName, widgetView) {
        d.widgetName = widgetName;
        d.widgetView = widgetView;

        firstContainer.force(d.widgetName, d.widgetView);
    }

    anchors.fill: parent
    opacity: 0
    visible: false

    QtObject {
        id: d

        property variant widgetName
        property variant widgetView

        function tryShowHelp() {
            var isFirstShow = Settings.value("qml/core/popup/", "isHelpShowed", 0) == 0;
            if (isFirstShow) {
                showHelp.start();
            }
        }

        function privateClose() {
            //Clean up here
            firstContainer.clear();
        }
    }

    SequentialAnimation {
        id: hideWidgetAnimation

        PropertyAction { target: outerMouser; property: "visible"; value: false }
        PropertyAction { target: helpImage; property: "visible"; value: false }

        ParallelAnimation {
            PropertyAnimation { target: firstContainer; property: "opacity"; from: 1; to: 0; duration: 200 }
            PropertyAnimation { target: substrate; property: "opacity"; from: 1; to: 0; duration: 200 }
        }

        ScriptAction { script: firstContainer.clear(); }

        onCompleted: {
            if (d.widgetName == '') {
                root.close();
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

            PropertyAnimation { target: substrate; property: "width"; to: firstContainer.width; duration: 125 }
            PropertyAnimation { target: substrate; property: "height"; to: firstContainer.height; duration: 125 }
        }

        ScriptAction { script: d.tryShowHelp(); }
        PropertyAction { target: outerMouser; property: "visible"; value: true }
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.9
        color: '#071928'
    }

    MouseArea {
        id: outerMouser

        visible: false
        anchors.fill: parent
        onClicked: {
            d.widgetName = '';
            hideWidgetAnimation.start();
        }
    }

    Rectangle {
        id: substrate

        anchors.centerIn: parent
        color: '#f0f5f8'

        MouseArea {
            anchors.fill: parent
        }
    }

    WidgetContainer {
        id: firstContainer

        anchors.centerIn: parent
        width: viewInstance ? viewInstance.width : 0
        height: viewInstance ? viewInstance.height : 0

        onViewReady: {
            showWidgetAnimation.start();

            if (!root.isShown) {
                root.state = "open";
            }

            viewInstance.close.connect(function() {
                root.close();
            });
        }
    }

    Image {
        anchors { left: firstContainer.right; top: firstContainer.top; leftMargin: 20; topMargin: -35}

        source: installPath + '/images/Popup/close.png'
    }

    Image {
        id: helpImage

        anchors { left: firstContainer.right; top: firstContainer.top; leftMargin: -5; topMargin: -75}
        source: installPath + '/images/Popup/popupInfoHelpText.png'

        SequentialAnimation {
            id: showHelp

            onCompleted: Settings.setValue("qml/core/popup/", "isHelpShowed", 1);

            PauseAnimation { duration: 1000 }
            PropertyAction { target: helpImage; property: "visible"; value: true }
            PropertyAnimation { target: helpImage; property: "opacity"; from: 0; to: 1; duration: 150 }
        }

        Text {
            anchors {
                left: parent.left
                top: parent.bottom
                leftMargin: 15
            }

            text: qsTr("POPUP_HELP_HINT_TEXT")
            width: 158
            height: 150
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            font { family: 'Arial'; pixelSize: 12 }
            color: '#89bd5f'
        }
    }

    transitions: [
        Transition {
            from: "*"
            to: "open"

            PropertyAction { target: helpImage; property: "visible"; value: false }
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
                PropertyAction { target: helpImage; property: "visible"; value: false }

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
