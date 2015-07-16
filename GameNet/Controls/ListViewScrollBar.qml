/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0

Rectangle {
    id: root

    property bool active: true

    property int cursorMode: ListView.Center

    property alias cursorRadius: cursor.radius
    property alias cursorColor: cursor.color
    property alias cursorOpacity: cursor.opacity

    property int cursorWheelStep: 2

    property int cursorHeight: 30
    property int cursorMaxHeight: 50
    property int cursorMinHeight: 20

    property int cursorMinPosition: 0
    property int cursorMaxPosition: root.height - cursorHeight

    //Какое количество элементов списка считается "большим". По этой величине нормируется величина прокрутеки,
    //т.е. если количество больше listViewCountLimit то размер курсора станет cursorMinHeight.
    property int listViewCountLimit: 100
    property int listViewCount: listView && listView.count > 0 ? listView.count - 1 : 0
    property variant listView
    property bool moving: cursorMouser.drag.active || (listView ? listView.moving : false)

    property int currentIndex

    property bool isPositionAtBeging: isAtBeging()
    property bool isPositionAtEnd: isAtEnd()

    //Событие кидается при прокрутке, указывая индекс и режим postionViewAtIndex для прокрутки максимально близкой к
    //той, что сейчас на экране.
    signal scrolling(int index, int mode);

    function isAtBeging() {
        return root.currentIndex <= 1;
    }

    function isAtEnd() {
        if (!root.listView) {
            return false;
        }

        var bottomIndex = root.listView.indexAt(0, root.listView.contentY + root.listView.height - 1);
        return bottomIndex + 1 >= listViewCount;
    }

    function updateCurrentIndex(y) {
        var relativeOffset = y / (root.height - cursorHeight);
        currentIndex = Math.min(listViewCount, Math.max(0, Math.round(listViewCount * relativeOffset)));
    }

    function click(mouseY) {
        updateCurrentIndex(mouseY)
        cursor.y = Math.min(cursorMaxPosition, Math.max(cursorMinPosition, mouseY));
    }

    function wheel(delta) {
        if (delta < 0) {
            currentIndex = Math.min(listViewCount, currentIndex + cursorWheelStep);
            root.scrolling(currentIndex, ListView.End);
        } else {
            currentIndex = Math.max(0, currentIndex - cursorWheelStep);
            root.scrolling(currentIndex, ListView.Beginning);
        }

        updateCursorY();
    }

    function updateCursorY() {
        cursor.y = Math.round(cursorMaxPosition * currentIndex / listViewCount);
    }

    function positionViewAtIndex(index, type) {
        if (type === undefined) {
            type = root.cursorMode;
        }

        root.currentIndex = index;
        root.listView.positionViewAtIndex(index, type);
        updateCursorHeight();
        cursor.y = Math.round(cursorMaxPosition * index / listViewCount);
    }

    function positionViewAtEnd() {
        if (!root.listView) {
            return;
        }

        root.currentIndex = listView.count - 1;
        root.listView.positionViewAtEnd();
        updateCursorHeight();
        cursor.y = cursorMaxPosition;
    }

    function positionViewAtBeginning() {
        if (!root.listView) {
            return;
        }

        root.currentIndex = 0;
        root.listView.positionViewAtBeginning();
        updateCursorHeight();
        cursor.y = 0;
    }

    function updateCursorHeight() {
        if (!listView) {
            return;
        }

        var scale = 1 - Math.min(listView.count - 1, listViewCountLimit) / listViewCountLimit,
            additionalHeight = scale * (cursorMaxHeight - cursorMinHeight);

        cursorHeight = cursorMinHeight + additionalHeight|0;
    }

    onCurrentIndexChanged: {
        if (!root.listView.moving) {
            listView.positionViewAtIndex(currentIndex, cursorMode);
        }
    }

    onListViewCountChanged: updateCursorHeight();
    onCursorMaxHeightChanged: updateCursorHeight();

    implicitWidth: 16
    implicitHeight: 500

    clip: true
    color: "grey"
    opacity: active ? 1 : 0

    Behavior on opacity {
        PropertyAnimation {
            duration: 250
        }
    }

    Timer {
        id: updateFlickIndex

        running: root.listView.moving
        interval: 30
        repeat: true
        onTriggered: {
            var index,
                mode;

            if (root.listView.verticalVelocity >= 0) {
                mode = ListView.End;
                index = root.listView.indexAt(0, root.listView.contentY + root.listView.height - 1);
            } else {
                mode = ListView.Beginning;
                index = root.listView.indexAt(0, root.listView.contentY);
            }

            if (index !== -1) {
                root.currentIndex = index;
                root.scrolling(index, mode);
                root.updateCursorY();
            }
        }
    }

    MouseArea {
        id: mouser

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onClicked: {
            cursorYBehaviour.enabled = false;
            root.click(mouseY)
            cursorYBehaviour.enabled = true;
        }

        Rectangle {
            id: cursor

            property int oldY: 0

            color: "#A3A3A3"
            height: root.cursorHeight
            width: parent.width
            onYChanged: {
                if (cursorMouser.drag.active) {
                    root.updateCurrentIndex(y);
                    root.scrolling(root.currentIndex, (y - oldY > 0) ? ListView.End : ListView.Beginning);
                    oldY = y;
                }
            }
            radius: 3
            opacity: cursorMouser.pressedButtons == Qt.LeftButton || cursorMouser.drag.active
                ? 1
                : cursorMouser.containsMouse ? 0.75 : 0.5

            Behavior on opacity {
                PropertyAnimation { duration: 250 }
            }

            Behavior on y {
                id: cursorYBehaviour

                PropertyAnimation { duration: 250 }
            }

            MouseArea {
                id: cursorMouser

                property bool shoudlReturnInteracive: false

                hoverEnabled: true
                anchors.fill: parent
                drag.target: parent
                drag.axis: Drag.YAxis
                drag.minimumY: root.cursorMinPosition
                drag.maximumY: root.cursorMaxPosition
                drag.filterChildren: true

                onPressed: {
                    if (root.listView.interactive) {
                        shoudlReturnInteracive = true;
                        root.listView.interactive = false;
                    }
                }
                onReleased: {
                    if (shoudlReturnInteracive) {
                        shoudlReturnInteracive = false;
                        root.listView.interactive = true;
                    }
                }
            }
        }
    }

    WheelArea {
        visible: !cursorMouser.drag.active
        anchors.fill: parent
        onVerticalWheel: root.wheel(delta)
    }
}
