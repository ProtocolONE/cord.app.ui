import QtQuick 2.4
import Application.Core.Styles 1.0

Item {
    id: root

    property bool showSearchTipOnly: false

    anchors.fill: parent

    Image {
        width: parent.width
        opacity: Styles.baseBackgroundOpacity
        source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/background.png"
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.65
        color: Styles.contentBackgroundDark
    }

    Image {
        x: 21
        y: 10
        source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/greenArrow.png"

        Text {
            text: qsTr("EMPTY_CONTACT_LIST_FIND_USER")
            width: 100
            color: "#1abc9c"
            wrapMode: Text.WordWrap
            font.pixelSize: 14
            anchors {
                verticalCenter: parent.bottom
                left: parent.right
                leftMargin: 10
                verticalCenterOffset: 6
            }
        }
    }

    Image {
        x: 62
        y: 10
        source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/blueArrow.png"
        visible: !root.showSearchTipOnly

        Text {
            text: qsTr("EMPTY_CONTACT_LIST_FIND_USER_WEB_SEARCH")
            width: 100
            color: "#3498db"
            wrapMode: Text.WordWrap
            font.pixelSize: 14
            anchors {
                verticalCenter: parent.bottom
                left: parent.right
                leftMargin: 10
                verticalCenterOffset: 6
            }
        }
    }

    Image {
        x: 10
        y: 150
        source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/yellowArrow.png"
        visible: !root.showSearchTipOnly

        Text {
            text: qsTr("EMPTY_CONTACT_LIST_CONTACT_FILTER")
            width: 100
            color: "#e9cb78"
            wrapMode: Text.WordWrap
            font.pixelSize: 14
            anchors {
                top: parent.top
                topMargin: 22
                left: parent.right
                leftMargin: 10
            }
        }
    }
}
