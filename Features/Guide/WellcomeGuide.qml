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
import Tulip 1.0

import "../../js/Core.js" as Core
import "../../js/UserInfo.js" as UserInfo
import "../../Proxy/App.js" as App
import "Guide.js" as Guide

Item {
    id: root

    implicitWidth: Core.clientWidth
    implicitHeight: Core.clientHeight

    Component.onCompleted: {
        //Settings.setValue("qml/features/guide/", "showCount", 0);
    }

    function start() {
        if (runTimer.running || !App.isAnyLicenseAccepted()) {
            return;
        }
        runTimer.start();
    }

    function stop() {
        runTimer.stop();
    }

    Connections {
        target: mainWindow

        onDownloadButtonStartSignal: root.stop();
        onServiceStarted: root.stop();
        onServiceFinished: root.start();
        onDownloaderStarted: root.start();
        onDownloaderStopped: root.start();
        onDownloaderFailed: root.start();
        onDownloaderFinished: root.start();
    }

    Timer {
        id: runTimer

        interval: 5000
        onTriggered: d.start()
    }

    Guide {
        id: d

        function start() {
            var item = Core.currentGame();
            if (!item || !App.isWindowVisible()) {
                return;
            }

            var storyLine = [
                {
                    focusRect: {x: 261, y: 227, width: 0, height: 0},
                    textRect: {x: 261, y: 227, width: 422, height: 109},
                    dock: {x: 311, y: 227},
                    duration: 11000,
                    text: qsTr("GUIDE_2"),
                    sound: "2.wma"
                },
                {
                    focusRect: {x: 206, y: 87, width: 210, height: 80},
                    textRect: {x: 370, y: 295, width: 420, height: 65},
                    dock: {x: 520, y: 125},
                    duration: 8000,
                    text: qsTr("GUIDE_3"),
                    sound: "3.wma"
                },
                {
                    focusRect: {x: 414, y: 87, width: 73, height: 79},
                    textRect: {x: 120, y: 295, width: 420, height: 65},
                    dock: {x: 270, y: 125},
                    duration: 7000,
                    text: qsTr("GUIDE_4"),
                    sound: "4.wma"
                }
            ];

            if (item.status === "Downloading") {
                storyLine.push({
                   focusRect: {x: 129, y: 474, width: 460, height: 65},
                   textRect: {x: 321, y: 227, width: 422, height: 66},
                   dock: {x: 613, y: 500},
                   duration: 7000,
                   text: qsTr("GUIDE_5"), //installing game
                   sound: "5.wma"
                });
            }

            storyLine.push({
               focusRect: {x: 741, y: 474, width: 170, height: 65},
               textRect: {x: 321, y: 297, width: 422, height: 66},
               dock: {x: 553, y: 505},
               duration: 8000,
               text: qsTr("GUIDE_6"), //exec after
               sound: "6.wma"
            });

            if (UserInfo.userId()) {
                storyLine.push({
                   focusRect: {x: 672, y: 6, width: 238, height: 70},
                   textRect: {x: 371, y: 217, width: 422, height: 89},
                   dock: {x: 489, y: 40},
                   duration: 11000,
                   text: qsTr("GUIDE_7"),
                   sound: "7.wma"
                });
            } else {
                storyLine.push({
                   focusRect: {x: 819, y: 39, width: 90, height: 35},
                   textRect: {x: 130 + 191, y: 227, width: 422, height: 45},
                   dock: {x: 130 + 550, y: 52},
                   duration: 6000,
                   text: qsTr("GUIDE_8"),
                   sound: "8.wma"
                });
            }

            storyLine.push({
               focusRect: {x: 265, y: 231, width: 0, height: 0},
               textRect: {x: 261, y: 227, width: 422, height: 45},
               dock: {x: 311, y: 227},
               duration: 6000,
               text: qsTr("GUIDE_9"),
               sound: "9.wma"
            });

            Guide.add(storyLine);
            Guide.show();
        }
    }
}
