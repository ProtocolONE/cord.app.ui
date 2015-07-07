import QtQuick 1.1
import GameNet.Controls 1.0
import "../../../../../../Core/Styles.js" as Styles
ImageButton {
    id: root

    width: 16
    height: 16
    style {
        normal: "#00000000"
        hover: "#00000000"
        disabled: "#00000000"
    }

    styleImages {
        normal: installPath + Styles.style.messengerSmileButtonIcon
        hover: installPath + Styles.style.messengerSmileButtonIcon.replace('.png', 'Hover.png')
        disabled: installPath + Styles.style.messengerSmileButtonIcon
    }
}
