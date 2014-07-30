import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

TextButton {
    checkable: true
    width: 160
    height: 20
    style {
        normal: Styles.style.settingsCategoryButtonNormal
        hover: Styles.style.settingsCategoryButtonHover
        active: Styles.style.settingsCategoryButtonActive
    }
}
