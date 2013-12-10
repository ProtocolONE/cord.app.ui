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
import "../Elements" as Elements
import "." as Blocks

Blocks.MoveUpPage {
    id: page

    signal canceled();

    openHeight: 550

    Rectangle {
        color: "#353945"
        anchors.fill: parent

        /*
        //Use it for debug page. Or write proxy object for licenseModell from c++ mainwindow
        Item {
            id: licenseModel
            property string license: ""
            property string pathToInstall: ""
            Component.onCompleted: openMoveUpPage()

        }
        */

        Connections {
            target: licenseModel
            onOpenLicenseBlock: {
                page.openMoveUpPage();
                licenseModel.setLicenseAccepted(false);
                channelTextArea.flicElement.contentY = 0;
            }

            onCloseLicenseBlock: page.closeMoveUpPage();
        }

        Text {
            width: 230
            font { family: "Arial"; pixelSize: 18 }
            text: qsTr("TITLE_EULA")
            anchors { left: parent.left; top: parent.top; leftMargin: 41; topMargin: 35 }
            wrapMode: Text.WordWrap
            color: "#FFFFFF"
            smooth: true
        }

        Text {
            width: 230
            font { family: "Arial"; pixelSize: 14 }
            text: qsTr("SUBTITLE_EULA")
            anchors { left: parent.left; top: parent.top; leftMargin: 41; topMargin: 121 }
            wrapMode: Text.WordWrap
            color: "#ffff66"
            smooth: true
        }

        Column {
            anchors { left: parent.left; top: parent.top; leftMargin: 276; topMargin: 37 }
            spacing: 20

            Column {
                Rectangle {
                    width: 610
                    height: 290

                    border { color: "#909299"; width: 1 }
                    color: "#00000000"

                    Elements.ScrollBar {
                        id: scrollableChannelTextAreaElement
                        height: parent.height
                        anchors { right: parent.right; top: parent.top}
                        flickable: channelTextArea.flicElement
                    }

                    Elements.TextArea {
                        id: channelTextArea

                        anchors.fill: parent
                        anchors {
                            leftMargin: 5;
                            topMargin: 5;
                            bottomMargin: 5;
                            rightMargin: 5 + scrollableChannelTextAreaElement.width
                        }

                        textElement.text: licenseModel.license
                    }
                }

                Text {
                    color: "#fff"
                    font { family: "Arial"; pixelSize: 12 }
                    text: qsTr("CHECKBOX_I_AGREE")
                }
            }

            Column {
                spacing: 8

                Text {
                    color: "#fff"
                    font { family: "Arial"; pixelSize: 16 }
                    text: qsTr("LABEL_GAME_INSTALLATION_PATH_INPUT")
                }

                Row {
                    spacing: 8

                    Elements.FileInput {
                        width: 407
                        textElement { text: licenseModel.pathToInstall; readOnly: true }
                        onEditTextChanged: licenseModel.setPathToInstall(text);
                    }

                    Elements.Button3 {
                        buttonText: qsTr("BUTTON_BROWSE")
                        onButtonClicked: licenseModel.searchPressed();
                    }
                }

                Row {
                    Elements.CheckBox {
                        state: licenseModel.shurtCutInDesktop ? "Active" : "Normal"
                        onChecked: licenseModel.setShurtCutInDesktop(isChecked);
                        onUnchecked: licenseModel.setShurtCutInDesktop(isChecked);
                    }

                    Text {
                        color: "#fff"
                        font { family: "Arial"; pixelSize: 16 }
                        text: qsTr("CHECKBOX_CREATE_SHORTCUT_ON_DESKTOP")
                    }
                }

                Row {
                    Elements.CheckBox {
                        state: licenseModel.shurtCutInStart ? "Active" : "Normal"
                        onChecked: licenseModel.setShurtCutInStart(isChecked);
                        onUnchecked: licenseModel.setShurtCutInStart(isChecked);
                    }

                    Text {
                        color: "#fff"
                        font { family: "Arial"; pixelSize: 16 }
                        text: qsTr("CHECKBOX_CREATE_SHORTCUT_IN_START_MENU")
                    }
                }

                Row {
                    spacing: 10

                    Elements.Button4 {
                        buttonText: qsTr("BUTTON_NEXT")
                        onButtonClicked: {
                            licenseModel.setLicenseAccepted(true);
                            licenseModel.okPressed();
                        }
                        buttonColor: "#227700"
                        isEnabled: true
                    }

                    Elements.Button3 {
                        buttonText: qsTr("BUTTON_CANCEL")
                        onButtonClicked: {
                            canceled();
                            page.closeMoveUpPage();
                        }
                    }
                }
            }
        }
    }
}
