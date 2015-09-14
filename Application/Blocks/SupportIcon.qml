import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../Core/App.js" as App
import "../Core/Styles.js" as Styles
import "../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

/*
More info in https://jira.gamenet.ru:8443/browse/QGNA-1348
*/
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

        source: installPath + Styles.style.supportIcon
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
