import QtQuick 1.1

Item {
    property alias model: listView.model

    height: 87

    ListView {
        id: listView

        anchors {
            left: parent.left
            right: parent.right
            margins: 18
        }

        height: parent.height
        interactive: false

        spacing: 20

        orientation: ListView.Horizontal

        delegate: GameItemSmall {
            serviceId: listView.model[index].serviceId
        }

    }

}
