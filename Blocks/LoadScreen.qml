/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "../Elements" as Elements
import "../js/Core.js" as Core

Rectangle {
    id: baseItem

    //property string installPath: "../"

    property string fileVersion
    property int loadPercent
    property string loadText
    property string updateText
    property color updateTextColor: "#ffffff"
    property bool endAnimationStart: false
    property string versionString: qsTr("TEXT_VERSION").arg(fileVersion)

    signal finishAnimation()

    radius: 6
    color: "#00000000"
    width: Core.clientWidth
    height: Core.clientHeight

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
        text: qsTr("TEXT_STARTING_APPLICATION") + ": " + updateText
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
        text: versionString
        anchors { right: parent.right; rightMargin: 32;  }
        anchors { bottom: parent.bottom; bottomMargin: 50; }
        font { family: "Segoe UI"; pixelSize: 11; weight: Font.DemiBold; }
        opacity: 0.5
        smooth: true
    }

    SequentialAnimation {
        id: endAnimation

        running: endAnimationStart
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
}
