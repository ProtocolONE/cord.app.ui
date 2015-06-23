import QtQuick 1.1

import GameNet.Controls 1.0
import "../Core/Styles.js" as Styles

CheckBox {
    style {
        normal: Styles.style.checkboxNormal
        hover: Styles.style.checkboxHover
        disabled: Styles.style.checkboxNormal
        active: Styles.style.checkboxActive
        activeHover: Styles.style.checkboxActiveHover
    }
}
