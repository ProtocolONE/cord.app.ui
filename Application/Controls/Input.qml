import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/App.js" as App
import "../Core/Styles.js" as Styles

Input {
    id: root

    style {
        normal: Styles.style.inputNormal
        hover: Styles.style.inputHover
        active: Styles.style.inputActive
        disabled: Styles.style.inputDisabled
        error: Styles.style.inputError
        placeholder: Styles.style.inputPlaceholder
        text: Styles.style.inputText
        background: Styles.style.inputBackground
    }

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
