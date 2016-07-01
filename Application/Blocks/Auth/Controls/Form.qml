import QtQuick 2.4
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

/**
Форма для окон авторизации. Содержит заголовок и подзаголовок (поясняющий текст) и единый футер для всех страниц. При
изменении высоты произвольного контента расширяется снизу вверх.
*/
FocusScope {
    id: root

    default property alias data: container.data

    property string title
    property string subTitle

    property FooterProperties footer: FooterProperties{}

    property alias vkButtonInProgress: footerItem.vkButtonInProgress

    signal footerPrimaryButtonClicked();
    signal footerGuestButtonClicked();
    signal footerVkClicked();

    //Не используйте childRect - он не пересчитывает при изменении visibily элементов в Column/Row
    implicitHeight: contentData.height + (footerItem.visible ? footerItem.height : 0)
    implicitWidth: parent.width

    Column {
        id: contentData

        anchors{
            left: parent.left
            right: parent.right
            bottom: footer.top
        }
        spacing: 15
        z: 1

        Item {
            id: titleItem
            height: 50
            width: parent.width

            Text {
                text: root.title
                font { family: "Open Sans Light"; pixelSize: 36 }
                color: Styles.textAttention
                anchors{
                    baseline: parent.top
                    baselineOffset: 50
                }
                smooth: true
            }
        }

        Item {
            id: subTitleItem

            visible: root.subTitle.length > 0
            height: subTitle.height + 5
            anchors {
               left: parent.left
               right: parent.right
            }

            Text {
                id: subTitle

                width: parent.width
                text: root.subTitle
                color: Styles.infoText

                font { family: "Open Sans Regular"; pixelSize: 15 }
                wrapMode: Text.WordWrap
                anchors{
                    baseline: parent.top
                    baselineOffset: 15
                }
                smooth: true
                textFormat: Text.StyledText
                linkColor: Styles.linkText
                onLinkActivated: App.openExternalUrl(link)

                MouseArea {
                    anchors.fill: parent
                    cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                    acceptedButtons: Qt.NoButton
                }
            }
        }

        Item {
            id: container

            anchors {
               left: parent.left
               right: parent.right
            }
            height: childrenRect.height
        }

        Item {
            width: 1
            height: 5
        }
    }

    Footer {
        id: footerItem

        anchors {
           left: parent.left
           right: parent.right
           bottom: parent.bottom
        }
        visible: footer.visible
        title: footer.title
        text: footer.text
        guestMode: footer.guestMode
        onOpenVkAuth: root.footerVkClicked();
        onClicked: root.footerPrimaryButtonClicked()
        onGuestClicked: root.footerGuestButtonClicked()
    }
}
