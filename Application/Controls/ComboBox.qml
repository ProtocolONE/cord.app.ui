import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import "../Core/App.js" as App
import "../Core/Styles.js" as Styles

ComboBox {
    id: root

    style {
        background: Styles.style.comboboxBackground
        normal: Styles.style.comboboxNormal
        hover: Styles.style.comboboxHover
        active: Styles.style.comboboxActive
        disabled: Styles.style.comboboxDisabled
        selectHover: Styles.style.comboboxSelectHover
        text: Styles.style.comboboxText
        scrollBarCursor: Styles.style.comboboxScrollBarCursor
        scrollBarCursorHover: Styles.style.comboboxScrollBarCursorHover
    }

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
