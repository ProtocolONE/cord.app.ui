import QtQuick 1.1
import GameNet.Controls 1.0

import "../../../Core/Styles.js" as Styles

Button {
    id: button

    signal buttonClick(int button)

    property int buttonId

    width: 200
    height: 46

    onClicked: buttonClick(buttonId);

    style {
        normal: Styles.style.messageBoxPositiveButtonNormal
        hover: Styles.style.messageBoxPositiveButtonHover
    }
}

