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
import qGNA.Library 1.0
import "../Elements" as Elements

Rectangle {
    id: baseItem
    radius: 6
    color: "#00000000"

    width: 800
    height: 400

    //property string installPath: "../"

    property string fileVersion
    property int loadPercent
    property string loadText
    property string updateText
    property color updateTextColor: "white"
    property bool endAnimationStart: false
    property string versionString: qsTr("TEXT_VERSION").arg(fileVersion)

    signal finishAnimation()

    Image {
        id: logoImage
        x: 35
        y: 110
        source: installPath + "images/logo.png"
    }

    Text {
        id: startingGameNetText
        x: 35
        y: 245
        text: qsTr("TEXT_STARTING_APPLICATION")
        smooth: true
        color: "#ffffff"
        font.family: fontTahoma.name
        font.weight: "Light"
        font.pixelSize: 20
    }

    Text {
        id: loadingUpdatesText
        x: 35
        y: 275
        text: updateText
        smooth: true
        color: updateTextColor

        font.family: fontTahoma.name
        font.pixelSize: 16
        font.bold: false
    }

    Elements.ProgressBar {
        id: progressBar
        x: 500
        y: 258
        progressPercent: loadPercent
    }

    Text {
        id: versionTextId
        color: "#999999"
        text: versionString
        anchors.right: parent.right
        anchors.rightMargin: 32
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
        font.pixelSize: 11
    }

    SequentialAnimation {
        id: endAnimation
        running: endAnimationStart
        ParallelAnimation {
            NumberAnimation { target: progressBar; easing.type: Easing.OutQuad; property: "x"; from: 502; to: 602; duration: 250 }
            NumberAnimation { target: progressBar; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 300 }

            NumberAnimation { target: startingGameNetText; easing.type: Easing.OutQuad; property: "x"; from: 30; to: -34; duration: 250 }
            NumberAnimation { target: startingGameNetText; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 300 }

            NumberAnimation { target: loadingUpdatesText; easing.type: Easing.OutQuad; property: "x"; from: 30; to: -54; duration: 250 }
            NumberAnimation { target: loadingUpdatesText; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 300 }

            NumberAnimation { target: logoImage; easing.type: Easing.OutQuad; property: "scale"; from: 1; to: 0; duration: 300 }
            NumberAnimation { target: logoImage; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 300 }

            NumberAnimation { target: versionTextId; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 300 }
        }
        onCompleted: finishAnimation()
    }
}
