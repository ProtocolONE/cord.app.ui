import QtQuick 2.4
import GameNet.Controls 1.0
import Application.Core.Styles 1.0

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
        normal: installPath + Styles.messengerSmileButtonIcon
        hover: installPath + Styles.messengerSmileButtonIcon.replace('.png', 'Hover.png')
        disabled: installPath + Styles.messengerSmileButtonIcon
    }
}
