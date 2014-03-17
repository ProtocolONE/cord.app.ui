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

//UNDONE Горизонтальный скрол. Родительский элемент, как и вообще вся вёрстка в этом приложении не содержит
//горизонтальной прокрутки. Я оставил части кода, её реализующие из оригинального контрола. При необходимости её
//можно быстро дописать.
//Nikolay Bondarenko<nikolay.bondarenko@syncopate.ru>
Item {
    id: scrollBarElement

    property int scrollbarWidth: 16
    property variant flickable
    property bool vertical: true

    clip: true

    width: vertical ? scrollbarWidth : parent.width
    height: vertical ? parent.height : scrollbarWidth

    x: vertical ? parent.width - width : 0
    y: vertical ? 0 : parent.height - height

    Item {
        anchors.fill: parent

        MouseArea {
            id: scrollMouser

            anchors.fill: parent
            visible: flickable.contentHeight > height

            acceptedButtons: Qt.LeftButton
            hoverEnabled: true

            drag.axis: vertical ? Drag.YAxis : Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: scrollBarElement.width - thumb.width
            drag.minimumY: 0
            drag.maximumY: scrollBarElement.height - thumb.height

            function move() {
                var step = flickable.contentHeight / scrollBarElement.height * thumb.height

                if (scrollMouser.mouseY < thumb.y) {
                    flickable.contentY = Math.max(0, flickable.contentY - step)
                } else if(scrollMouser.mouseY > (thumb.y + thumb.height)) {
                    flickable.contentY =
                        Math.min(flickable.contentHeight - scrollBarElement.height, flickable.contentY + step)
                }
            }

            onPositionChanged: {
                if (mouse.buttons === 1) {
                    flickable.contentY = flickable.contentHeight / height * thumb.y
                }
             }

            onPressed: {
                if (mouseY >= thumb.y && mouseY <= (thumb.y + thumb.height)) {
                   drag.target = thumb;
                } else {
                   drag.target = null
                   moveTick.start();
                }
            }

            onReleased: moveTick.stop();

            Timer {
                id: moveTick
                interval: 150
                repeat: true
                triggeredOnStart: true
                onTriggered: scrollMouser.move()
            }
        }

        Item {
            id: thumb


            function containsMouse() {
                return (scrollMouser.containsMouse || scrollMouser.drag.active || flickable.moving);
            }

            //color: "#00000000"

            width: vertical
                    ? scrollbarWidth //(thumb.containsMouse() ? scrollbarWidth : 2)
                    : flickable.visibleArea.widthRatio * parent.width
            height: vertical
                    ? flickable.visibleArea.heightRatio * parent.height
                    : scrollbarWidth

            x: vertical
               ? parent.width - width
               : flickable.visibleArea.xPosition * parent.width
            y: vertical
               ? flickable.visibleArea.yPosition * parent.height
               : parent.height - height

            opacity: thumb.containsMouse() ? 1 : 0//.25

            Behavior on opacity { NumberAnimation { duration: 200 } }
            Behavior on width { NumberAnimation { duration: 150 } }

            Rectangle {
                width: parent.width
                height: parent.height
                color: "#A3A3A3"
            }

//            Image {
//                width: parent.width
//                height: parent.height
//                fillMode: Image.TileVertically
//                smooth: true
//                source: installPath + "images/scroll-navigation.png"
//            }

//            Image {
//                anchors.centerIn: parent
//                fillMode: Image.PreserveAspectFit
//                source: installPath + "images/scroll-navigation-c.png"
//                visible: parent.height > height && parent.width > width
//            }

            Elements.CursorShapeArea {
                anchors.fill: parent
                visible: scrollMouser.visible
            }
        }
    }
}
