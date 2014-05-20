import QtQuick 1.1
import Tulip 1.0

import Gamenet.Controls 1.0

Rectangle {
    id: root

    property alias nickname : nicknameText.text
    property alias avatar: avatarImage.source
    property alias status: statusText.text

    property bool isCurrent: false
    property bool isUnreadMessages: false
    property string presenceStatus: ""

    signal clicked()

    implicitWidth: 78
    implicitHeight: 53

    color: root.isUnreadMessages ? "#189A19" : (root.isCurrent ? "#253149" :"#FAFAFA")

    QtObject {
        id: d

        function presenceStatusToColor(status) {
            if (status === "online") {
                return "#1ABC9C";
            }

            if (status === "dnd") {
                return "#FFCC00";
            }

            return "#CCCCCC";
        }
    }

    Item {
        width: parent.width
        height: 51

        Row {
            anchors.fill: parent

            Item {
                height: parent.height
                width: parent.height

                Image {
                    id: avatarImage

                    anchors.centerIn: parent
                }
            }

            Item {
                height: parent.height
                width: parent.width - parent.height

                Item {
                    anchors.fill: parent
                    anchors.rightMargin: 33

                    Text {
                        id: nicknameText

                        anchors {
                            baseline: parent.top
                            baselineOffset: 22
                        }

                        color: (root.isUnreadMessages || root.isCurrent)
                               ? "#FAFAFA"
                               : "#243148"

                        font.pixelSize: 12
                        width: parent.width
                        elide: Text.ElideRight
                    }

                    Text {
                        id: newMessageStatus

                        anchors {
                            baseline: parent.bottom
                            baselineOffset: -10
                        }

                        visible: root.isUnreadMessages && !root.isCurrent
                        text: qsTr("CONTACT_NEW_MESSAGE")
                        color: "#FFCC00"
                        font.pixelSize: 10
                    }

                    Text {
                        id: statusText

                        anchors {
                            baseline: parent.bottom
                            baselineOffset: -10
                        }

                        visible: !newMessageStatus.visible
                        color: "#5B6F81"
                        font.pixelSize: 10
                    }
                }

                Rectangle {
                    width: 7
                    height: 7
                    radius: 7
                    color: d.presenceStatusToColor(root.presenceStatus)

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 16
                    }
                }
            }
        }
    }

    HorizontalSplit {
        width: parent.width
        anchors.bottom: parent.bottom
    }

    CursorMouseArea {
        anchors.fill: parent
        onClicked: root.clicked();
    }
}
