import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/Styles.js" as Styles

Button {
    style {
        normal: Styles.style.primaryButtonNormal
        hover:  Styles.style.primaryButtonHover
        disabled: Styles.style.primaryButtonDisabled
    }
    textColor: Styles.style.lightText
}
