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
import GameNet.Components.Widgets 1.0

Item {
    id: root

    property alias listView: listView
    property bool isSingleMode: false

    width: 590
    height: listView.count * 148

    Rectangle {
        anchors.fill: parent
        color: '#f0f5f8'
    }

    ListView {
        id: listView

        anchors.fill: parent
        model: ListModel {}
        interactive: false
        spacing: 10

        delegate: NewsDelegate {
            height: index != 0 ? 138 : 128
            width: root.width - 20
        }
    }
}
