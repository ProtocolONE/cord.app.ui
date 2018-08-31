import QtQuick 2.4
import Dev 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0

Rectangle {
    width: 1000
    height: 599
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.AlertAdapter');
            manager.registerWidget('Application.Widgets.PublicTest');
            manager.init();

            Popup.init(popupLayer);
            MessageBox.init(messageboxLayer);
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Tests/Assets/main_07.png'
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }

    Item {
        id: messageboxLayer

        anchors.fill: parent
        z: 3
    }

    //  Пример иконки PTS - поэтому открываем попуп не напрямую, а через сигнал
    Button {
        x: 450
        y: 450
        width: 300
        height: 30

        text: "Не хочу тестировать!"
        onClicked: Popup.show("PublicTest");
    }
}
