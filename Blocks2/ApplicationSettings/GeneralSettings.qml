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
import "../../Controls" as Controls
import "../../Proxy/App.js" as App

Item {
    id: root

    //  HACK: раскомментировать для тестирования
    Item {
        id: settingsViewModel

        property int autoStart: 0
        property bool isPublicTestVersion: true

        function setAutoStart(autorunType) {
            console.log("settingsViewModel::setAutoStart " + autorunType);
            autoStart = autorunType;
        }
    }

    QtObject {
        id: d

        function getLanguageIndex() {
            return installationPath.findValue(App.language());
        }
    }

    Column {
        x: 30
        spacing: 20

        Controls.ComboBox {
            id: installationPath

            z: 100
            width: 500
            height: 48

            currentIndex: (d.getLanguageIndex() >= 0) ? d.getLanguageIndex() : 0
            icon: installPath + "images/Pages/ApplicationSettings/language.png"
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

        Controls.CheckBox {
            id: autoRun

            width: 300
            fontSize: 15
            text: "Автозапуск GameNet"
            style: Controls.ButtonStyleColors {
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
        Controls.CheckBox {
            id: runMinimized

            width: 300
            fontSize: 15
            enabled: settingsViewModel.autoStart > 0
            checked: settingsViewModel.autoStart === 2
            text: "Запускать приложение свернутым"
            style: Controls.ButtonStyleColors {
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

            Controls.CheckBox {
                id: participateTesting

                width: 300
                fontSize: 15
                checked: settingsViewModel.isPublicTestVersion
                text: "Принять участие в тестировании клиента GameNet"
                style: Controls.ButtonStyleColors {
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
                text: "Поставьте отметку, чтобы участвовать в тестировании новых функций клиента GameNet. Вы можете столкнуться с различными ошибками и недочетами. Если во время использования тестового клиента вы нашли ошибку, пожалуйста, сообщите о ней в нашу службу поддержки."
                color: "#66758F"
                font { family: "Arial"; pixelSize: 12 }
            }
        }
    }
}
