import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/App.js" as App

Input {
    id: root

    Connections {
        target: App.signalBus()
        onLeftMousePress: {
            var posInItem = root.mapFromItem(rootItem, x, y);
            if (!root.isMouseInside(posInItem.x, posInItem.y)) {
                root.suggestionsVisible = false;
            }
        }
    }
}
