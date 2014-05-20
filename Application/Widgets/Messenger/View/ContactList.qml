import QtQuick 1.1
import Tulip 1.0

ListView {
    id: root

    clip: true

    implicitWidth: 228
    implicitHeight: 400

    delegate: Group {
        width: root.width

        groupName: model.name
        groupId: model.groupId
        users: model.users
        opened: model.opened
    }
}
