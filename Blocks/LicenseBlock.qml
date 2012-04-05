/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import qGNA.Library 1.0
import "../Elements" as Elements
import "." as Blocks

Blocks.MoveUpPage {
    id: page

    signal canceled();

    openHeight: 400

    Rectangle {
        color: "#353945"
        anchors.fill: parent

        Connections {
            target: licenseModel
            onOpenLicenseBlock: {
                page.openMoveUpPage();
                licenseModel.setLicenseAccepted(false);
                licenseAppectedCheckBox.state = "Normal";
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

        Rectangle {
            width: 490
            height: 150
            anchors { left: parent.left; top: parent.top; leftMargin: 276; topMargin: 37 }
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

        Rectangle {
            anchors { top: parent.top; left: parent.left; topMargin: 195; leftMargin: 276 }

            Elements.CheckBox {
                id: licenseAppectedCheckBox

                anchors { top: parent.top; left: parent.left }
                state: licenseModel.licenseAccepted ? "Active" : "Normal"
                onChecked: licenseModel.setLicenseAccepted(isChecked);
                onUnchecked: licenseModel.setLicenseAccepted(isChecked);
            }

            Text {
                anchors { top: parent.top; left: parent.left; leftMargin: 28 }
                color: "#fff"
                font { family: "Arial"; pixelSize: 16 }
                text: qsTr("CHECKBOX_I_AGREE")
            }
        }

        Rectangle {
            anchors { left: parent.left; top: parent.top; topMargin: 235; leftMargin: 276 }

            Text {
                anchors { top: parent.top; left: parent.left }
                color: "#fff"
                font { family: "Arial"; pixelSize: 16 }
                text: qsTr("LABEL_GAME_INSTALLATION_PATH_INPUT")
            }

            Elements.FileInput {
                width: 407
                anchors { top: parent.top; left: parent.left; topMargin: 20 }
                textElement { text: licenseModel.pathToInstall; readOnly: true }
                onEditTextChanged: licenseModel.setPathToInstall(text);
            }

            Elements.Button3 {
                anchors { top: parent.top; left: parent.left; topMargin: 20; leftMargin: 415 }
                buttonText: qsTr("BUTTON_BROWSE")
                onButtonClicked: licenseModel.searchPressed();
            }
        }

        Rectangle {
            anchors { top: parent.top; left: parent.left; topMargin: 295; leftMargin: 276 }

            Elements.CheckBox {
                anchors { top: parent.top; left: parent.left }
                state: licenseModel.shurtCutInDesktop ? "Active" : "Normal"
                onChecked: licenseModel.setShurtCutInDesktop(isChecked);
                onUnchecked: licenseModel.setShurtCutInDesktop(isChecked);
            }

            Text {
                anchors { top: parent.top; left: parent.left; leftMargin: 28 }
                color: "#fff"
                font { family: "Arial"; pixelSize: 16 }
                text: qsTr("CHECKBOX_CREATE_SHORTCUT_ON_DESKTOP")
            }
        }

        Rectangle {
            anchors { top: parent.top; left: parent.left; topMargin: 320; leftMargin: 276 }

            Elements.CheckBox {
                anchors { top: parent.top; left: parent.left }
                state: licenseModel.shurtCutInStart ? "Active" : "Normal"
                onChecked: licenseModel.setShurtCutInStart(isChecked);
                onUnchecked: licenseModel.setShurtCutInStart(isChecked);
            }

            Text {
                anchors { top: parent.top; left: parent.left; leftMargin: 28 }
                color: "#fff"
                font { family: "Arial"; pixelSize: 16 }
                text: qsTr("CHECKBOX_CREATE_SHORTCUT_IN_START_MENU")
            }
        }

        Elements.Button4 {
            anchors { top: parent.top; left: parent.left; topMargin: 353; leftMargin: 276 }
            buttonText: qsTr("BUTTON_NEXT")

            // этот параметр, когда пользователь поставит галочку в "Я принимаю условия лицензионного соглашения" - true
            isEnabled: licenseAppectedCheckBox.isChecked
            onButtonClicked: licenseModel.okPressed();
        }

        Elements.Button3 {
            anchors { top: parent.top; left: parent.left; topMargin: 353; leftMargin: 405 }
            buttonText: qsTr("BUTTON_CANCEL")
            onButtonClicked: {
                canceled();
                page.closeMoveUpPage();
            }
        }
    }
}
