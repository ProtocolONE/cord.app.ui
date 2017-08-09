/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0

Item {
    id: root

    property alias nickname: nickText.text
    property alias tooltip: cursorArea.toolTip
    property alias color: nickText.color

    signal nicknameClicked()

    Row {

        spacing: 10
        anchors.fill: parent

        Text {
            id: nickText
            font { family: "Arial"; pixelSize: 16 }
            clip: true
            elide: Text.ElideRight
        }

        Canvas {
            id: triangleComponent
            anchors.verticalCenter: parent.verticalCenter

            // canvas size
            width: 7
            height: root.height / 2
            // handler to override for drawing
            onPaint: {
                // get context to draw with
                var ctx = getContext("2d")
                // setup the fill
                ctx.save();
                ctx.fillStyle = "#FFFFFF"
                // begin a new path to draw
                ctx.beginPath()
                ctx.globalAlpha = 0.25;
                ctx.moveTo(0, 0)
                ctx.lineTo(width, 0)
                ctx.lineTo(width / 2, height)
                // left line through path closing
                ctx.closePath()
                // fill using fill style
                ctx.fill()
                ctx.restore()
            }
        }
    }


    CursorMouseArea {
        id: cursorArea

        acceptedButtons: Qt.LeftButton
        anchors.fill: parent
        hoverEnabled: true
        tooltipGlueCenter: false
        tooltipPosition: "N"
        onClicked: {
            root.nicknameClicked()
        }
    }
}
