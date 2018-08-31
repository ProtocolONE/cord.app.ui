import QtQuick 2.4

import ProtocolOne.Controls 1.0
import Application.Core.Styles 1.0

CheckBox {
    style {
        normal: Styles.checkboxNormal
        hover: Styles.checkboxHover
        disabled: Styles.checkboxNormal
        active: Styles.checkboxActive
        activeHover: Styles.checkboxActiveHover
    }
}
