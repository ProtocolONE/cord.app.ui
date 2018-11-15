import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0
import Application.Core.MessageBox 1.0

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
        Styles.setCurrentStyle(styleSettings.getValue(styleSettings.currentIndex));
        App.saveLanguage(applicationLanguage.getValue(applicationLanguage.currentIndex));

        var autostart = 0;

        if (runMinimized.checked && autoRun.checked) {
            autostart = 2;
        } else if (autoRun.checked) {
            autostart = 1;
        }

        var appSettings = App.settingsViewModelInstance();
        if (appSettings.autoStart != autostart) {
            appSettings.setAutoStart(autostart);
            d.sendAutoRunGA(appSettings.autoStart);
        }

        var settings = WidgetManager.getWidgetSettings('AutoMinimize');
        if (settings) {
            settings.minimizeOnStart = minimizeOnStart.checked;
            settings.save();
        }
    }

    function load() {
        applicationLanguage.currentIndex = applicationLanguage.findValue(App.language());
        participateTesting.checked = App.isPublicTestVersion();

        autoRun.checked = settingsViewModelInstance.autoStart > 0;
        runMinimized.checked = settingsViewModelInstance.autoStart === 2;

        var styleIndex = styleSettings.findValue(Styles.getCurrentStyle());
        if (styleIndex === -1) {
            styleIndex = styleSettings.findValue('mainStyle');
        }

        styleSettings.currentIndex = styleIndex;

        var settings = WidgetManager.getWidgetSettings('AutoMinimize');
        minimizeOnStart.checked = settings ? settings.minimizeOnStart : true;
    }

    function reset() {
        applicationLanguage.currentIndex = applicationLanguage.findValue('ru');

        autoRun.checked = true;
        runMinimized.checked = true;
        minimizeOnStart.checked = true;
        participateTesting.checked = 0;

        styleSettings.currentIndex = styleSettings.findValue(AppSettings.value('qml/settings/', 'style', 'mainStyle'));
    }

    function setMarketingsParams(params) {
        return params;
    }

    QtObject {
        id: d

        function getLanguageIndex() {
            return applicationLanguage.findValue(App.language());
        }

        function sendAutoRunGA(autorunType) {
            Ga.trackEvent('ApplicationSettings', 'click', 'Autorun', autorunType);
        }
    }

    Column {
        spacing: 20
        anchors.fill: parent

        Item {
            width: parent.width
            height: 68
            z: 101

            Text {
                font {
                    family: "Arial"
                    pixelSize: 12
                }

                text: qsTr("APPLICATION_SETTINGS_STYLE_CAPTION")
                color: Styles.infoText
            }

            ComboBox {
                id: styleSettings

                y: 20
                width: parent.width
                height: 48
                dropDownSize: 5

                icon: installPath + Styles.applicationSettingsStyleIcon
                model: Styles.settingsModel
            }
        }

        Item {
            width: parent.width
            height: 68
            z: 100

            Text {
                font {
                    family: "Arial"
                    pixelSize: 12
                }

                text: qsTr("APPLICATION_SETTINGS_LANGUAGE_CAPTION")
                color: Styles.infoText
            }

            ComboBox {
                id: applicationLanguage

                y: 20
                width: parent.width
                height: 48

                currentIndex: (d.getLanguageIndex() >= 0) ? d.getLanguageIndex() : 0
                icon: installPath + Styles.applicationSettingsLanguageIcon
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
        }

        CheckBox {
            id: autoRun

            text: qsTr("CHECKOX_AUTORUN")
            checked: settingsViewModelInstance.autoStart > 0
            onToggled: {
                if (!checked) {
                     runMinimized.checked = false;
                }
            }
        }

        CheckBox {
            id: runMinimized

            enabled: autoRun.checked
            checked: settingsViewModelInstance.autoStart === 2
            text: qsTr("CHECKOX_RUN_MINIMIZED")
        }

        CheckBox {
            id: minimizeOnStart

            text: qsTr("Сворачивать приложение при запуске игры")
        }

        Item {
            height: 70
            width: parent.width

            CheckBox {
                id: participateTesting

                checked: App.isPublicTestVersion();
                text: qsTr("CHECKOX_PARTICIPATE_TESTING")
                onToggled: {
                    MessageBox.show(qsTr("INFO_CAPTION"), qsTr("CHANGE_APPLICATION_AREA"),
                                    MessageBox.button.yes | MessageBox.button.cancel,
                                    function(result) {
                                        if (result == MessageBox.button.yes) {
                                            SignalBus.beforeCloseUI();
                                            App.switchClientVersion();
                                        } else {
                                            participateTesting.checked = App.isPublicTestVersion();
                                        }
                                    });

                    Ga.trackEvent('ApplicationSettings', 'toggle', 'Public testing', participateTesting.checked |0);
                }

                Connections {
                    target: App.settingsViewModelInstance()
                    ignoreUnknownSignals: true

                    onIsPublicTestVersionChanged: {
                        participateTesting.checked =  App.isPublicTestVersion();
                    }
                }
            }

            Text {
                x: 30
                y: 20
                width: parent.width - x
                wrapMode: Text.WordWrap
                text: qsTr("TEST_VERSION_TOOLTIP")
                color: Styles.infoText
                font { family: "Arial"; pixelSize: 11 }
            }
        }
    }
}
