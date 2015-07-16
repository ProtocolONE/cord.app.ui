import QtQuick 2.4

import Application.Core 1.0
import Application.Core.Styles 1.0

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
        text: qsTr("PLAYING_GAME_MESSANGE_TEXT").arg(root.playingGameServiceId != '' ?
                                                         App.serviceItemByServiceId(root.playingGameServiceId).name :
                                                         '')
        color: Styles.trayPopupPlayText
        elide: Text.ElideRight
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        maximumLineCount: 3
        font { pixelSize: 12; family: "Arial"}
    }
}
