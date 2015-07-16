import QtQuick 2.4
import Tulip 1.0
import GameNet.Controls 1.0
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
