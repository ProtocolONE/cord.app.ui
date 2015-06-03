import QtQuick 1.1
import GameNet.Controls 1.0

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
        normal: installPath + 'Assets/Images/Application/Widgets/Messenger/smileButton.png'
        hover: installPath + 'Assets/Images/Application/Widgets/Messenger/smileButtonHover.png'
        disabled: installPath + 'Assets/Images/Application/Widgets/Messenger/smileButton.png'
    }
}
