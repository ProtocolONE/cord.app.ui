/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
** @author: Ilya Tkachenko <ilya.tkachenko@syncopate.ru>
** @since: 2.0
****************************************************************************/

import QtQuick 2.4
import qGNA.Library 1.0

import Application.Core 1.0
import GameNet.Core 1.0

Item {
    id: rootItem

    property string fileVersion: mainWindow.fileVersion

    signal statusChanged(string msg);
    signal progressChanged(int progress);
    signal finished();
    signal globalMaintenance(bool status, string text);

    onFinished: d.isFinished = true;

    QtObject {
        id: d

        property bool isFinished: false

        function finished() {
            if (!d.isFinished && App.mainWindowInstance().isInitCompleted()) {
                mainWindow.updateFinishedSlot();
                rootItem.finished();
            }
        }

        function updateProgressState() {
            if (model.updateState == 0)
                rootItem.statusChanged(qsTr("CHECK_UPDATE")) // "Проверка обновлений"
            else if (model.updateState == 1){
                rootItem.statusChanged(qsTr("LOAD_UPDATE")) // Загрузка обновлений
            }
        }
    }

    function start() {
        if (App.mainWindowInstance().isInitCompleted()) {
            delayTimer.start();
        }
    }

    Timer {
        id: delayTimer

        interval: 1000
        onTriggered: d.finished();
    }

    Timer {
        id: changeTextTimer

        interval: 1500
        running: false
        repeat: false
        onTriggered: rootItem.statusChanged(qsTr("RETRY_CHECKING_UPDATE")) // Retry checking for updates...
    }

    Timer {
        id: globalMaintetanceCheck

        interval: 300000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            RestApi.http.request("https://gnapi.com/status.json", function(data){
                var message,
                    obj;

                if (data.status != 200) {
                    rootItem.globalMaintenance(false, "")
                    globalMaintetanceCheck.stop();
                    return;
                }

                try {
                    obj = JSON.parse(data.body);
                    message = obj.message;
                } catch (e) {
                    message = qsTr("Упс, кажется у нас идут плановые технические работы.");
                }
                rootItem.globalMaintenance(true, message);
            })
        }
    }

    Connections {
        target: App.mainWindowInstance()

        onInitCompleted: {
            d.finished();
            console.log('onInitCompleted finished signal');
        }
    }

    UpdateViewModel {
        id: model

        onDownloadUpdateProgress: {
            rootItem.progressChanged(100 * (currentSize / totalSize));
            d.updateProgressState();
        }

        onNoUpdatesFound: {
            rootItem.progressChanged(100);
            changeTextTimer.stop();
            console.log("[DEBUG][QML] Updates not found.")
        }

        onUpdateStateChanged: {
            changeTextTimer.stop();
            console.log('onUpdateStateChanged', model.updateState);

            d.updateProgressState();
        }

        onDownloadRetryNumber: {
            rootItem.statusChanged(qsTr("LOAD_UPDATE_RETRY_WARNING")); // "Повторная попытка проверки обновлений"
            changeTextTimer.start();
        }

        onAllCompleted: {
            changeTextTimer.stop();

            console.log("[DEBUG][QML] Update complete with state " + updateState);
        }

        onUpdateError: {
            if (errorCode == UpdateInfoGetterResults.NotEnoughSpace) {
                rootItem.statusChanged(qsTr("UPDATE_ERROR_NOT_ENOUGH_SPACE"), errorCode);
                return;
            }

            rootItem.progressChanged(100);
            changeTextTimer.start();

            if (errorCode > 0 ){
                if (updateState == 0)
                    rootItem.statusChanged(qsTr("UPDATE_ERROR"), errorCode) // "Ошибка проверки обновлений."
            }

            switch(errorCode) {
                case UpdateInfoGetterResults.NoError: console.log("Update no error"); break;
                case UpdateInfoGetterResults.DownloadError: console.log("Update download error"); break;
                case UpdateInfoGetterResults.ExtractError: console.log("Update extract error"); break;
                case UpdateInfoGetterResults.XmlContentError: console.log("Update xml content error"); break;
                case UpdateInfoGetterResults.BadArguments: console.log("Update bad arguments"); break;
                case UpdateInfoGetterResults.CanNotDeleteOldUpdateFiles: console.log("Update CanNotDeleteOldUpdateFiles"); break;
            }
        }
    }
}
