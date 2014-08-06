import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

RadioButton {
    width: parent.width
    height: 20
    fontSize: 15
    style {
        normal: Styles.style.settingsControlNormal
        hover: Styles.style.settingsControlHover
    }
}
