import QtQuick 1.1

import GameNet.Components.Widgets 1.0

import Application.Controls 1.0

import "../../Core/Styles.js" as Styles

Item {
    width: container.width + 2
    height: container.height + 1
    anchors { left: parent.left; bottom: parent.top }

    ContentBackground {
        anchors.fill: parent
        opacity: 0.95

        ContentStroke {
            height: parent.height
            anchors.left: parent.left
            opacity: 0.15
        }

        ContentStroke {
            height: parent.height
            anchors.right: parent.right
            opacity: 0.15
        }

        ContentStroke {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                leftMargin: 1
                rightMargin: 1
            }
            opacity: 0.15
        }
    }

    WidgetContainer {
        id: container

        x: 1
        y: 1
        widget: "SecondAccountAuth"
        view: "SecondAccountView"
    }
}
