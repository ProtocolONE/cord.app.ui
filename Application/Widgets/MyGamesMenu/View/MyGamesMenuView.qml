import QtQuick 2.4

import Application.Blocks 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0

WidgetView {
    id: root

    implicitWidth: 180
    implicitHeight: 600

    clip: true

    MouseArea {
        anchors.fill: parent
    }

    ListView {
        id: listView

        anchors.fill: parent
        interactive: true
        boundsBehavior: Flickable.StopAtBounds
        model: root.model.listModelAlias

        delegate: GameInstallBlock {
            gameItem: item

            Rectangle {
                width: parent.width
                height: 1
                color: '#182d40'
            }
        }
    }
}
