import QtQuick 2.4

Item {
    id: root

    property int maxTextLen: 24
    property int animationDuration: animation.duration

    signal linkActivated(string link)

    visible: opacity > 0
    opacity: 0

    width: baseRect.width
    height: baseRect.height

    Behavior on opacity {
        PropertyAnimation {
            id: animation

            duration: 250
        }
    }

    property string text: !!item ? item.toolTip : ''
    property variant item

    property variant tempItem
    property variant tempText: !!tempItem ? tempItem.toolTip: ''
    property bool tooltipGlueCenter: !!item ? item.tooltipGlueCenter : false
    property string tooltipPosition: !!item ? item.tooltipPosition : ''

    function entered(item) {
        tempItem = item;
    }

    function exited(item) {
        root.opacity = 0;
        root.tempItem = null;
        showTimer.stop();
    }

    function release(item) {
        if (root.item !== item) {
            return;
        }

        root.opacity = 0;
        root.item = null;
    }

    function releaseAll() {
        root.opacity = 0;
        root.tempItem = null;
        showTimer.stop();
    }

    function restartTimer() {
        if (root.tempText.length > 0 && !showTimer.running) {
            showTimer.restart();
        }
    }

    onTempItemChanged: restartTimer();
    onTempTextChanged: restartTimer();

    Timer {
        id: showTimer

        interval: 350
        onTriggered: {
            if (!root.tempItem) {
                return;
            }

            root.item = root.tempItem;
            root.tempItem = null;
            root.opacity = 1;

            var point = root.item.mapToItem(root.parent, 0.0, 0.0),
                    leftCheck = (point.x + root.width) < root.parent.width,
                    topCheck = (point.y - root.height - arrow.height) > 0,
                    topAlign = point.y + root.height < root.parent.height;

            switch (root.tooltipPosition) {
            case 'N':
                topCheck = true;
                arrow.state = (leftCheck ? "left" : "right") + "Bottom";
                root.x = leftCheck ? point.x : (root.parent.x + root.parent.width - root.width);
                root.y = point.y - baseRect.height - arrow.height;
                break;
            case 'S':
                topCheck = false;
                root.x = leftCheck ? point.x : (root.parent.x + root.parent.width - root.width);
                root.y = point.y + root.item.height +  arrow.height;
                arrow.state = (leftCheck ? "left" : "right") + "Top";
                break;
            case 'E':
                leftCheck = false;
                arrow.state = (topAlign ? "top" : "bottom") + "Right";
                root.x = point.x + root.item.width + arrow.height;
                root.y = topAlign ? point.y : (point.y + root.item.height - root.height);
                break;
            case 'W':
                leftCheck = true;
                arrow.state = (topAlign ? "top" : "bottom") + "Left";
                root.x = point.x - root.width - arrow.height;
                root.y = topAlign ? point.y : (point.y + root.item.height - root.height);
                break;
            default:
                root.x = leftCheck ? point.x : (root.parent.x + root.parent.width - root.width);
                root.y = topCheck ? (point.y - baseRect.height - arrow.height) : (point.y + root.item.height +  arrow.height);
                arrow.state = (leftCheck ? "left" : "right") + (topCheck ? "Bottom" : "Top");
                break;
            }

            var offset = root.item.mapToItem(root, 0.0, 0.0);
            if (root.tooltipGlueCenter) {
                if (root.tooltipPosition == 'E' || root.tooltipPosition == 'W') {
                    arrow.margin = root.item.height / 2 - arrow.width / 2;
                } else {
                    arrow.margin = leftCheck ? (offset.x + root.item.width / 2 - arrow.width / 2):
                                               (root.width - offset.x - root.item.width / 2 - arrow.width / 2);
                }
            } else {
                if (root.tooltipPosition == 'E' || root.tooltipPosition == 'W') {
                    arrow.margin = 15;
                } else {
                    arrow.margin = leftCheck ? 15 : root.width - offset.x - root.item.width + 15;
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
            text: root.text
            wrapMode: Text.WordWrap
            onLinkActivated: root.linkActivated((link))
            color: "#333333"
            lineHeight: 1.1

            onTextChanged: {
                width = textItem.text.length > root.maxTextLen ? (root.maxTextLen * textItem.font.pixelSize) : undefined;
                height = lineCount * (font.pixelSize + textItem.letterSpacing);
            }

            onWidthChanged: {
                if (width !== paintedWidth && paintedWidth > 0) {
                    width = paintedWidth;
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

            source: installPath + "Assets/Images/GameNet/Controls/Tooltip/arrow.png"
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
