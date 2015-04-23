import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0
import "../../../../Core/Styles.js" as Styles

BorderedButtonStyle {
    border: Styles.style.messengerActiveButtonBorder
    normal: Styles.style.messengerActiveButtonNormal
    hover: Styles.style.messengerActiveButtonHover
    disabled: Styles.style.messengerActiveButtonDisabled
}
