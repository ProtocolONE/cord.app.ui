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

import "../Elements" as Elements
import "../Blocks" as Blocks
import "../js/Core.js" as Core

Rectangle {
    id: loadScreen

    //property string installPath: "../"

    signal finishAnimation()

    radius: 6
    color: "#00000000"
    width: Core.clientWidth
    height: Core.clientHeight

    QtObject {
        id: d

        property bool endAnimationStart: false
        property string updateText: qsTr("TEXT_INITIALIZATION")
        property int loadPercent: 0
    }

    Image {
        id: logoImage

        x: 25
        y: 30
        source: installPath + "images/logo.png"
    }

    Image {
        id: backTextImage

        x: 90
        y: 40
        smooth: true
        source: installPath + "images/gamenet.png"
    }

    Text {
        id: startingGameNetText

        x: 30
        y: 465
        text: qsTr("TEXT_STARTING_APPLICATION") + ": " + d.updateText
        smooth: true
        color: "#ffffff"
        font { family: "Segoe UI Light"; pixelSize: 30; }
    }

    Elements.ProgressBar {
        id: progressBar

        width: parent.width

        x: 0
        y: 440
    }

    Text {
        id: versionTextId

        color: "#ffffff"
        text: qsTr("TEXT_VERSION").arg(mainWindow.fileVersion)
        anchors { right: parent.right; rightMargin: 32;  }
        anchors { bottom: parent.bottom; bottomMargin: 50; }
        font { family: "Segoe UI"; pixelSize: 11; weight: Font.DemiBold; }
        opacity: 0.5
        smooth: true
    }

    SequentialAnimation {
        id: endAnimation

        running: d.endAnimationStart
        onCompleted: finishAnimation()

        ParallelAnimation {
            NumberAnimation { target: progressBar; easing.type: Easing.OutQuad; property: "x"; from: 0; to: 602; duration: 250 }
            NumberAnimation { target: progressBar; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 300 }

            NumberAnimation { target: startingGameNetText; easing.type: Easing.OutQuad; property: "x"; from: 30; to: -34; duration: 250 }
            NumberAnimation { target: startingGameNetText; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 300 }

            NumberAnimation { target: logoImage; easing.type: Easing.OutQuad; property: "scale"; from: 1; to: 0; duration: 300 }
            NumberAnimation { target: logoImage; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 300 }

            NumberAnimation { target: versionTextId; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 300 }
        }
    }

    Timer {
        id: changeTextTimer

        interval: 1500; running: false; repeat: false
        onTriggered: {
            d.updateText =  qsTr("TEXT_RETRY_UPDATE_CHECK")
        }
    }

    Blocks.TryLoader {
        id: updateManager

        source: "LoadScreen/UpdateManager.qml"
        onFailed: console.log('Can not load Update Manager');
        onSuccessed: console.log('Update Manager');
    }

    Connections {
        target: updateManager.item

        onDownloadUpdateProgress: {
            d.loadPercent = 100 * (currentSize / totalSize);
        }

        onUpdatesFound: {
            changeTextTimer.stop();
            console.log("[DEBUG][QML] Found updates.")
            console.log("[DEBUG][QML] Installing updates.");
            installUpdates();
        }

        onNoUpdatesFound: {
            changeTextTimer.stop();
            console.log("[DEBUG][QML] Updates not found.")
        }

        onDownloadRetryNumber: {
            d.updateText = qsTr("TEXT_RETRY_UPDATE_CHECK")
            changeTextTimer.start();
        }

        onAllCompleted: {
            changeTextTimer.stop();
            if (isNeedRestart) {
                mainWindow.restartApplication()
            } else {
                mainWindow.startBackgroundCheckUpdate();
            }

            console.log("[DEBUG][QML] Update complete with state " + updateManager.item.updateState);

            d.endAnimationStart = true
        }

        onUpdateStateChanged: {
            changeTextTimer.stop();
            if (updateManager.item.updateState == 0)
                d.updateText = qsTr("TEXT_CHEKING_FOR_UPDATE")
            else if (updateManager.item.updateState == 1) {
                d.updateText = qsTr("TEXT_DOWNLOADING_UPDATE")
            }
        }

        onUpdateError: {
            d.loadPercent = 100;
            changeTextTimer.start();

            if (errorCode > 0 ) {
                if (updateManager.item.updateState == 0)
                    d.updateText = qsTr("TEXT_ERROR_UPDATE_CHECK")
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

    Component.onCompleted: {
        console.log("[DEBUG][QML] Updater started")

        updateManager.item.startCheckUpdate();
    }
}


