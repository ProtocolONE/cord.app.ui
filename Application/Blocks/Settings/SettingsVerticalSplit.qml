import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

VerticalSplit {
    height: 422
    style {
        main: Qt.lighter(Styles.style.settingsBackground, Styles.style.lighterFactor)
        shadow: Qt.darker(Styles.style.settingsBackground, Styles.style.darkerFactor)
    }
}
