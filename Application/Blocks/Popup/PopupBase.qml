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

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0

import "../../Core/Styles.js" as Styles

WidgetView {
    id: root

    implicitWidth: 630
    implicitHeight: allContent.height + 30
    clip: true

    default property alias data: container.data
    property alias title: titleText.text

    property int defaultMargins: 50
    property color defaultBorderColor: Styles.style.popupBorder
    property color defaultBackgroundColor: Styles.style.popupBackground
    property color defaultTitleColor: Styles.style.popupTitleText
    property color defaultTextColor: Styles.style.popupText

    Rectangle {
        anchors.fill: parent
        color: defaultBackgroundColor
        border {
            color: defaultBorderColor
            width: 2 //INFO Визуально он однопиксельный, т.к. clip у родителя. Иначе нужно мучаться с отступами
        }
    }

    Column {
        id: allContent

        height: childrenRect.height
        anchors {
            left: parent.left
            right: parent.right
            margins: defaultMargins
        }

        spacing: 30

        Item {
            width: parent.width
            height: 50

            Text {
                id: titleText

                anchors {
                    baseline: parent.top
                    baselineOffset: 50
                }
                width: parent.width
                font {family: 'Open Sans Light'; pixelSize: 30}
                color: defaultTitleColor
                elide: Text.ElideRight
                smooth: true
                text: "Title"
            }
        }

        Column {
            id: container

            spacing: 20

            height: childrenRect.height
            width: parent.width
        }
    }

    ImageButton {
        anchors {
            right: parent.right
            top: parent.top
            margins: 5
        }
        width: 30
        height: 30

        style {
            normal: "#00000000"
            hover: "#00000000"
        }

        styleImages {
            normal: installPath + 'Assets/Images/Application/Core/Popup/close.png'
            hover: installPath + 'Assets/Images/Application/Core/Popup/close_hover.png'
        }
        onClicked: root.close()
    }
}
