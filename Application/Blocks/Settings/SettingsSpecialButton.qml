import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

TextButton {
    checkable: true
    width: 160
    height: 20
    wrapMode: Text.WordWrap
    style {
        normal: Styles.style.settingsSpecialButtonNormal
        hover: Styles.style.settingsSpecialButtonHover
        disabled: Styles.style.settingsSpecialButtonDisabled
    }
    analytics.category: 'Navigation'
}
