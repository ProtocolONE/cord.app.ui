import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0


import "../../../Styles"

import "../../../../../../Core/Styles.js" as Style

BorderedButton {
    id: root

    property alias checked: checkStyle.checked

    signal clicked();

    style: CheckButtonStyle {
        id: checkStyle
    }

    implicitWidth: 44
    implicitHeight: 44

    Image {
        anchors.centerIn: parent
        source: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/editGroupChatIcon.png"
        opacity: root.containsMouse ? 1.0 : 0.5

        Behavior on opacity {
            PropertyAnimation { duration: 250 }
        }
    }
}
