import QtQuick 2.4

import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Core.Styles 1.0

WidgetView {
    id: root
    implicitWidth: 630
    implicitHeight: allContent.height + defaultImplicitHeightAddition
    clip: true

    default property alias data: container.data
    property alias title: titleText.text

    property int defaultSpacing: 30
    property int defaultMargins: 50
    property int defaultImplicitHeightAddition: 30

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

        spacing: defaultSpacing

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
