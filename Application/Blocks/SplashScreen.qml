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
import GameNet.Controls 1.0

import "SplashScreen"
import "../Core/App.js" as App

Item {
    id: loadScreen

    width: App.clientWidth
    height: App.clientHeight

    Component.onCompleted: start();

    function start() {
        console.log("SplashScreen: updater started")

        background.start();
        progressBar.animated = true;
    }

    QtObject {
        id: d

        property bool isUpdateManagerFinished: false
        property bool isAnimationFinished: false

        property string updateText: qsTr("TEXT_INITIALIZATION")
        property int progress: 0

        function updateManagerFinished() {
            startingGameNetText.text = qsTr("TEXT_STARTING_APPLICATION");
            d.progress = 100;
            d.isUpdateManagerFinished = true;
            d.updateFinished();
        }

        function animationFinished() {
            d.isAnimationFinished = true;
            d.updateFinished();
        }

        function updateFinished() {
            if (d.isUpdateManagerFinished && d.isAnimationFinished) {
                closeAnimation.start();
            }
        }
    }

    TryLoader {
        id: updateManger

        source: "SplashScreen/UpdateManager.qml"
        onFailed: d.updateManagerFinished()
        onSuccessed: updateManger.item.start();

        Connections {
            target: updateManger.item

            onStatusChanged: d.updateText = msg
            onProgressChanged: d.progress = progress
            onFinished: d.updateManagerFinished()
        }
    }

    Background {
        id: background

        anchors.fill: parent
        onAnimationFinished: d.animationFinished();
    }

    ProgressBar {
        id: progressBar

        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; bottomMargin: 55 }
        height: 3
        animated: true
        progress: d.progress
        style {
            background: "#3E220D"
            line: "#FF6554"
        }
    }

    Text {
        anchors { right: parent.right; rightMargin: 10; bottom: parent.bottom; bottomMargin: 10 }
        color: "#ffffff"
        smooth: true
        font { family: "Segoe UI"; pixelSize: 11; }
        text: qsTr("TEXT_VERSION").arg(updateManger.item ? updateManger.item.fileVersion : "Debug")
    }

    Text {
        id: startingGameNetText

        anchors { left: parent.left; leftMargin: 20; bottom: parent.bottom; bottomMargin: 15 }
        color: "#ffffff"
        smooth: true
        font { family: "Segoe UI Light"; pixelSize: 18; }
        text: qsTr("TEXT_STARTING_APPLICATION") + ": " + d.updateText
    }

    SequentialAnimation {
        id: closeAnimation

        onCompleted: App.updateFinished()

        PropertyAction { target: closeMouseBlocker; property: "visible"; value: true }
        PauseAnimation { duration: 2000 }

        PropertyAction { target: progressBar; property: "animated"; value: false }
        PauseAnimation { duration: 200 }
    }

    MouseArea {
        id: closeMouseBlocker

        anchors.fill: parent
        hoverEnabled: true
        visible: false

        onPressed: App.backgroundMousePressed(mouseX, mouseY);
        onPositionChanged: {
            if (pressedButtons & Qt.LeftButton === Qt.LeftButton) {
                App.backgroundMousePositionChanged(mouseX, mouseY);
            }
        }
    }
}


