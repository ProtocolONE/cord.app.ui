import QtQuick 2.4
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

RadioButton {
    style {
        normal: Styles.radioButtonNormal
        hover: Styles.radioButtonHover
        active: Styles.radioButtonActive
        activeHover: Styles.radioButtonActiveHover
        disabled: Styles.radioButtonDisabled
    }
}
