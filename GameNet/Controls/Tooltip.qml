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
import "../../Proxy/App.js" as App

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
        property bool tooltipGlueCenter: !!item ? item.tooltipGlueCenter : false;
        property string tooltipPosition: !!item ? item.tooltipPosition : '';

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

        function releaseAll() {
            root.opacity = 0;
            inner.tempItem = null
            showTimer.stop();
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
                topCheck = (point.y - root.height - arrow.height) > 0,
                topAlign = point.y + root.height < root.parent.height;

            switch (inner.tooltipPosition) {
            case 'N':
                topCheck = true;
                arrow.state = (leftCheck ? "left" : "right") + "Bottom";
                root.x = leftCheck ? point.x : (root.parent.x + root.parent.width - root.width);
                root.y = point.y - baseRect.height - arrow.height;
                break;
            case 'S':
                topCheck = false;
                root.x = leftCheck ? point.x : (root.parent.x + root.parent.width - root.width);
                root.y = point.y + inner.item.height +  arrow.height;
                arrow.state = (leftCheck ? "left" : "right") + "Top";
                break;
            case 'E':
                leftCheck = false;
                arrow.state = (topAlign ? "top" : "bottom") + "Right";
                root.x = point.x + inner.item.width + arrow.height;
                root.y = topAlign ? point.y : (point.y + inner.item.height - root.height);
                break;
            case 'W':
                leftCheck = true;
                arrow.state = (topAlign ? "top" : "bottom") + "Left";
                root.x = point.x - root.width - arrow.height;
                root.y = topAlign ? point.y : (point.y + inner.item.height - root.height);
                break;
            default:
                root.x = leftCheck ? point.x : (root.parent.x + root.parent.width - root.width);
                root.y = topCheck ? (point.y - baseRect.height - arrow.height) : (point.y + inner.item.height +  arrow.height);
                arrow.state = (leftCheck ? "left" : "right") + (topCheck ? "Bottom" : "Top");
                break;
            }

            var offset = inner.item.mapToItem(root, 0, 0);
            if (inner.tooltipGlueCenter) {
                if (inner.tooltipPosition == 'E' || inner.tooltipPosition == 'W') {
                    arrow.margin = inner.item.height / 2 - arrow.width / 2;
                } else {
                    arrow.margin = leftCheck ? (offset.x + inner.item.width / 2 - arrow.width / 2):
                                               (root.width - offset.x - inner.item.width / 2 - arrow.width / 2);
                }
            } else {
                if (inner.tooltipPosition == 'E' || inner.tooltipPosition == 'W') {
                    arrow.margin = 15;
                } else {
                    arrow.margin = leftCheck ? 15 : root.width - offset.x - inner.item.width + 15;
                }
            }
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
            onLinkActivated: App.openExternalUrl(link);
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
            },

            State {
                name: "topLeft"
                AnchorChanges { target: arrow; anchors { top: baseRect.top; left: baseRect.right } }
                PropertyChanges { target: arrow; anchors { topMargin: margin } }
                PropertyChanges { target: arrowImage; rotation: -90; x: -3; y: 3 }
            },
            State {
                name: "bottomLeft"
                AnchorChanges { target: arrow; anchors { bottom: baseRect.bottom; left: baseRect.right } }
                PropertyChanges { target: arrow; anchors { bottomMargin: margin } }
                PropertyChanges { target: arrowImage; rotation: -90; x: -3; y: -3 }
            },
            State {
                name: "topRight"
                AnchorChanges { target: arrow; anchors { top: baseRect.top; right: baseRect.left } }
                PropertyChanges { target: arrow; anchors { topMargin: margin } }
                PropertyChanges { target: arrowImage; rotation: 90; x: 3; y: 3 }
            },
            State {
                name: "bottomRight"
                AnchorChanges { target: arrow; anchors { bottom: baseRect.bottom; right: baseRect.left } }
                PropertyChanges { target: arrow; anchors { bottomMargin: margin } }
                PropertyChanges { target: arrowImage; rotation: 90; x: 3; y: -3 }
            }
        ]
    }
}
