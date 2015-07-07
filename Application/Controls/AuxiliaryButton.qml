import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/Styles.js" as Styles

Button {
    style {
        normal: Styles.style.auxiliaryButtonNormal
        hover: Styles.style.auxiliaryButtonHover
        disabled: Styles.style.auxiliaryButtonDisabled    
    }
    textColor: Styles.style.auxiliaryButtonText
}
