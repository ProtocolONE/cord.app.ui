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

    property string settingsPath: gameSettingsModelInstance.installPath
                                  + '/live/Bin/Release/Settings/Option.xml'

    property string serviceId: "370000000000"

    property string settingsContent

    Component.onCompleted: {
        var resolutions = Desktop.availableResolutions().filter(function(e) {
            return e.width >= 1024 && e.height >= 720;
        });

        resolutions.sort(function(a, b) {
            return (b.width - a.width) || (b.height - a.height);
        });

        resolutions.forEach(function(e, index) {
            resolutionsBox.append(index, e.width + ' x ' + e.height);
        });

        availableResolutions = resolutions;
    }

    function replaceOption(content, name, value) {
      var re = new RegExp('<Option[ \t\n\r\v]+?Name="' + name + '"[ \t\n\r\v]+?Data="([^"]+?)" />', 'mig')
        , w = '<Option Name="' + name + '" Data="' + value + '" />'
      return content.replace(re, w);
    }

    function save() {
        if (!!!settingsPageRoot.settingsContent) {
            return;
        }

        var content = settingsPageRoot.settingsContent
            , bytesWriten = -1;

        content = replaceOption(content, "ScreenWidth", availableResolutions[resolutionsBox.currentIndex].width|0);
        content = replaceOption(content, "ScreenHeight", availableResolutions[resolutionsBox.currentIndex].height|0);
        content = replaceOption(content, "GraphicQuality", graphicOption.getValue(graphicOption.currentIndex)|0);
        content = replaceOption(content, "Windowed_Lobby", windowed.getValue(windowed.currentIndex) || "No");
        content = replaceOption(content, "Windowed_Battle", windowed.getValue(windowed.currentIndex) || "No");

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
        var content;

        if (FileSystem.exists(settingsPath)) {
            try {
                content = FileSystem.readFile(settingsPath)
            } catch (e) {
                console.log(e.message);
            }
        }

        if (!!!content) {
            content = getDefaultTemplate(parseContent);
            return;
        }

        parseContent(content);
    }

    function parseContent(content) {
        var tmpIndex
            , result
            , options = {}
            , optionsRegex = new RegExp('<Option[ \t\n\r\v]+?Name="([^"]+?)"[ \t\n\r\v]+?Data="([^"]+?)"', 'mig');

        if (!!!content) {
            console.log('Failed to load Battle Carnival settings.');
            return;
        }

        settingsPageRoot.settingsContent = content;

        while ((result = optionsRegex.exec(content)) !== null) {
            options[result[1]] = result[2];
        }

        tmpIndex = Lodash._.findIndex(availableResolutions, {width: options.ScreenWidth|0, height: options.ScreenHeight|0});
        if (tmpIndex === -1) {
            tmpIndex = 0;
        }

        tmpIndex = resolutionsBox.findValue(tmpIndex);
        if (tmpIndex !== -1) {
            resolutionsBox.currentIndex = tmpIndex;
        }

        tmpIndex = graphicOption.findValue(options.GraphicQuality || "4");
        if (tmpIndex !== -1) {
            graphicOption.currentIndex = tmpIndex;
        }

        tmpIndex = windowed.findValue(options.Windowed_Battle || "No");
        if (tmpIndex !== -1) {
            windowed.currentIndex = tmpIndex;
        }
    }

    function getDefaultTemplate(callback) {
        if (typeof callback != 'function') {
            return;
        }

        var defaultConfigUrl = "http://gnfiles.com/update/carnival/live/Bin/Release/Settings/Option.xml";
        RestApi.http.request(defaultConfigUrl, function(data) {
            callback(data.status == 200 ? data.body : "")
        })
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
                        append("4", qsTr("Лучшее"));
                        append("3", qsTr("Отличное"));
                        append("2", qsTr("Хорошее"));
                        append("1", qsTr("Среднее"));
                        append("0", qsTr("Низкое"));
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
                        append("No", qsTr("Полноэкранный"));
                        append("Yes", qsTr("Оконный"));
                    }
                }
            }

        }
    }
}
