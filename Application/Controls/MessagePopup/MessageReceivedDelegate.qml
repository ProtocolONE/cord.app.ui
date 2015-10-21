import QtQuick 2.4

import GameNet.Core 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: delegate

    property bool showAvatarAndNickname
    property string avatar
    property string nickname
    property int externalMaximumHeight
    property int maximumHeight
    property variant date
    property string bodyText

    signal linkActivated(string link);

    height: contentColumn.height
    clip: true

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
                color: Styles.trayPopupTextHeader
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
                    color: Styles.trayPopupTextHeader
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font { pixelSize: 10; family: "Arial"}
                }
            }

            Text {
                id: mainText

                width: 182

                text: delegate.bodyText

                color: Styles.trayPopupText
                textFormat: Text.RichText
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font { pixelSize: 12; family: "Arial"}
                onLinkActivated: delegate.linkActivated(link)
            }
        }
    }
}
