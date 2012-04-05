/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
** @author: Ilya Tkachenko <ilya.tkachenko@syncopate.ru>
** @since: 2.0
****************************************************************************/

import QtQuick 1.1

Item {
    id: root

    property bool opacityHover: false
    property alias hoverEnabled: mouser.hoverEnabled

    property color color: root.opacityHover ? "#FFFFFF" : "#5c5c5c"
    property color highlightColor: root.opacityHover ? "#FFFFFF" : "#999999"

    property bool selected: false
    property alias source: image.source
    property alias toolTip: mouser.toolTip
    property bool containsMouse: mouser.containsMouse

    property double defaultOpacity : 0.2
    property double hoverOpacity : 0.5

    property int notifyCount: 0

    signal clicked();

    implicitHeight: 44
    implicitWidth: 44

    Rectangle {
        opacity: root.opacityHover ? (root.containsMouse ? root.hoverOpacity : root.defaultOpacity) : 1
        anchors { fill: parent; rightMargin: 1; bottomMargin: 1 }
        border {
            width: 1;
            color: root.containsMouse ? root.highlightColor : root.color
            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        color: root.selected ? border.color : "#00000000"

        Rectangle {
            anchors { left: parent.left; top: parent.top; leftMargin: 4; topMargin: 4 }
            width: 17
            height: 17
            color: "#ff7702"
            visible: notifyCount > 0

            Text {
                anchors.centerIn: parent
                font { pixelSize: notifyCount > 9 ? 20 : 12; family: "Arial"}
                color: "#ffffff"
                text: notifyCount > 9 ? "∞" : notifyCount
            }
        }
    }

    Image {
        id: image

        anchors.centerIn: parent
    }

    CursorMouseArea {
        id: mouser

        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked();
    }
}
