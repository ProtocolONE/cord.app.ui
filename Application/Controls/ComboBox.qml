import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

ComboBox {
    id: root

    style {
        background: Styles.comboboxBackground
        normal: Styles.comboboxNormal
        hover: Styles.comboboxHover
        active: Styles.comboboxActive
        disabled: Styles.comboboxDisabled
        selectHover: Styles.comboboxSelectHover
        text: Styles.comboboxText
        scrollBarCursor: Styles.comboboxScrollBarCursor
        scrollBarCursorHover: Styles.comboboxScrollBarCursorHover
    }

    Connections {
        target: SignalBus
        onLeftMousePress: {
            var posInItem = root.mapFromItem(rootItem, x, y);
            if (!root.isMouseInside(posInItem.x, posInItem.y)) {
                root.listContainer.controlVisible = false;
            }
        }
    }
}
