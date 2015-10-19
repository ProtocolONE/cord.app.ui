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

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Core.Styles 1.0

WidgetView {
    id: root
    implicitWidth: 630
    implicitHeight: allContent.height + 30
    clip: true

    default property alias data: container.data
    property alias title: titleText.text

    property int defaultMargins: 50
    property color defaultBorderColor: Styles.popupBorder
    property color defaultBackgroundColor: Styles.popupBackground
    property color defaultTitleColor: Styles.popupTitleText
    property color defaultTextColor: Styles.popupText

    // Блокируем клики сквозь виджеты. надеюсь ничего не сломается
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        hoverEnabled: true
    }

    Rectangle {
        anchors.fill: parent
        color: defaultBackgroundColor
        border {
            color: defaultBorderColor
            width: 1
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
                font { family: 'Open Sans Light'; pixelSize: 30 }
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
            normal: installPath + Styles.popupCloseIcon
            hover: installPath + Styles.popupCloseIcon.replace('.png', '_hover.png')
        }
        onClicked: root.close()
    }
}
