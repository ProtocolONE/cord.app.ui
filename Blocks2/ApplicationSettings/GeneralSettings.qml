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
import Application.Controls 1.0 as ApplicationControls
import GameNet.Controls 1.0

import "../../Core/App.js" as App
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

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

    property variant settingsViewModelInstance: App.settingsViewModelInstance() || {}

    function save() {
        App.saveLanguage(applicationLanguage.getValue(applicationLanguage.currentIndex));
    }

    QtObject {
        id: d

        function getLanguageIndex() {
            return applicationLanguage.findValue(App.language());
        }

        function sendAutoRunGA(autorunType) {
            GoogleAnalytics.trackEvent('/ApplicationSettings',
                                   'Settings',
                                   'Autorun changed to: ' + autorunType);
        }
    }

    Column {
        x: 30
        spacing: 20


        ApplicationControls.ComboBox {
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
            checked: settingsViewModelInstance.autoStart > 0
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

                sendAutoRunGA(settingsViewModelInstance.autoStart);
            }
        }
        CheckBox {
            id: runMinimized

            width: 300
            fontSize: 15
            enabled: autoRun.checked
            checked: settingsViewModelInstance.autoStart === 2
            text: qsTr("CHECKOX_RUN_MINIMIZED")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
            onToggled: {
                if (checked) {
                    if (autoRun.checked) {
                        settingsViewModelInstance.setAutoStart(2);
                    }
                } else {
                    if (autoRun.checked) {
                        settingsViewModelInstance.setAutoStart(1);
                    }
                }

                sendAutoRunGA(settingsViewModelInstance.autoStart);
            }
        }
        Item {
            height: 100
            width: 520

            CheckBox {
                id: participateTesting

                width: 300
                fontSize: 15
                checked: App.isPublicTestVersion();
                text: qsTr("CHECKOX_PARTICIPATE_TESTING")
                style: ButtonStyleColors {
                    normal: "#1ABC9C"
                    hover: "#019074"
                }
                onToggled: {
                    settingsViewModel.switchClientVersion();

                    GoogleAnalytics.trackEvent('/ApplicationSettings',
                                           'Settings',
                                           'Switch client version');
                }

                Connections {
                    target: App.settingsViewModelInstance()
                    ignoreUnknownSignals: true

                    onIsPublicTestVersionChanged: {
                        participateTesting.checked = settingsViewModel.isPublicTestVersion;
                    }
                }
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
