import QtQuick 1.1
import Tulip 1.0
import QXmpp 1.0

import GameNet.Controls 1.0

import "vkbeautify.0.99.00.beta.js" as Vkbeautify
import "pretty-data.js" as Pd

Window {
    id: root

    width: 1680
    height: 1050
    visible: true

    function logMessage(type, message) {
        if (!message.trim()) {
            return;
        }

        switch(type) {
        case QmlQXmppLogger.ReceivedMessage:
            d.onRecv(message);
            break;

        case QmlQXmppLogger.SentMessage:
            d.onSend(message);
            break;

        default:
            //console.log('XmppLog: ', type, message);
            break;
        }
    }

    QtObject {
        id: d

        function pritty(xml) {
            return Pd.pd.xml(xml);
            //return Vkbeautify.beautify.xml(xml) || xml;
        }

        function rawMessage() {
            return {
                type: 0,
                text: ""
            }
        }

        function onSend(message) {
            var msg = d.rawMessage();
            msg.type = 0; // send
            msg.text = d.pritty(message);
            d.append(msg);
        }

        function onRecv(message) {
            var msg = d.rawMessage();
            msg.type = 1; // send
            msg.text = d.pritty(message);
            d.append(msg);
        }

        function append(msg) {
            logModel.append(msg);
            if (autoScrollEnable.checked) {
                logView.positionViewAtEnd();
            }
        }
    }

    ListModel {
        id: logModel
    }

    Rectangle {
        anchors.fill: parent
        color: "black"

        Item {
            width: parent.width
            height: 20

            Row {
                anchors.fill: parent
                spacing: 5

                CheckBox {
                    id: autoScrollEnable

                    text: "AutoScroll"
                    checked: true
                }

                Button {
                    width: 100
                    height: 20
                    text: "Clear"
                    onClicked: logModel.clear()
                }
            }
        }

        ListView {
            id: logView

            anchors {
                fill: parent
                topMargin: 25
            }
            clip: true
            model: logModel
            spacing: 5
            delegate: Rectangle {
                color: "#222222"
                width: logView.width
                height: logMessageText.height + 10

                TextEdit {
                    id: logMessageText

                    color: model.type == 0 ? 'green' : 'cyan'

                    width: parent.width
                    readOnly: true
                    text: model.text
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    textFormat: TextEdit.PlainText
                    font {
                        pixelSize: 14
                        family: "Consolas"
                    }
                }
            }
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_End) {
                logView.positionViewAtEnd();
            }

            if (event.key == Qt.Key_Home) {
                logView.positionViewAtBeginning();
            }
        }
    }
}
