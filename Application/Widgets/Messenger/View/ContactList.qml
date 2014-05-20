/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
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
