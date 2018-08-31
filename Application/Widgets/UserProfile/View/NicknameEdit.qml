import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0

Item {
    id: root

    property alias nickname: nickText.text
    property alias tooltip: cursorArea.toolTip
    property alias color: nickText.color

    signal nicknameClicked(var mouse, var area)

    onColorChanged: {
        triangleComponent.requestPaint()
    }

    Item {
        anchors.fill: parent

        Text {
            id: nickText

            height: root.height
            width: 90

            anchors.verticalCenter: parent.verticalCenter

            font { family: "Arial"; pixelSize: 16 }
            clip: true
            elide: Text.ElideRight            
        }

        Canvas {
            id: triangleComponent
            anchors.verticalCenter: parent.verticalCenter

            x: nickText.paintedWidth + 12
            y: 2

            // canvas size
            width: 7
            height: root.height / 2
            // handler to override for drawing
            onPaint: {
                // get context to draw with
                var ctx = getContext("2d")
                // setup the fill
                ctx.save();
                ctx.fillStyle = nickText.color
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

        anchors.fill: parent
        hoverEnabled: true
        tooltipGlueCenter: false
        tooltipPosition: "N"
        onClicked: {
              root.nicknameClicked(mouse, cursorArea)
        }
    }
}
