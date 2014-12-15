import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import "../Core/App.js" as App

ComboBox {
    id: root

    Connections {
        target: App.signalBus()
        onLeftMouseRelease: {
            if (root.listContainer.controlVisible) {
                root.preventDefault = true;
                root.listContainer.controlVisible = false;
                restoreDefaultTimer.restart();
            }
        }
    }

    //  HACK: таймер нужен для предотвращения срабатывания обработчика
    //  внутри ComboBox
    Timer {
        id: restoreDefaultTimer

        interval: 1
        repeat: false
        onTriggered: {
            root.preventDefault = false;
        }
    }
}
