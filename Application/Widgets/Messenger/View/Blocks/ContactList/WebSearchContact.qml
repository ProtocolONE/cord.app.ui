import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    signal clicked();
    signal requestAddToContact();

    property string searchText
    property bool isActive
    property variant charsList
    property bool isHighlighted: false
    property int subscrition: 0
    property bool contactSent: false

    property string nickname
    property string avatar
    property string charsText

    property bool inviteMaximumLimitSended: false

    implicitWidth: 78
    height: 57 + textInfoColumn.height

    function isContactSent() {
        return (root.subscrition == 2 || root.subscrition == 3) || contactSent;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Rectangle {
        anchors {
            fill: parent
            leftMargin: 2
            rightMargin: 7
        }
        color: Styles.light
        opacity: 0.1
        visible: root.isActive
    }

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 6
        }

        color: "#00000000"

        opacity: 0.25
        border {
            width: 1
            color: Styles.light
        }
        visible: root.isHighlighted
    }

    Item {
        height: 42
        width: parent.width

        Row {
            anchors {
                fill: parent
                margins: 10
            }
            spacing: 8

            Image {
                id: avatarImage

                width: 32
                height: 32

                cache: false
                asynchronous: true
                source: root.avatar
            }

            Column {
                width: parent.width
                height: parent.height

                Text {
                    id: nicknameText

                    font {
                        family: "Arial"
                        pixelSize: 14
                    }

                    height: 18
                    width: parent.width - 40
                    elide: Text.ElideRight
                    text: root.nickname
                    color: Styles.menuText
                }

                TextButton {
                    width: parent.width - 40

                    text: qsTr("WEB_SEARCH_ADD_CONTACT") // "Добавить в контакты"
                    fontSize: 11

                    visible: !root.isContactSent()
                    font.family: 'Tahoma'
                    onClicked: root.requestAddToContact()
                }

                Text {
                    width: parent.width - 40

                    text: qsTr("WEB_SEARCH_ADD_CONTACT_SENT") // "Запрос отправлен"
                    color: Styles.menuText
                    font {
                        family: "Tahoma"
                        pixelSize: 11
                    }

                    visible: root.isContactSent()
                }
            }
        }
    }

    Column {
        id: textInfoColumn

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            rightMargin: 10
            leftMargin: 10
            topMargin: 49
        }
        spacing: 3
        clip: true

        Text {
            font {
                family: 'Tahoma'
                pixelSize: 11
            }
            text: root.charsText
            wrapMode: Text.WordWrap
            width: parent.width
            color: Styles.textBase
        }
    }
}
