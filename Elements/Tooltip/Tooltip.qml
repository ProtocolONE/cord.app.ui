/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
** @author: Nikolay Bondarenko <nikolay.bondarenko@syncopate.ru>
** @since: 2.0
****************************************************************************/

import QtQuick 1.1
import "Tooltip.js" as Js

Item {
    id: root

    property int maxTextLen: 24

    visible: opacity > 0
    opacity: 0

    width: baseRect.width
    height: baseRect.height

    Behavior on opacity {
        PropertyAnimation { duration: 250 }
    }

    QtObject {
        id: inner

        property string text: !!item ? item.toolTip: ''
        property variant item;

        property variant tempItem;
        property variant tempText: !!tempItem ? tempItem.toolTip: '';

        function entered(item) {
            inner.tempItem = item
        }

        function exited(item) {
            root.opacity = 0;
            inner.tempItem = null
            showTimer.stop();
        }

        function release(item) {
            if (inner.item !== item) {
                return;
            }

            root.opacity = 0;
            inner.item = null;
        }

        function restartTimer() {
            if (tempText.length > 0 && !showTimer.running) {
                showTimer.restart();
            }
        }

        Component.onCompleted: Js.setup(inner)

        onTempItemChanged: restartTimer()
        onTempTextChanged: restartTimer()
    }

    Timer {
        id: showTimer

        interval: 350
        onTriggered: {
            if (!inner.tempItem) {
                return;
            }

            inner.item = inner.tempItem;
            inner.tempItem = null;
            root.opacity = 1;

            var point = inner.item.mapToItem(root.parent, 0, 0),
                leftCheck = (point.x + root.width) < root.parent.width,
                topCheck = (point.y - root.height) > 0;

            root.x = leftCheck
                ? point.x
                : (root.parent.x + root.parent.width - root.width)

            root.y = topCheck
                ? (point.y - baseRect.height - arrow.height)
                : (point.y + inner.item.height +  arrow.height)

            arrow.margin = leftCheck ? 15 : (root.x + root.width - point.x - 15 )
            arrow.state = (leftCheck ? "left" : "right") + (topCheck ? "Bottom" : "Top")
        }
    }

    Rectangle {
        id: baseRect

        width: textItem.width + 20
        height: textItem.height + 14
        color: "#f0f0dc"

        Text {
            id: textItem

            anchors.centerIn: parent
            font { family: "Arial"; pixelSize: 14 }
            text: inner.text
            wrapMode: Text.WordWrap
            onLinkActivated: Qt.openUrlExternally(link)
            color: "#333333"
            lineHeight: 1.1

            onTextChanged: {
              width = text.length > root.maxTextLen ? (root.maxTextLen * textItem.font.pixelSize) : undefined
              height = lineCount * (font.pixelSize + textItem.letterSpacing)
            }

            onWidthChanged: {
                if (width !== paintedWidth && paintedWidth > 0) {
                    width = paintedWidth
                }
            }
        }
    }

    Item {
        id: arrow

        property int margin: 15

        height: 7
        width: 13

        Image {
            id: arrowImage

            source: installPath + "images/elements/Tooltip/arrow.png"
        }

        states: [
            State {
                name: "leftTop"
                AnchorChanges { target: arrow; anchors { left: baseRect.left; bottom: baseRect.top } }
                PropertyChanges { target: arrow; anchors.leftMargin: margin; }
                PropertyChanges { target: arrowImage; rotation: 180 }
            },
            State {
                name: "rightTop"
                AnchorChanges { target: arrow; anchors { right: baseRect.right; bottom: baseRect.top } }
                PropertyChanges { target: arrow; anchors { rightMargin: margin } }
                PropertyChanges { target: arrowImage; rotation: 180 }
            },
            State {
                name: "leftBottom"
                AnchorChanges { target: arrow; anchors { left: baseRect.left; top: baseRect.bottom } }
                PropertyChanges { target: arrow; anchors { leftMargin: margin; } }
            },

            State {
                name: "rightBottom"
                AnchorChanges { target: arrow; anchors { right: baseRect.right; top: baseRect.bottom } }
                PropertyChanges { target: arrow; anchors { rightMargin: margin } }
            }
        ]
    }
}
