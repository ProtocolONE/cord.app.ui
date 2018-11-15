import QtQuick 2.4
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0
import Application.Core.MessageBox 1.0

import "../Controls" as Controls

Item {
    id: settingsPageRoot

    property variant settingsViewModelInstance: App.settingsViewModelInstance() || {}
    property variant availableSpeedValues: [0, 100, 200, 500, 1000, 2000, 5000];

    function save() {
        if (!settingsViewModelInstance) {
            return;
        }

        if (useCustomValues.checked) {
            settingsViewModelInstance.downloadSpeed = downloadBandwidthLimitInput.text;
            settingsViewModelInstance.uploadSpeed = uploadBandwidthLimitInput.text;
        } else {
            settingsViewModelInstance.downloadSpeed = downloadBandwidthLimit.getValue(downloadBandwidthLimit.currentIndex);
            settingsViewModelInstance.uploadSpeed = uploadBandwidthLimit.getValue(uploadBandwidthLimit.currentIndex);
        }

        settingsViewModelInstance.incomingPort = incomingPort.text;
        settingsViewModelInstance.numConnections = connectionsLimit.text
        settingsViewModelInstance.seedEnabled = participateSeeding.checked;
        settingsViewModelInstance.torrentProfile = torrentProfile.getValue(torrentProfile.currentIndex);

        var settings = WidgetManager.getWidgetSettings('ApplicationSettings');
        settings.useCustomDownloadSettings = useCustomValues.checked;
        settings.save();
    }

    function load() {
        if (!settingsViewModelInstance) {
            return;
        }

        var settings = WidgetManager.getWidgetSettings('ApplicationSettings');
        useCustomValues.checked = settings.useCustomDownloadSettings;

        downloadBandwidthLimit.currentIndex = d.findNearestIndex(settingsViewModelInstance.downloadSpeed);
        uploadBandwidthLimit.currentIndex  = d.findNearestIndex(settingsViewModelInstance.uploadSpeed);

        downloadBandwidthLimitInput.text = settingsViewModelInstance.downloadSpeed;
        uploadBandwidthLimitInput.text = settingsViewModelInstance.uploadSpeed;

        incomingPort.text = settingsViewModelInstance.incomingPort || "11888";
        connectionsLimit.text = settingsViewModelInstance.numConnections || "20";
        participateSeeding.checked = settingsViewModelInstance.seedEnabled === undefined ? true : settingsViewModelInstance.seedEnabled;
        torrentProfile.currentIndex = torrentProfile.findValue(settingsViewModelInstance.torrentProfile);

        var tmp = {};
        d.setMarketingsParamsInternal(tmp);
        d.paramsHash = JSON.stringify(tmp);
        d.paramsChanged = false;
    }

    function reset() {
        downloadBandwidthLimit.currentIndex = 0;
        uploadBandwidthLimit.currentIndex = 0;

        downloadBandwidthLimitInput.text = 0;
        uploadBandwidthLimitInput.text   = 0;

        torrentProfile.currentIndex = 0;
        incomingPort.text = "11888";
        connectionsLimit.text = "20";
        participateSeeding.checked = true;
        useCustomValues.checked = false;
    }

    function setMarketingsParams(params) {
        params = d.setMarketingsParamsInternal(params);

        var tmp = {};
        d.setMarketingsParamsInternal(tmp);
        var paramHash = JSON.stringify(tmp);
        d.paramsChanged = (d.paramsHash == paramHash);

        return params;
    }

    function changed() {
        return d.paramsChanged;
    }

    QtObject {
        id: d

        property string downloadSpeed: settingsViewModelInstance.downloadSpeed || ""
        property string uploadSpeed: settingsViewModelInstance.uploadSpeed || ""

        property string paramsHash: ""
        property bool paramsChanged: false

        function torrentProfileIdToMarketingName(profileId) {
            switch(profileId) {
            case 1:
                return 'HIGH_PERFORMANCE_SEED';
            case 2:
                return 'MIN_MEMORY_USAGE';
            default:
                return 'DEFAULT_PROFILE';
            }
        }

        function setMarketingsParamsInternal(params) {
            params.downloadSpeed = settingsViewModelInstance.downloadSpeed;
            params.uploadSpeed = settingsViewModelInstance.uploadSpeed;
            params.connectionsLimit = settingsViewModelInstance.numConnections;
            params.seedEnabled = settingsViewModelInstance.seedEnabled;
            params.torrentProfile = d.torrentProfileIdToMarketingName(settingsViewModelInstance.torrentProfile)

            return params;
        }

        function findNearestIndex(value) {
            for (var i = 0; i < settingsPageRoot.availableSpeedValues.length; i++) {
                if (value <= settingsPageRoot.availableSpeedValues[i]) {
                    return i;
                }
            }
            return 0;
        }

        onDownloadSpeedChanged: {
            var index = downloadBandwidthLimit.findValue(parseInt(d.downloadSpeed));

            if (index >= 0) {
                downloadBandwidthLimit.currentIndex = index;
            }
        }
        onUploadSpeedChanged: {
            var index = uploadBandwidthLimit.findValue(parseInt(d.uploadSpeed));

            if (index >= 0) {
                uploadBandwidthLimit.currentIndex = index;
            }
        }
    }

    ListModel {
        id: speedLimit

        Component.onCompleted: {
            settingsPageRoot.availableSpeedValues.forEach(function(value){
                var text = (value == 0)
                        ? qsTr("SPEED_UNLIMITED")
                        : qsTr("%1 КБайт/с").arg(value);

                speedLimit.append({"value": value, "text": text, "icon": ''});
            });
        }
    }

    Column {
        spacing: 20
        anchors.fill: parent

        Row {
            spacing: 20
            z: 100

            Item {
                width: Math.floor((settingsPageRoot.width - parent.spacing) / 2)
                height: 60

                SettingsCaption {
                    text: qsTr("DOWNLOAD_LIMIT")
                }

                Input {
                    id: downloadBandwidthLimitInput

                    y: 20
                    width: parent.width
                    height: 40

                    toolTip: qsTr("0 - Неограниченно")
                    validator: IntValidator { bottom: 0; top: 2147483647 }

                    visible: useCustomValues.checked
                    placeholder: qsTr("Скорость загрузки в КБайт/с")
                }

                ComboBox {
                    id: downloadBandwidthLimit

                    y: 20
                    width: parent.width
                    height: 40
                    visible: !useCustomValues.checked
                    model: speedLimit
                }

                Controls.UnlimitedSpeedPlaceholder {
                    targetInput: downloadBandwidthLimitInput
                }
            }

            Item {
                width: Math.floor((settingsPageRoot.width - parent.spacing) / 2)
                height: 60

                SettingsCaption {
                    text: qsTr("UPLOAD_LIMIT")
                }

                Input {
                    id: uploadBandwidthLimitInput

                    y: 20
                    width: parent.width
                    height: 40

                    toolTip: qsTr("0 - Неограниченно")
                    validator: IntValidator { bottom: 0; top: 2147483647 }
                    visible: useCustomValues.checked
                    placeholder: qsTr("Скорость отдачи в КБайт/с")
                }

                ComboBox {
                    id: uploadBandwidthLimit

                    y: 20
                    width: parent.width
                    height: 40

                    visible: !useCustomValues.checked
                    model: speedLimit
                }

                Controls.UnlimitedSpeedPlaceholder {
                    targetInput: uploadBandwidthLimitInput
                }
            }
        }

        Row {
            spacing: 20

            Item {
                id: portInputItem

                width: Math.floor((settingsPageRoot.width - parent.spacing) / 2)
                height: 60

                SettingsCaption {
                    text: qsTr("INCOMING_PORT")
                }

                Row {
                    y: 20
                    spacing: 20

                    Input {
                        id: incomingPort

                        width: Math.floor((portInputItem.width - parent.spacing) / 2)
                        height: 40
                        text: "" + settingsViewModelInstance.incomingPort
                        showCapslock: false
                        showLanguage: false
                        validator: IntValidator { bottom: 0; top: 65535 }
                    }

                    MinorButton {
                        width: Math.floor((portInputItem.width - parent.spacing) / 2)
                        height: 40
                        text: qsTr("PORT_AUTO")
                        onClicked: {
                            incomingPort.text = Math.floor(Math.random() * 60000) + 1000;
                        }
                        analytics {
                            category: 'ApplicationSettings'
                            label: 'Port auto'
                        }
                    }
                }
            }

            Item {
                width: Math.floor((settingsPageRoot.width - parent.spacing) / 2)
                height: 60

                SettingsCaption {
                    text: qsTr("CONNECTION_COUNT")
                }

                Input {
                    id: connectionsLimit

                    y: 20
                    width: parent.width
                    height: 40
                    text: "" + settingsViewModelInstance.numConnections
                    showCapslock: false
                    showLanguage: false
                    validator: IntValidator { bottom: 1; top: 65535 }
                }
            }
        }

        Item {
            width: settingsPageRoot.width
            height: 100
            z: 99

            SettingsCaption {
                text: qsTr("Профиль скачивания")
            }

            ComboBox {
                id: torrentProfile

                y: 20
                z: 1
                width: parent.width
                height: 40

                Component.onCompleted: {
                    append(1, qsTr("Скачивать с максимальной производительностью")); //HIGH_PERFORMANCE_SEED
                    append(2, qsTr("Использовать как можно меньше памяти")); //MIN_MEMORY_USAGE
                    append(0, qsTr("Использовать минимальное количество ресурсов")); //DEFAULT_PROFILE

                    var index = torrentProfile.findValue(parseInt(settingsViewModelInstance.torrentProfile));
                    if (index >= 0) {
                        torrentProfile.currentIndex = index;
                    }
                }
            }

            Text {
                y: 75
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr("Выберите как должно вести себя приложение во время скачивания игр - использовать все доступные на вашем компьютере ресурсы или уменьшить скорость скачивания, используя меньше памяти или ресурсов процессора.")
                color: Styles.infoText
                font { family: "Arial"; pixelSize: 11 }
            }
        }

        CheckBox {
            id: participateSeeding

            text: qsTr("PARTICIPATE_SEEDING")
            checked: settingsViewModelInstance.seedEnabled || false
        }

        Column {
            width: settingsPageRoot.width

            CheckBox {
                id: useCustomValues
                text: qsTr("Экспертная настройка системы скачивания")

                onCheckedChanged: {
                    if (checked) {
                        downloadBandwidthLimitInput.text = downloadBandwidthLimit.getValue(downloadBandwidthLimit.currentIndex);
                        uploadBandwidthLimitInput.text = uploadBandwidthLimit.getValue(uploadBandwidthLimit.currentIndex);
                    } else {
                        downloadBandwidthLimit.currentIndex = d.findNearestIndex(downloadBandwidthLimitInput.text);
                        uploadBandwidthLimit.currentIndex  = d.findNearestIndex(uploadBandwidthLimitInput.text);
                    }
                }
            }

            Text {
                x: 30
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr("Выберите, если хотите указать произвольные значения для ограничения скорости загрузки и отдачи клиента.")
                color: Styles.infoText
                font { family: "Arial"; pixelSize: 11 }
            }
        }
    }
}
