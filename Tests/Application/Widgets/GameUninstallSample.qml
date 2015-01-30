/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Application/Core/App.js" as App
import "../../../Application/Core/Popup.js" as Popup

Rectangle {
    width: 1000
    height: 600
    color: '#EEEEEE'

    // Initialization

    Component.onCompleted: {
        Settings.setValue("qml/core/popup/", "isHelpShowed", 0);
        Popup.init(popupLayer);
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.GameUninstall');
            manager.init();
            App.activateGame(App.serviceItemByGameId("92"));

            //  stub
            App.uninstallService = function(serviceId) {
                console.log("App::uninstallService() called: " + serviceId);
                emulationAnimation.running = true;
            }

            App.currentGame = function() {
                return {
                    name: d.name,
                    serviceId: d.serviceId,
                    statusText: d.statusText,
                    progress: d.progress
                };
            }
        }
    }

    QtObject {
        id: d

        property string name: "Combat Arms"
        property string serviceId: "300009010000000000"
        property string statusText: ""
        property int progress: 0

        function uninstallStarted() {
            d.statusText = "Подготовка в удалению игры " + d.name;
            App.uninstallStarted(d.serviceId);
        }
        function uninstallProgressChanged(progress) {
            d.progress = progress;
            d.statusText = "Удаление файлов игры " + d.name;
            App.uninstallProgressChanged(d.serviceId, progress);
        }
        function uninstallFinished() {
            App.uninstallFinished(d.serviceId);
        }
    }

    SequentialAnimation {
        id: emulationAnimation

        running: false
        ScriptAction { script: d.uninstallStarted(); }
        PauseAnimation { duration: 1000 }
        ScriptAction { script: d.uninstallProgressChanged(0);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(10);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(20);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(30);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(40);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(50);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(60);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(70);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(80);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(90);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallProgressChanged(100);}
        PauseAnimation { duration: 500 }
        ScriptAction { script: d.uninstallFinished();}
    }

    Connections {
        target: Popup.signalBus()
        onClose: {
            console.log("Closed popupId: " + popupId);
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Assets/Images/test/main_07.png'
        }


        Button {
            x: 10
            y: 98
            width: 160
            height: 36
            text: 'Начать игру'
            onClicked: {
                Popup.show('GameUninstall');
                App.uninstallService("300009010000000000");
            }
        }
   }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}
