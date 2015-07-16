import QtQuick 2.4
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Button {
    style {
        normal: Styles.minorButtonNormal
        hover: Styles.minorButtonHover
        disabled: Styles.minorButtonDisabled
        active: Styles.minorButtonActive
    }
    textColor: Styles.minorButtonText
}
