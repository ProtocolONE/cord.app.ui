import QtQuick 2.4

import ProtocolOne.Controls 1.0

import Application.Controls 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    signal clicked();
    width: 50
    height: 50

    ContentBackground {
        ContentThinBorder{
        }
    }

    Image {
        id: icon

        source: installPath + Styles.supportIcon
        anchors.centerIn: parent
        smooth: true
    }

    ShakeAnimation {
        id: shakeAnimation

        target: icon
        property: "rotation"
        from: 0
        shakeValue: 4
        shakeTime: 200
    }

    CursorMouseArea {
        id: mouser

        anchors.fill: parent
        toolTip: qsTr("Нажмите, чтобы перейти на сайт службы поддержки и сообщить об ошибке.")
        onClicked: root.clicked()
        onExited: shakeAnimation.start()
    }
}
