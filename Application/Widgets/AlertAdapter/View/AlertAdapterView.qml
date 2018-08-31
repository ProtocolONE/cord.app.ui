import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0 as Controls

import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.MessageBox 1.0

import "./AlertAdapter.js" as AlertAdapter


WidgetView {
    id: alertModule

    width: 130 + Math.max(controlRowId.width, 510)
    height: 50 + 30 + Math.max(mainAlertText.height, infoImage.height) + 30 + controlRowId.height + 30

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

            for (var button in MessageBox.buttonNames()) {
                if ((message.buttons & button) == button) {
                    ++buttonCount;
                    d.addButton(d.buttonType(button), button);
                }
            }

            if (buttonCount == 0) {
                d.addButton(positiveButton, MessageBox.button.ok);
            }
        }
    }

    QtObject {
        id: d

        function addButton(component, button) {
            var obj = component.createObject(controlRowId);

            obj.text = MessageBox.buttonNames()[button];
            obj.buttonId = button;

            obj.buttonClick.connect(function(button) {
                model.callback(button);
            });

            alertModule.close.connect(obj.destroy);
        }

        function buttonType(button) {
            switch (+button) {
            case MessageBox.button.cancel:
            case MessageBox.button.discard:
            case MessageBox.button.no:
            case MessageBox.button.noToAll:
                return negativeButton;
            case MessageBox.button.support:
                return normalButton;
            default:
                return positiveButton;
            }
        }
    }

    Component {
        id: normalButton

        NormalButton {}
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
    }

    Rectangle {
        color: Styles.messageBoxBackground
        anchors.fill: parent
        border.color: Styles.messageBoxBorder
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
            margins: 50
        }
        height: parent.height
        spacing: 30

        Item {
            height: 50
            anchors {
                left: parent.left
                right: parent.right
            }

            Text {
                id: headerText

                anchors {
                    baseline: parent.top
                    baselineOffset: 50
                }
                width: parent.width
                font { family: "Arial"; pixelSize: 20 }
                elide: Text.ElideRight
                color: Styles.messageBoxHeaderText
                smooth: true
                text: "this fix qml bug with empty Text tag dimensions"
            }
        }

        Row {
            spacing: 10
            anchors {
                left: parent.left
                right: parent.right
            }

            Image {
                id: infoImage

                source: installPath + '/Assets/Images/Application/Widgets/AlertAdapter/info.png'
            }

            Text {
                id: mainAlertText

                width: parent.width - infoImage.width
                font { family: "Arial"; pixelSize: 14 }
                wrapMode: Text.Wrap
                color: Styles.messageBoxText
                smooth: true
                textFormat: Text.StyledText
                linkColor: Styles.linkText
                onLinkActivated: App.openExternalUrl(link)
            }
        }

        Row {
            id: controlRowId

            spacing: 10
            height: 47
        }
    }
}
