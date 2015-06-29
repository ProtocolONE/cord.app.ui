import QtQuick 1.1

import "../../Core/Styles.js" as Styles
import "../../Core/moment.js" as Moment

Item {
    id: delegate

    property bool showAvatarAndNickname
    property string avatar
    property string nickname
    property int externalMaximumHeight
    property int maximumHeight
    property variant date
    property string body

    signal linkActivated(string link);

    height: contentColumn.height
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

    Column {
        id: contentColumn

        height: childrenRect.height + 4
        width: parent.width
        spacing: 4

        Row {
            width: parent.width
            height: delegate.showAvatarAndNickname ? 24 : 0
            visible: delegate.showAvatarAndNickname

            Item {
                width: 36
                height: parent.height

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: delegate.avatar
                    width: 24
                    height: 24
                    cache: true
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                }
            }

            Text {
                text: delegate.nickname
                color: Styles.style.trayPopupTextHeader
                width: 182
                elide: Text.ElideRight
                anchors.verticalCenter: parent.verticalCenter
                font { pixelSize: 14; family: "Arial"}
            }
        }

        Row {
            height: mainText.height

            Item {
                width: 36
                height: parent.height

                Text {
                    y: 3
                    text: Moment.moment(date).format("HH:mm")
                    color: Styles.style.trayPopupTextHeader
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font { pixelSize: 10; family: "Arial"}
                }
            }

            Text {
                id: mainText

                width: 182

                function getText() {
                    if (delegate.externalMaximumHeight > 0) {
                        return '<table cellspacing="0" height="' + delegate.externalMaximumHeight + '"><tbody><tr ><td width="' + mainText.width + '" align="left">' + delegate.body + '</td></tr></tbody></table>'
                    }

                    return '<table cellspacing="0"><tbody><tr><td width="' + mainText.width + '" align="left">' + delegate.body + '</td></tr></tbody></table>'
                }

                text: getText()

                color: Styles.style.trayPopupText
                textFormat: Text.RichText
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font { pixelSize: 12; family: "Arial"}
                onLinkActivated: delegate.linkActivated(link)
            }
        }
    }
}
