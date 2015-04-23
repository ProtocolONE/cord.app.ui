import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0
import "../../../../Core/Styles.js" as Styles

BorderedButtonStyle {
    property bool checked: false

    border: checked
            ? Styles.style.messengerActiveButtonBorder
            : Styles.style.messengerInactiveButtonBorder

    normal: checked
            ? Styles.style.messengerActiveButtonNormal
            : Styles.style.messengerInactiveButtonNormal

    hover: checked
           ? Styles.style.messengerActiveButtonHover
           : Styles.style.messengerInactiveButtonHover

    disabled: checked
              ? Styles.style.messengerActiveButtonDisabled
              : Styles.style.messengerInactiveButtonDisabled
}
