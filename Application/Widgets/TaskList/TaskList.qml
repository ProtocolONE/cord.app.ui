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
import QtQuick 1.1
import "../../../js/Core.js" as Core
import "TaskList.js" as TaskListJs

Item {

    function applyTaskList() {
        var elem
            , i
            , installDir = installPath.replace("file:///", "")
            , model = Core.gamesListModel;

        TaskList.removeAll();

        for (i = 0; i < model.count; i++) {
            elem = model.get(i);

            if (elem.gameType != "standalone") {
                continue;
            }

            var categoryId = (Core.isServiceInstalled(elem.serviceId) || !!TaskListJs.installedServices[elem.serviceId]) ?
                                TaskListJs.installedCategory : TaskListJs.notInstalledCategory;

            TaskList.addItem(categoryId,
                             installDir + "Assets/Images/icons/" + elem.serviceId + ".ico",
                             elem.name,
                             "",
                             "-startservice " + elem.serviceId);
        }

        TaskList.addTask("", qsTr("TASK_LIST_SETTING"), "", "-settings ");
        TaskList.addTask("", qsTr("TASK_LIST_QUIT"), "", "-quit ");
        TaskList.apply();
    }

    Connections {
        target: mainWindow

        ignoreUnknownSignals: true
        onDownloaderFinished: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            TaskListJs.installedServices[service] = 1;
            applyTaskList();
        }
    }

    Component.onCompleted: {
        TaskListJs.installedCategory = TaskList.addCategory(qsTr("TASK_LIST_ALL_GAMES"));
        TaskListJs.notInstalledCategory = TaskList.addCategory(qsTr("TASK_LIST_MORE_GAMES"));

        TaskList.setGuid("{F29F85E0-4FF9-1068-AB91-08002B27B3D9}");

        applyTaskList();
    }

    Component.onDestruction: {
        TaskList.removeAllTasks();
        TaskList.apply();
    }
}
