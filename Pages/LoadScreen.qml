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

Item {
    id: loadScreen

    signal updateFinished()

    width: Core.clientWidth
    height: Core.clientHeight

    QtObject {
        id: d

        property string updateText: qsTr("TEXT_INITIALIZATION")
        property int progress: 0

        function updateFinished() {
            startingGameNetText.text = qsTr("TEXT_STARTING_APPLICATION");
            closeAnimation.start();
            loadScreen.updateFinished();
        }
    }

    Image {
        source: installPath +  "images/abstraction.png"
        anchors.top: parent.top
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

        y: 440
        height: 1
        width: parent.width
        running: false
        progress: d.progress
    }

    Text {
        id: versionTextId

        color: "#ffffff"
        text: qsTr("TEXT_VERSION").arg(updateManger.item ? updateManger.item.fileVersion : "Debug")
        anchors { right: parent.right; rightMargin: 32;  }
        anchors { bottom: parent.bottom; bottomMargin: 50; }
        font { family: "Segoe UI"; pixelSize: 11; weight: Font.DemiBold; }
        opacity: 0.5
        smooth: true
    }

    SequentialAnimation {
        id: closeAnimation

        onCompleted: loadScreen.visible = false

        PauseAnimation { duration: 2000 }

        PropertyAction { target: progressBar; property: "running"; value: "false" }
        PauseAnimation { duration: 200 }
        PropertyAnimation {
            target: loadScreen
            property: "opacity"
            to: 0
            duration: 1000
        }
    }

    Connections {
        target: updateManger.item
        onStatusChanged: d.updateText = msg
        onProgressChanged: d.progress = progress
        onFinished: d.updateFinished()
    }

    Blocks.TryLoader {
        id: updateManger

        source: "LoadScreen/UpdateManager.qml"
        onFailed: d.updateFinished()
        onSuccessed: updateManger.item.start();
    }

    Component.onCompleted: {
        console.log("[DEBUG][QML] Updater started")
        progressBar.running = true;
    }
}


