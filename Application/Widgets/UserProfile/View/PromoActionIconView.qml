/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2017, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

WidgetView {
    id: root

    property bool isPromoActionActive: model.isPromoActionActive
    property int animationDuration: 4000

    implicitHeight: 2
    implicitWidth: 2

    Rectangle {
        id: rect

        anchors.centerIn: parent
        width: 20
        height: width
        radius: width/2
        color: "#EEAA00"
        clip: true

        ParallelAnimation {
            running: root.visible
            loops: Animation.Infinite

            SequentialAnimation {
                ColorAnimation { target: rect; property: "color"; to: "#464E56"; duration: animationDuration }
                ColorAnimation { target: rect; property: "color"; to: "#EEAA00"; duration: animationDuration }
            }

            SequentialAnimation {
                NumberAnimation {
                    target: rect
                    property: "width"
                    duration: animationDuration
                    to: 10
                    easing.type: Easing.InOutBack
                }

                NumberAnimation {
                    target: rect
                    property: "width"
                    duration: animationDuration
                    to: 20
                    easing.type: Easing.InOutBack
                }
            }
        }
    }
}
