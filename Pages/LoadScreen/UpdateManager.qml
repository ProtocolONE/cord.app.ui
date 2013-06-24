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

import QtQuick 1.1
import qGNA.Library 1.0

Item {
    id: rootItem

    property string fileVersion: mainWindow.fileVersion

    signal statusChanged(string msg);
    signal progressChanged(int progress);
    signal finished();

    function start() {
        updateManager.startCheckUpdate();
    }

    Timer {
        id: changeTextTimer

        interval: 1500
        running: false
        repeat: false
        onTriggered: rootItem.statusChanged(qsTr("RETRY_CHECKING_UPDATE")) // Retry checking for updates...
    }

    UpdateManagerViewModel {
        id: updateManager

        installPath: mainWindow.installUpdateGnaPath
        updateUrl: mainWindow.updateUrl

        onDownloadUpdateProgress: rootItem.progressChanged(100 * (currentSize / totalSize));

        onUpdatesFound: {
            changeTextTimer.stop();
            console.log("[DEBUG][QML] Found updates. Installing updates.")
            installUpdates();
        }

        onNoUpdatesFound: {
            rootItem.progressChanged(100);
            changeTextTimer.stop();
            console.log("[DEBUG][QML] Updates not found.")
        }

        onDownloadRetryNumber: {
            rootItem.statusChanged(qsTr("LOAD_UPDATE_RETRY_WARNING")); // "Повторная попытка проверки обновлений"
            changeTextTimer.start();
        }

        onAllCompleted: {
            changeTextTimer.stop();

            if (isNeedRestart) {
                mainWindow.restartApplication()
                return;
            } else {
                mainWindow.startBackgroundCheckUpdate();
                rootItem.finished();
            }

            mainWindow.updateFinishedSlot();
            console.log("[DEBUG][QML] Update complete with state " + updateState);
        }

        onUpdateStateChanged: {
            changeTextTimer.stop();
            if (updateState == 0)
                rootItem.statusChanged(qsTr("CHECK_UPDATE")) // "Проверка обновлений"
            else if (updateState == 1){
                rootItem.statusChanged(qsTr("LOAD_UPDATE")) // Загрузка обновлений
            }
        }

        onUpdateError: {
            rootItem.progressChanged(100);
            changeTextTimer.start();

            if (errorCode > 0 ){
                if (updateState == 0)
                    rootItem.statusChanged(qsTr("UPDATE_ERROR"), errorCode) // "Ошибка проверки обновлений."
            }

            switch(errorCode) {
                case UpdateInfoGetterResults.NoError: console.log("[DEBUG][QML] Update no error"); break;
                case UpdateInfoGetterResults.DownloadError: console.log("[DEBUG][QML] Update download error"); break;
                case UpdateInfoGetterResults.ExtractError: console.log("[DEBUG][QML] Update extract error"); break;
                case UpdateInfoGetterResults.XmlContentError: console.log("[DEBUG][QML] Update xml content error"); break;
                case UpdateInfoGetterResults.BadArguments: console.log("[DEBUG][QML] Update bad arguments"); break;
                case UpdateInfoGetterResults.CanNotDeleteOldUpdateFiles: console.log("[DEBUG][QML] Update CanNotDeleteOldUpdateFiles"); break;
            }
        }
    }

}
