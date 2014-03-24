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
import "../Proxy/App.js" as AppProxy
import "../js/Core.js" as Core

Blocks.MoveUpPage {
    id: page

    signal canceled();

    openHeight: 160

    QtObject {
        id: d

        property string licenseUrl: ""

        property Gradient hoverGradient: Gradient {
            GradientStop { position: 1; color: "#227700" }
            GradientStop { position: 0; color: "#227700" }
        }

        property Gradient normalGradient: Gradient {
            GradientStop { position: 1; color: "#177e00" }
            GradientStop { position: 0; color: "#32b003" }
        }
    }

    Rectangle {
        color: "#353945"
        anchors.fill: parent

        /*
        //Use it for debug page. Or write proxy object for licenseModell from c++ mainwindow
        Item {
            id: licenseModel
            property string license: ""
            property string pathToInstall: ""

            signal openLicenseBlock();
            signal closeLicenseBlock();

            Component.onCompleted: {
                licenseModel.openLicenseBlock();
            }

            function serviceId() {
                return "300003010000000000";
            }

            function setLicenseAccepted() {
            }
        }
        */

        Connections {
            target: licenseModel
            onOpenLicenseBlock: {
                var gameItem = Core.serviceItemByServiceId(licenseModel.serviceId());
                d.licenseUrl = gameItem.licenseUrl;

                page.openMoveUpPage();
                licenseModel.setLicenseAccepted(false);
            }

            onCloseLicenseBlock: page.closeMoveUpPage();
        }

        Column {
            anchors { left: parent.left; top: parent.top; leftMargin: 42; topMargin: 10 }
            spacing: 20

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
                        width: 273
                        textElement { text: licenseModel.pathToInstall; readOnly: true }
                        onEditTextChanged: licenseModel.setPathToInstall(text);
                    }

                    Elements.Button3 {
                        buttonText: qsTr("BUTTON_BROWSE")
                        onButtonClicked: licenseModel.searchPressed();
                    }
                }

                Elements.CheckBox {
                    state: licenseModel.shurtCutInDesktop ? "Active" : "Normal"
                    onChecked: licenseModel.setShurtCutInDesktop(isChecked);
                    onUnchecked: licenseModel.setShurtCutInDesktop(isChecked);
                    buttonText: qsTr("CHECKBOX_CREATE_SHORTCUT_ON_DESKTOP")
                }

                Elements.CheckBox {
                    state: licenseModel.shurtCutInStart ? "Active" : "Normal"
                    onChecked: licenseModel.setShurtCutInStart(isChecked);
                    onUnchecked: licenseModel.setShurtCutInStart(isChecked);
                    buttonText: qsTr("CHECKBOX_CREATE_SHORTCUT_IN_START_MENU")
                }

                Text {
                    color: "#CCCCCC"
                    font { family: "Arial"; pixelSize: 11 }
                    text: qsTr("CHECKBOX_I_AGREE").arg(d.licenseUrl)
                    textFormat: Text.RichText
                    onLinkActivated: AppProxy.openExternalUrl(link);
                }
            }
        }

        Column {
            anchors { right: parent.right; top: parent.top; rightMargin: 33; topMargin: 16 }
            spacing: 10
            width: 222

            Rectangle {
                border { width: 1; color: "#FFFFFF" }
                gradient: buttonMouser.containsMouse ? d.hoverGradient : d.normalGradient
                width: 222
                height: 54

                Text {
                    anchors.centerIn: parent
                    color : "#FFFFFF"
                    font { pixelSize: 28; family: "Segoe UI" }
                    textFormat: Text.RichText
                    text: qsTr("BUTTON_NEXT")
                }

                Elements.CursorMouseArea {
                    id: buttonMouser

                    anchors.fill: parent
                    onClicked: {
                        licenseModel.setLicenseAccepted(true);
                        licenseModel.okPressed();
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color : cancelMouser.containsMouse ? "#FFFFFF" : "#CCCCCC"
                font { pixelSize: 16; family: "Arial"; underline: true }
                textFormat: Text.RichText
                text: qsTr("BUTTON_CANCEL")

                Elements.CursorMouseArea {
                    id: cancelMouser

                    anchors.fill: parent
                    onClicked: {
                        canceled();
                        page.closeMoveUpPage();
                    }
                }
            }
        }
    }
}
