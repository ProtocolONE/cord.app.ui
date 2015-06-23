import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/Styles.js" as Styles

Button {
    style {
        normal: Styles.style.minorButtonNormal
        hover: Styles.style.minorButtonHover
        disabled: Styles.style.minorButtonDisabled
        active: Styles.style.minorButtonActive
    }
    textColor: Styles.style.infoText
}
