import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import "../Core/App.js" as App

ComboBox {
    id: root

    Connections {
        target: App.signalBus()
        onLeftMouseClick: {
            var posInItem;

            posInItem = root.listBlock.mapFromItem(rootItem, x, y);

            if (posInItem.x < 0 || posInItem.x > listBlock.width ||
                posInItem.y < 0 || posInItem.y > listBlock.height) {
                listContainer.controlVisible = false;
            }
        }
    }
}
