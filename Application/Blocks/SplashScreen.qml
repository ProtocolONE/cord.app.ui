import QtQuick 2.4
import ProtocolOne.Controls 1.0

import "SplashScreen"
import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Controls 1.0

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
            startingProtocolOneText.text = qsTr("TEXT_STARTING_APPLICATION");
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
            onGlobalMaintenance: {
                background.showBack = !status;
                background.infoText = text;
            }
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
        anchors {
            right: parent.right
            rightMargin: 10
            baseline: parent.bottom
            baselineOffset: -15
        }

        color: "#ffffff"
        smooth: true
        font { family: "Segoe UI Light"; pixelSize: 11; }
        text: qsTr("TEXT_VERSION").arg(updateManger.item ? updateManger.item.fileVersion : "Debug")
    }

    Text {
        anchors {
            baseline: parent.bottom
            baselineOffset: -15
            horizontalCenter: parent.horizontalCenter
        }

        color: "#ffffff"
        smooth: true
        font { family: "Segoe UI Light"; pixelSize: 11; }
        text: "Powered by Protocol One"
    }

    Text {
        id: startingProtocolOneText

        anchors {
            left: parent.left
            leftMargin: 20
            baseline: parent.bottom
            baselineOffset: -15
        }

        color: "#ffffff"
        smooth: true
        font { family: "Segoe UI Light"; pixelSize: 18; }
        text: qsTr("TEXT_STARTING_APPLICATION") + ": " + d.updateText
    }

    SequentialAnimation {
        id: closeAnimation

        onStopped : SignalBus.updateFinished()

        PropertyAction { target: closeMouseBlocker; property: "visible"; value: true }
        PauseAnimation { duration: 2000 }

        PropertyAction { target: progressBar; property: "animated"; value: false }
        PauseAnimation { duration: 200 }
    }

    DragWindowArea {
        id: closeMouseBlocker

        anchors.fill: parent
        hoverEnabled: true
        visible: false
    }
}


