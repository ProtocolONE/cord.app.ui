import QtQuick 2.4
import Application.Controls 1.0

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

    ContentBackground {}

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
