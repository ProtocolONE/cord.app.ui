import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/Styles.js" as Styles

RadioButton {
    style {
        normal: Styles.style.radioButtonNormal
        hover: Styles.style.radioButtonHover
        active: Styles.style.radioButtonActive
        activeHover: Styles.style.radioButtonActiveHover
        disabled: Styles.style.radioButtonDisabled
    }
}
