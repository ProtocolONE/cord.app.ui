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
import GameNet.Controls 1.0

import "../../Core/App.js" as App

Item {
    id: root

    //  HACK: раскомментировать для тестирования
    //    Item {
    //        id: settingsViewModel

    //        property int autoStart: 0
    //        property bool isPublicTestVersion: true

    //        function setAutoStart(autorunType) {
    //            settingsViewModel.autoStart = autorunType;
    //        }

    //        function switchClientVersion() {
    //            settingsViewModel.isPublicTestVersion != settingsViewModel.isPublicTestVersion;
    //        }
    //    }

    QtObject {
        id: d

        function getLanguageIndex() {
            return applicationLanguage.findValue(App.language());
        }
    }

    Column {
        x: 30
        spacing: 20

        ComboBox {
            id: applicationLanguage

            z: 100
            width: 500
            height: 48

            currentIndex: (d.getLanguageIndex() >= 0) ? d.getLanguageIndex() : 0
            icon: installPath + "Assets/Images/Application/Blocks/ApplicationSettings/language.png"
            model: ListModel {
                ListElement {
                    value: "ru"
                    text: "Русский язык"
                }
                ListElement {
                    value: "en"
                    text: "English"
                }
            }
        }

        CheckBox {
            id: autoRun

            width: 300
            fontSize: 15
            text: qsTr("CHECKOX_AUTORUN")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
            onToggled: {
                if (checked) {
                    if (runMinimized.checked) {
                        settingsViewModel.setAutoStart(2);
                    } else {
                        settingsViewModel.setAutoStart(1);
                    }
                } else {
                    runMinimized.checked = false;
                    settingsViewModel.setAutoStart(0);
                }
            }
        }
        CheckBox {
            id: runMinimized

            width: 300
            fontSize: 15
            enabled: settingsViewModel.autoStart > 0
            checked: settingsViewModel.autoStart === 2
            text: qsTr("CHECKOX_RUN_MINIMIZED")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
            onToggled: {
                if (checked) {
                    if (autoRun.checked) {
                            settingsViewModel.setAutoStart(2);
                    }
                } else {
                    if (autoRun.checked) {
                        settingsViewModel.setAutoStart(1);
                    }
                }
            }
        }
        Item {
            height: 100
            width: 520

            CheckBox {
                id: participateTesting

                width: 300
                fontSize: 15
                checked: settingsViewModel.isPublicTestVersion
                text: qsTr("CHECKOX_PARTICIPATE_TESTING")
                style: ButtonStyleColors {
                    normal: "#1ABC9C"
                    hover: "#019074"
                }
                onToggled: settingsViewModel.switchClientVersion();
            }

            Text {
                x: 25
                y: 20
                width: 490
                height: 55
                wrapMode: Text.WordWrap
                text: qsTr("TEST_VERSION_TOOLTIP")
                color: "#66758F"
                font { family: "Arial"; pixelSize: 12 }
            }
        }
    }
}
