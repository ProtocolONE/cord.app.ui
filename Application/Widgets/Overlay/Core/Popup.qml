/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0

Item {
    id: root

    property int spacing: 5

    function getPopupContentParent() {
        return popupColumn;
    }

    anchors {
        right: parent.right
        bottom: parent.bottom
        margins: 5
    }

    width: popupColumn.width
    height: 800
    visible: popupColumn.children.length > 0

    Item {
        anchors.fill: parent

        Column {
            id: popupColumn

            anchors.top: parent.bottom
            width: 240
            spacing: 10
            transform: Rotation { angle: 180 }

            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
