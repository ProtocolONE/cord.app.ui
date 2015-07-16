import QtQuick 2.4
import GameNet.Controls 1.0

import Application.Core.Styles 1.0

Button {
    style {
        normal: Styles.primaryButtonNormal
        hover:  Styles.primaryButtonHover
        disabled: Styles.primaryButtonDisabled
    }
    textColor: Styles.primaryButtonText
}
