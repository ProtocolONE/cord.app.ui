/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import Application.Blocks 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

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
