/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (В©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import qGNA.Library 1.0
import "../../Elements" as Elements
import "../../Proxy/App.js" as App

Item {
    id: mainGeneralPageRectangle

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (line1.isListActive)
                line1.switchAnimation();
        }
    }

    Component {
        id: componentListBoxDelegate

        Rectangle {
            id: delegateRectangle
            x: 1
            color: mouser.containsMouse ? "#eab46b" : "#ffffff"
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
                id: mouser

                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    itemClicked(shortValue);
                    switchAnimation();
                    buttonCheckListBoxText = textValue;
                    mainClickText.opacity = 0.8;
                    checkListBoxRectangle.opacity = 0.8;
                }
            }
        }
    }

    Column {
        spacing: 10
        anchors.fill: parent

        Elements.CheckListBox {
            id: line1

            z: 1
            width: 193
            checkListBoxX: -1
            checkListBoxWidth: 100
            checkBoxType: true
            buttonText: qsTr("LABEL_LANGUAGE_SELECT_DROPDOWN")
            buttonCheckListBoxText: mainWindow.language == "ru" ? "Русский" : mainWindow.language == "en" ? "English" : "";
            onItemClicked: mainWindow.saveLanguage(lang);

            componentDelegate: componentListBoxDelegate

            listModel: ListModel {
                ListElement {
                    textValue: "Русский"
                    shortValue: "ru"
                }/*
                ListElement {
                    textValue: "English"
                    shortValue: "en"
                }*/
            }

            Elements.CursorShapeArea { anchors.fill: parent }
        }

        Elements.CheckBox {
            id: line2

            state: settingsViewModel.autoStart > 0 ? "Active" : "Normal"
            buttonText: qsTr("CHECKBOX_AUTORUN")
            onChecked: {
                if (line3.isChecked){
                    settingsViewModel.setAutoStart(2);
                } else {
                    settingsViewModel.setAutoStart(1);
                }
            }

            onUnchecked: {
                line3.setValue(false);
                settingsViewModel.setAutoStart(0);
            }
        }

        Elements.CheckBox {
            id: line3

            enabled: settingsViewModel.autoStart > 0
            state: settingsViewModel.autoStart === 2 ? "Active" : "Normal"
            buttonText: qsTr("CHECKBOX_AUTORUN_MINIMIZED")

            onChecked: {

                if (line2.isChecked){
                    if (line3.isChecked){
                        settingsViewModel.setAutoStart(2);
                    } else {
                        settingsViewModel.setAutoStart(1);
                    }
                }
            }

            onUnchecked: {
                if (line2.isChecked)
                    settingsViewModel.setAutoStart(1);
            }
        }

        Connections {
            target: settingsViewModel
            onIsPublicTestVersionChanged: {
                versionCheckbox.state = settingsViewModel.isPublicTestVersion ? "Active" : "Normal";
            }
        }

        Elements.CheckBox {
            id: versionCheckbox

            enabled: true
            state: settingsViewModel.isPublicTestVersion ? "Active" : "Normal"
            buttonText: qsTr("CHECKBOX_GNA_TEST_VERSION")
            onChecked: settingsViewModel.switchClientVersion();
            onUnchecked: settingsViewModel.switchClientVersion();
        }

        Text {
            text: qsTr("CHECKBOX_GNA_TEST_VERSION_TOOLTIP")
            style: Text.Normal
            anchors { left: parent.left; leftMargin: 30; right: parent.right }
            font { family: "Segoe UI Semibold"; bold: false; pixelSize: 11; weight: "Normal" }
            wrapMode: Text.WordWrap
            smooth: true
            color: "#999999"
        }

    }
}

