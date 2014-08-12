/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Application.Controls 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../Core/Styles.js" as Styles

WidgetView {
    id: root

    implicitWidth: 630
    implicitHeight: allContent.height + 40
    clip: true

    default property alias data: container.data
    property alias title: titleText.text

    property color defaultBackgroundColor: Styles.style.popupBackground
    property color defaultTitleColor: Styles.style.popupTitleText
    property color defaultTextColor: Styles.style.popupText

    Rectangle {
        anchors.fill: parent
        color: defaultBackgroundColor
    }

    Column {
        id: allContent

        height: childrenRect.height
        width: childrenRect.width

        y: 20
        spacing: 20

        Text {
            id: titleText

            anchors {
                left: parent.left
                leftMargin: 20
            }
            width: allContent.width - 40
            font {
                family: 'Arial'
                pixelSize: 20
            }
            color: Styles.style.popupTitleText
            smooth: true
            text: "Title"
        }

        PopupHorizontalSplit {
            width: root.width
        }

        Column {
            id: container

            spacing: 20

            height: childrenRect.height
            width: childrenRect.width
        }
    }
}
