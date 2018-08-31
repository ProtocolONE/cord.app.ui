import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

Input {
    id: root

    style {
        normal: Styles.inputNormal
        hover: Styles.inputHover
        active: Styles.inputActive
        disabled: Styles.inputDisabled
        error: Styles.inputError
        placeholder: Styles.inputPlaceholder
        text: Styles.inputText
        background: Styles.inputBackground
    }

    Connections {
        target: SignalBus
        onLeftMousePress: {
            var posInItem = root.mapFromItem(rootItem, x, y);
            if (!root.isMouseInside(posInItem.x, posInItem.y)) {
                root.suggestionsVisible = false;
            }
        }
    }
}
