import QtQuick 1.1

import "../../Core/Styles.js" as Styles
import "../../Core/moment.js" as Moment

Item {
    id: delegate

    property int externalMaximumHeight
    property int maximumHeight
    property variant date
    property string body

    height: mainText.height
    clip: true

    onExternalMaximumHeightChanged: {
        if (externalMaximumHeight < 0) {
            return;
        }

        if (externalMaximumHeight < 16) {
            delegate.visible = false;
            delegate.height = 0;
            return;
        }
    }

    Text {
        text: Moment.moment(date).format("HH:mm")
        color: Styles.style.trayPopupTextHeader
        elide: Text.ElideRight
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font { pixelSize: 10; family: "Arial"}
    }

    Text {
        id: mainText

        x: 42
        y: -2
        width: parent.width - 10 - 42

        function getText() {
            if (delegate.externalMaximumHeight > 0) {
                return '<table height="' + delegate.externalMaximumHeight + '"><tbody><tr><td width="' + mainText.width + '" align="left">' + delegate.body + '</td></tr></tbody></table>'
            }

            return '<table><tbody><tr><td width="' + mainText.width + '" align="left">' + delegate.body + '</td></tr></tbody></table>'
        }

        text: getText()

        color: Styles.style.trayPopupText
        textFormat: Text.RichText
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font { pixelSize: 12; family: "Arial"}
    }
}
