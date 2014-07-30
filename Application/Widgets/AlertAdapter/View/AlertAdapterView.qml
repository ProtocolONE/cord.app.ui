/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0 as Controls

import "../../../Core/MessageBox.js" as MessageBox
import "../../../Core/App.js" as App
import "../../../Core/Styles.js" as Styles

import "./AlertAdapter.js" as AlertAdapter


WidgetView {
    id: alertModule

    width: 130 + Math.max(controlRowId.width, 460)
    height: 170 + Math.max(mainAlertText.height, 60)

    Connections {
        target: model

        onBlink: {
            if (blinkAnimation.running) {
                return;
            }

            blinkAnimation.start();
        }

        onDisplayView: {
            var buttonCount = 0;

            mainAlertText.text = message.text;
            headerText.text = message.message;

            for (var button in MessageBox.buttonNames) {
                if ((message.buttons & button) == button) {
                    if (d.isPositiveButton(button)) {
                        ++buttonCount;
                        d.addButton(positiveButton, button);
                    }
                }
            }

            for (var button in MessageBox.buttonNames) {
                if ((message.buttons & button) == button) {
                    if (!d.isPositiveButton(button)) {
                        ++buttonCount;
                        d.addButton(negativeButton, button);
                    }
                }
            }

            if (buttonCount == 0) {
                d.addButton(positiveButton, MessageBox.button.Ok);
            }
        }
    }

    QtObject {
        id: d

        function addButton(component, button) {
            var obj = component.createObject(controlRowId);

            obj.text = MessageBox.buttonNames[button];
            obj.buttonId = button;

            obj.buttonClick.connect(function(button) {
                model.callback(button);
            });

            alertModule.close.connect(obj.destroy);
        }

        function isPositiveButton(button) {
            switch (+button) {
            case MessageBox.button.Cancel:
            case MessageBox.button.Discard:
            case MessageBox.button.No:
            case MessageBox.button.NoToAll:
                return false;
            }

            return true;
        }
    }

    Component {
        id: negativeButton

        NegativeButton {}
    }

    Component {
        id: positiveButton

        PositiveButton {}
    }

    SequentialAnimation {
        id: blinkAnimation

        loops: 5

        PropertyAnimation { target: shadowBorder; property: "opacity"; from: 0.8; to: 0; duration: 50 }
        PauseAnimation { duration: 25 }
        PropertyAnimation { target: shadowBorder; property: "opacity"; from: 0; to: 0.8; duration: 100 }
    }

    Item {
        id: shadowBorder

        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        opacity: 0.8

        BorderImage {
            anchors {
                fill: parent
                margins: -9
            }
            border {
                left: 10
                top: 10;
                right: 10
                bottom: 10
            }
            source: installPath + "Assets/Images/Application/Widgets/AlertAdapter/shadow.png";
            smooth: true
        }

        Rectangle { anchors.fill: parent; color: Styles.style.messageBoxShadowBorder }
    }

    Rectangle {
        color: Styles.style.messageBoxBackground
        width: parent.width
        height: parent.height

        Text {
            id: headerText

            anchors {
                top: parent.top
                topMargin: 20
                left: parent.left
                leftMargin: 20
            }
            width: parent.width - 40
            font { family: "Arial"; pixelSize: 20 }
            elide: Text.ElideRight
            color: Styles.style.messageBoxHeaderText
            smooth: true
        }

        Rectangle {
            anchors {
                top: parent.top
                topMargin: 55
            }
            width: parent.width
            height: 1
            color: Qt.lighter(Styles.style.messageBoxBackground, Styles.style.lighterFactor)
        }

        Text {
            id: mainAlertText

            anchors {
                baseline: parent.top
                baselineOffset: 85
                left: parent.left
                right: parent.right
                rightMargin: 20
                leftMargin: 72
            }

            font { family: "Arial"; pixelSize: 14 }
            wrapMode: Text.Wrap
            color: Styles.style.messageBoxText
            smooth: true
            textFormat: Text.RichText
            onLinkActivated: AppJs.openExternalUrl(link)
        }

        Image {
            anchors {
                left: parent.left
                top: mainAlertText.top
                leftMargin: 20
            }

            source: installPath + '/Assets/Images/Application/Widgets/AlertAdapter/info.png'
        }

        Row {
            id: controlRowId

            spacing: 50
            height: 47
            anchors {
                bottom: parent.bottom
                left: parent.left
                margins: 20
                leftMargin: 70
            }
        }

        Rectangle {
            anchors {
                bottom: parent.bottom
                bottomMargin: 88
            }
            width: parent.width
            height: 1
            color: Qt.lighter(Styles.style.messageBoxBackground, Styles.style.lighterFactor)
        }
    }
}
