import QtQuick 1.1

import "../../Core/Styles.js" as Styles
import "../../Core/App.js" as App

Row {
    id: root

    property string playingGameServiceId: ''

    spacing: 5
    visible: root.playingGameServiceId.length > 0

    Image {
        source: installPath + '/Assets/Images/Application/Controls/MessagePopup/popupPlayingGame.png'
    }

    Text {
        y: 2
        text: qsTr("PLAYING_GAME_MESSANGE_TEXT").arg(App.serviceItemByServiceId(root.playingGameServiceId).name)
        color: Styles.style.trayPopupPlayText
        elide: Text.ElideRight
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        maximumLineCount: 3
        font { pixelSize: 12; family: "Arial"}
    }
}
