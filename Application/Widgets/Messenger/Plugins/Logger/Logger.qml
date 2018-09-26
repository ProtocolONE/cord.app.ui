import QtQuick 2.4
import QtQuick.Window 2.2

import Tulip 1.0
import QXmpp 1.0

import ProtocolOne.Controls 1.0

import "pretty-data.js" as Pd

Item {
    function logMessage(type, message) {
        if (!message.trim()) {
            return;
        }

        var rawMessage = {type: 0, text: Pd.pd.xml(message)};

        switch(type) {
        case QmlQXmppLogger.ReceivedMessage: rawMessage.type = 1; break;
        case QmlQXmppLogger.SentMessage: rawMessage.type = 0; break;
        default:
            //INFO Debug reasons use console.log('XmppLog: ', type, message);
            return;
        }

        if (logModel.count > 5000) {
            logModel.remove(0);
        }
        logModel.append(rawMessage);
    }

    ListModel {
        id: logModel
    }

    Shortcut {
        key: "Ctrl+Shift+L"
        onActivated: {
            content.sourceComponent = windowCmp
        }
    }

    Component {
        id: windowCmp

        Window {
            id: root

            width: Desktop.screenWidth - 50
            height: Desktop.screenHeight - 50
            visible: true

            onClosing: content.sourceComponent = null;

            Connections {
                target: logModel
                onItemsInserted: {
                    if (autoScrollEnable.checked) {
                       logView.positionViewAtEnd();
                    }
                }
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
    }

    Loader {
        id: content
    }
}
