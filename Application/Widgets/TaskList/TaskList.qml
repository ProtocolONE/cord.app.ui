/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import Tulip 1.0
import QtQuick 2.4
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Models 1.0

import "TaskList.js" as TaskListJs

WidgetModel {
    id: root

    function applyTaskList() {
        var elem
            , i
            , installDir = installPath.replace("file:///", "");

        TaskList.removeAll();

        var iconPath = StandardPaths.writableLocation(StandardPaths.DataLocation) + "/icons/";
        for (i = 0; i < Games.count; i++) {
            elem = Games.get(i);

            if (elem.gameType != "standalone") {
                continue;
            }

            var categoryId = (ApplicationStatistic.isServiceInstalled(elem.serviceId) || !!TaskListJs.installedServices[elem.serviceId]) ?
                                TaskListJs.installedCategory : TaskListJs.notInstalledCategory;

            TaskList.addItem(categoryId,
                             iconPath + elem.serviceId + ".ico",
                             elem.name,
                             "",
                             "startservice/" + elem.serviceId);
        }

        TaskList.addTask("", qsTr("TASK_LIST_SETTING"), "", "settings");
        TaskList.addTask("", qsTr("TASK_LIST_QUIT"), "", "quit");
        TaskList.apply();
    }

    function clear() {
        TaskList.removeAllTasks();
        TaskList.apply();
    }

    Connections {
        target: App.mainWindowInstance()

        ignoreUnknownSignals: true
        onDownloaderFinished: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            TaskListJs.installedServices[service] = 1;
            applyTaskList();
        }

        onAdditionalResourcesReady: {
            applyTaskList();
        }
    }

    Connections {
        target: SignalBus
        onExitApplication: root.clear()
        onAuthDone: root.applyTaskList();
    }

    Component.onCompleted: {
        TaskListJs.installedCategory = TaskList.addCategory(qsTr("TASK_LIST_ALL_GAMES"));
        TaskListJs.notInstalledCategory = TaskList.addCategory(qsTr("TASK_LIST_MORE_GAMES"));

        TaskList.setGuid("{F29F85E0-4FF9-1068-AB91-08002B27B3D9}");

        root.applyTaskList();
    }
}
