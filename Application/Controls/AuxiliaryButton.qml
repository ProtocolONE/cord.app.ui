import QtQuick 2.4
import GameNet.Controls 1.0

import Application.Core.Styles 1.0

Button {
    style {
        normal: Styles.auxiliaryButtonNormal
        hover: Styles.auxiliaryButtonHover
        disabled: Styles.auxiliaryButtonDisabled    
    }
    textColor: Styles.auxiliaryButtonText
}
