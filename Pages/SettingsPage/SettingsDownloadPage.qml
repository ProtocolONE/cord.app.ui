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
import qGNA.Library 1.0
import "../../Elements" as Elements

Rectangle {
    id: mainDownloadPageRectangle
    color: "#00000000"

    property variant speedItems:           { "50" : QT_TR_NOOP("50 KByte/s"),
                                             "200" : QT_TR_NOOP("200 KByte/s"),
                                             "500" : QT_TR_NOOP("500 KByte/s"),
                                             "1000" : QT_TR_NOOP("1000 KByte/s"),
                                             "2000" : QT_TR_NOOP("2000 KByte/s"),
                                             "5000" : QT_TR_NOOP("5000 KByte/s"),
                                             "0" : QT_TR_NOOP("Unlimited")
    }

    Component {
        id: componentListBoxDelegate

        Rectangle {
            id: delegateRectangle

            x: 1
            color: componentListBoxDelegateMouseArea.containsMouse ? "#eab46b" : "#FFFFFF"
            width: checkListBoxWidth - 1
            height: 30

            Text {
                height: 18
                x: 9
                y: 5
                text: qsTr(textValue)
                font { family: "Segoe UI Semibold"; bold: false; pixelSize: 14 }
                smooth: true
            }

            Elements.CursorMouseArea {
                id: componentListBoxDelegateMouseArea

                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    itemClicked(shortValue);
                    switchAnimation();
                    buttonCheckListBoxText = qsTr(textValue)
                    settingsViewModel.setDownloadSpeed(shortValue);
                    mainClickText.opacity = 0.8;
                    checkListBoxRectangle.opacity = 0.8;
                }
            }
        }
    }

    Component {
        id: componentListBoxDelegate2

        Rectangle {
            id: delegateRectangle2

            x: 1
            color: componentListBoxDelegate2MouseArea.containsMouse ? "#eab46b" : "#FFFFFF"
            width: checkListBoxWidth - 1
            height: 30

            Text {
                height: 18
                x: 9
                y: 5
                text: qsTr(textValue)

                font { family: "Segoe UI Semibold"; bold: false; pixelSize: 14 }
                smooth: true
            }

            Elements.CursorMouseArea {
                id: componentListBoxDelegate2MouseArea

                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    itemClicked(shortValue);
                    switchAnimation();
                    buttonCheckListBoxText = qsTr(textValue)
                    settingsViewModel.setUploadSpeed(shortValue);
                    mainClickText.opacity = 0.8;
                    checkListBoxRectangle.opacity = 0.8;
                }
            }
        }
    }

    function deactiveAllItems() {
        if (line1.isListActive)
            line1.switchAnimation();
        if (line2.isListActive)
            line2.switchAnimation();
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            deactiveAllItems();
            userInfoBlock.closeMenu();
        }
    }

    function getLeftCoord() {
        return Math.max(Math.max(line1.textWidth,line2.textWidth), Math.max(line3.textWidth,line4.textWidth)) + 20;
    }

    Elements.TextEditArea {
        id: line4

        anchors { top: parent.top; topMargin: 108 }
        width: 393
        checkListBoxX: getLeftCoord()
        checkListBoxWidth: 69
        buttonText: qsTr("LABEL_NUMBER_OF_CONNECTIONS_LIMIT_INPUT")
        buttonCheckListBoxText: settingsViewModel.numConnections
        onTextChanged: settingsViewModel.setNumConnections(text);
        Elements.CursorShapeArea { anchors.fill: parent }
    }

    Elements.TextEditArea {
        id: line3

        anchors { top: parent.top; topMargin: 72 }
        width: 393
        checkListBoxX: getLeftCoord()
        checkListBoxWidth: 69
        buttonText: qsTr("LABEL_PORT_INPUT")
        buttonCheckListBoxText: settingsViewModel.incomingPort
        textInputElement.validator: IntValidator {bottom: 0; top: 65535;}

        onTextChanged: settingsViewModel.setIncomingPort(text);
        Elements.CursorShapeArea { anchors.fill: parent }
    }

    Elements.Button3 {
        id: autoSetButton

        anchors { top: parent.top; left: parent.left; }
        anchors { topMargin: 72; leftMargin: getLeftCoord() + line3.checkListBoxWidth + 7 }
        buttonText: qsTr("BUTTON_PORT_AUTOSET")
        onButtonClicked: line3.buttonCheckListBoxText = Math.floor(Math.random() * 60000) + 1000;
        fontSize: 14
        fontFamily: "Segoe UI Semibold"
    }

    Elements.CheckListBox {
        id: line2

        anchors { top: parent.top; topMargin: 36 }
        width: 393
        checkListBoxX: getLeftCoord()
        checkListBoxWidth: 148
        checkBoxType: true
        buttonText: qsTr("LABEL_UPLOAD_SPEED_LIMIT_INPUT")
        buttonCheckListBoxText: qsTr(speedItems[settingsViewModel.uploadSpeed])
        onListDropped: {
            if (line1.isListActive)
                line1.switchAnimation();
        }

        componentDelegate: componentListBoxDelegate2

        listModel: ListModel {
            ListElement {
                textValue: QT_TR_NOOP("50 KByte/s")
                shortValue: "50"
            }
            ListElement {
                textValue: QT_TR_NOOP("200 KByte/s")
                shortValue: "200"
            }
            ListElement {
                textValue: QT_TR_NOOP("500 KByte/s")
                shortValue: "500"
            }
            ListElement {
                textValue:  QT_TR_NOOP("1000 KByte/s")
                shortValue: "1000"
            }
            ListElement {
                textValue: QT_TR_NOOP("2000 KByte/s")
                shortValue: "2000"
            }
            ListElement {
                textValue: QT_TR_NOOP("5000 KByte/s")
                shortValue: "5000"
            }
            ListElement {
                textValue: QT_TR_NOOP("Unlimited")
                shortValue: "0"
            }
        }

        Elements.CursorShapeArea { anchors.fill: parent }
    }

    Elements.CheckListBox {
        id: line1

        width: 393
        checkListBoxX: getLeftCoord()
        checkListBoxWidth: 148
        checkBoxType: true
        buttonText: qsTr("LABEL_DOWNLOAD_SPEED_LIMIT_INPUT")
        buttonCheckListBoxText: qsTr(speedItems[settingsViewModel.downloadSpeed])
        componentDelegate: componentListBoxDelegate
        onListDropped: {
            if (line2.isListActive)
                line2.switchAnimation();
        }

        listModel: ListModel {
            ListElement {
                textValue: QT_TR_NOOP("50 KByte/s")
                shortValue: "50"
            }
            ListElement {
                textValue: QT_TR_NOOP("200 KByte/s")
                shortValue: "200"
            }
            ListElement {
                textValue: QT_TR_NOOP("500 KByte/s")
                shortValue: "500"
            }
            ListElement {
                textValue:  QT_TR_NOOP("1000 KByte/s")
                shortValue: "1000"
            }
            ListElement {
                textValue: QT_TR_NOOP("2000 KByte/s")
                shortValue: "2000"
            }
            ListElement {
                textValue: QT_TR_NOOP("5000 KByte/s")
                shortValue: "5000"
            }
            ListElement {
                textValue: QT_TR_NOOP("Unlimited")
                shortValue: "0"
            }
        }

        Elements.CursorShapeArea { anchors.fill: parent }
    }
}
