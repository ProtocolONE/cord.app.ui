import QtQuick 2.4
import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0

Item {
    id: settingsPageRoot

    property variant gameSettingsModelInstance: App.gameSettingsModelInstance()
    property variant availableResolutions
    property variant settings
    property string settingsPath: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
                                  + '/Black Desert/GameOption.txt'

    property string serviceId: "30000000000"

    Component.onCompleted: {
        var resolutions = Desktop.availableResolutions().filter(function(e){
            return e.width >= 1280 && e.height >= 720;
        });

        resolutions.sort(function(a, b) {
            return (b.width - a.width) || (b.height - a.height);
        });

        resolutions.forEach(function(e, index) {
            resolutionsBox.append(index, e.width + ' x ' + e.height);
        });

        availableResolutions = resolutions;
    }

    function save() {
        var content = '',
            bytesWriten = -1;

        root.gameSettingsModelInstance.setPrefer32Bit(settingsPageRoot.serviceId, force32bitClient.checked);

        settings.width = availableResolutions[resolutionsBox.currentIndex].width|0;
        settings.height = availableResolutions[resolutionsBox.currentIndex].height|0;
        settings.graphicOption = graphicOption.currentIndex|0;
        settings.windowed = windowed.currentIndex|0;
        settings.enableSound = enableSound.checked|0;
        settings.enableMusic = enableMusic.checked|0;
        settings.enableEnvSound = enableEnvSound.checked|0;

        getSaveOrder().forEach(function(e) {
            content += e + " = " + settings[e] + "\r\n";
        });

        try {
            bytesWriten = FileSystem.writeFile(settingsPath, content);
            if (-1 === bytesWriten) {
                console.log('Black Desert settings save failed');
            }
        } catch (e) {
            console.log(e.message);
        }
    }

    function load() {
        var content,
            tmpIndex,
            obj = {};

        force32bitClient.checked = root.gameSettingsModelInstance.isPrefer32Bit(settingsPageRoot.serviceId);


        if (!FileSystem.exists(settingsPath)) {
            console.log('File not exists')
            settings = getDefaultTemplate();
            return;
        }

        try {
            content = FileSystem.readFile(settingsPath)
        } catch (e) {
            console.log(e.message);
            settings = getDefaultTemplate();
            return;
        }

        content.trim().split("\n")
            .map(function(e){
                return e.split("=");
            }).forEach(function(e){
                var key = e[0].toString(),
                    value = e[1];

                obj[key.trim()] = value.trim();
            });

        tmpIndex = Lodash._.findIndex(availableResolutions, {width: obj.width|0, height: obj.height|0});
        if (tmpIndex === -1) {
            tmpIndex = 0;
        }

        tmpIndex = resolutionsBox.findValue(tmpIndex);
        if (tmpIndex !== -1) {
            resolutionsBox.currentIndex = tmpIndex;
        }

        tmpIndex = graphicOption.findValue(obj.graphicOption);
        if (tmpIndex !== -1) {
            graphicOption.currentIndex = tmpIndex;
        }

        tmpIndex = windowed.findValue(obj.windowed);
        if (tmpIndex !== -1) {
            windowed.currentIndex = tmpIndex;
        }

        enableSound.checked = obj.enableSound|0;
        enableMusic.checked = obj.enableMusic|0;
        enableEnvSound.checked = obj.enableEnvSound|0;

        settings = obj;
    }

    function getSaveOrder() {
        return [
            'version',
            'adaptor',
            'windowed',
            'width',
            'height',
            'graphicOption',
            'graphicUltra',
            'dof',
            'antiAliasing',
            'SSAO',
            'Tessellation',
            'postFilter',
            'characterEffect',
            'lensBlood',
            'bloodEffect',
            'textureQuality',
            'gamma',
            'contrast',
            'cameraLUTFilter',
            'fov',
            'enableOVR',
            'enableSimpleUI',
            'showSkillCmd',
            'enableSound',
            'enableMusic',
            'enableEnvSound',
            'masterVolume',
            'fxVolume',
            'envVolume',
            'voiceVolume',
            'musicVolume',
            'hitFxVolume',
            'otherPlayerVolume',
            'hitFxWeight',
            'cameraEffectMaster',
            'cameraShakePower',
            'cameraFovPower',
            'cameraTranslatePower',
            'motionBlurPower',
            'upscaleEnable',
            'sleepModeEnable',
            'cropModeEnable',
            'cropModeScaleX',
            'cropModeScaleY',
            'screenShotFormat',
            'useNearestEffectOnly',
            'useSelfPlayerOnlyLantern',
            'useSelfPlayerEffectOnly',
            'uiScale',
            'showComboGuide',
            'selfPlayerNameTagVisible',
            'otherPlayerNameTagVisible',
            'partyPlayerNameTagVisible',
            'guildPlayerNameTagVisible'
        ];
    }

    function getDefaultTemplate() {
        return {
            version: "4",
            adaptor: "0",
            windowed: "1",
            width: availableResolutions[0].width,
            height: availableResolutions[0].height,
            graphicOption: "3",
            graphicUltra: "0",
            dof: "0",
            antiAliasing: "1",
            SSAO: "1",
            Tessellation: "0",
            postFilter: "2",
            characterEffect: "1",
            lensBlood: "1",
            bloodEffect: "2",
            textureQuality: "1",
            gamma: "1.00",
            contrast: "0.40",
            cameraLUTFilter: "None",
            fov: "70.00",
            enableOVR: "0",
            enableSimpleUI: "0",
            showSkillCmd: "1",
            enableSound: "1",
            enableMusic: "1",
            enableEnvSound: "1",
            masterVolume: "20.0",
            fxVolume: "100.0",
            envVolume: "100.0",
            voiceVolume: "100.0",
            musicVolume: "5.0",
            hitFxVolume: "100.0",
            otherPlayerVolume: "100.0",
            hitFxWeight: "100.0",
            cameraEffectMaster: "1.00",
            cameraShakePower: "0.50",
            cameraFovPower: "0.91",
            cameraTranslatePower: "0.50",
            motionBlurPower: "0.50",
            upscaleEnable: "0",
            sleepModeEnable: "0",
            cropModeEnable: "0",
            cropModeScaleX: "1.00",
            cropModeScaleY: "0.80",
            screenShotFormat: "1",
            useNearestEffectOnly: "0",
            useSelfPlayerEffectOnly: "1",
            useSelfPlayerOnlyLantern: "0",
            uiScale:  "1.00",
            showComboGuide: "0",
            selfPlayerNameTagVisible: "0",
            otherPlayerNameTagVisible: "0",
            partyPlayerNameTagVisible: "0",
            guildPlayerNameTagVisible: "0"
        };
    }

    ScrollArea {
        allwaysShown: true
        anchors {
            fill: parent
            bottomMargin: 62
            leftMargin: 30
        }

        Column {
            spacing: 18
            width: parent.width - 30

            Column {
                width: parent.width
                z: 3

                SettingsCaption {
                    text: qsTr("Качество графики")
                }

                ComboBox {
                    id: graphicOption

                    width: parent.width
                    dropDownSize: 7
                    Component.onCompleted: {
                        append("0", qsTr("Очень высоко"));
                        append("1", qsTr("Высоко"));
                        append("2", qsTr("Выше среднего"));
                        append("3", qsTr("Средне"));
                        append("4", qsTr("Низко"));
                        append("5", qsTr("Очень низко"));
                        append("6", qsTr("Режим оптимизации"));
                    }
                }
            }

            Column {
                width: parent.width
                z: 2

                SettingsCaption {
                    text: qsTr("Разрешение экрана")
                }

                ComboBox {
                    id: resolutionsBox

                    width: parent.width
                    dropDownSize: 6
                }
            }

            Column {
                width: parent.width
                z: 1

                SettingsCaption {
                    text: qsTr("Тип экрана")
                }

                ComboBox {
                    id: windowed

                    width: parent.width
                    dropDownSize: 3
                    Component.onCompleted: {
                        append("0", qsTr("Полноэкранный"));
                        append("1", qsTr("Оконный без рамки"));
                        append("2", qsTr("Оконный"));
                    }
                }
            }

            CheckBox {
                id: enableSound

                text: qsTr("Включить звуковые эффекты")
            }

            CheckBox {
                id: enableMusic

                text: qsTr("Включить музыку")
            }

            CheckBox {
                id: enableEnvSound

                text: qsTr("Включить звуки окружения")
            }

            CheckBox {
                id: force32bitClient

                visible: GoogleAnalyticsHelper.systemVersion().indexOf('WOW64') != -1
                text: qsTr("Запускать 32-х битный клиент")
            }
        }
    }
}
