import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/Styles.js" as Styles

Button {
    style {
        normal: Styles.style.minorBottonNormal
        hover: Styles.style.minorBottonHover
        disabled: Styles.style.minorBottonDisabled
        active: Styles.style.minorBottonActive
    }
    textColor: Styles.style.infoText
}
