import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0
import "../../../../Core/Styles.js" as Styles

BorderedButtonStyle {
    border: Styles.style.messengerInactiveButtonBorder
    normal: Styles.style.messengerInactiveButtonNormal
    hover: Styles.style.messengerInactiveButtonHover
    disabled: Styles.style.messengerInactiveButtonDisabled
}
