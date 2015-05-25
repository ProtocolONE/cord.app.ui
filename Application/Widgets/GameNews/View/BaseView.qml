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

import "../../../Core/Styles.js" as Styles

Item {
    id: root

    signal finished();

    property alias listView: listView
    property bool isSingleMode: false

    property int createdItemCount: 0

    onCreatedItemCountChanged: {
        if (root.createdItemCount == listView.count)  {
            root.createdItemCount = 0;
            root.finished();
        }
    }

    width: 590
    height: listView.count * 149

    Rectangle {
        anchors.fill: parent
        color: Styles.style.contentBackgroundLight
        opacity: Styles.style.baseBackgroundOpacity
    }

    ListView {
        id: listView

        anchors.fill: parent
        anchors.topMargin: 10
        model: ListModel {}
        interactive: false
        spacing: 10
        cacheBuffer: 0

        delegate: NewsDelegate {
            Component.onCompleted: root.createdItemCount++;
        }
    }
}
