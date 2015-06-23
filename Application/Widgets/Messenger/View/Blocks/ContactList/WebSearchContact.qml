import QtQuick 1.1
import GameNet.Controls 1.0
import "../../../../../Core/Styles.js" as Styles

Item {
    id: root

    signal clicked();
    signal requestAddToContact();

    property string searchText
    property bool isActive
    property variant charsList
    property bool isHighlighted: false
    property bool isInContacts: false

    property string nickname
    property string avatar
    property string charsText

    property bool inviteMaximumLimitSended: false

    implicitWidth: 78
    height: 57 + textInfoColumn.height

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
        color: Styles.style.light
        opacity: 0.1
        visible: root.isActive
    }

    Rectangle {
        anchors {
            fill: parent
            topMargin: 1
            leftMargin: 3
            rightMargin: 9
            bottomMargin: 2
        }

        color: "#00000000"

        opacity: 0.25
        border {
            width: 1
            color: Styles.style.light
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
                    color: Styles.style.menuText
                }

                TextButton {
                    width: parent.width - 40

                    text: qsTr("WEB_SEARCH_ADD_CONTACT") // "Добавить в контакты"
                    fontSize: 11

                    visible: !root.isInContacts
                    style {
                        normal: Styles.style.linkText
                        hover: Styles.style.linkText
                        disabled: Styles.style.linkText
                    }

                    font.family: 'Tahoma'
                    onClicked: root.requestAddToContact();
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
            color: Styles.style.textBase
        }
    }

}
