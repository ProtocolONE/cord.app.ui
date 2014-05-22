/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0

import Gamenet.Controls 1.0

Rectangle {
    id: root

    property alias nickname : nicknameText.text
    property alias avatar: avatarImage.source
    property alias status: statusText.text
    property alias isPresenceVisile: presenceIcon.visible

    property bool isCurrent: false
    property bool isUnreadMessages: false

    property string presenceStatus: ""

    signal clicked()

    implicitWidth: 78
    implicitHeight: 53

    color: root.isUnreadMessages
           ? "#189A19"
           : (root.isCurrent ? "#243148" :"#FAFAFA")

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

    Rectangle {
        height: 1
        width: parent.width
        color: root.isUnreadMessages
               ? "#30DE79"
               : (isCurrent ? "#243148" : "#FFFFFF")
        anchors.top: parent.top
    }

    Item {
        anchors {
            fill: parent
            topMargin: 1
            bottomMargin: 1
        }

        Row {
            anchors.fill: parent

            Item {
                height: parent.height
                width: parent.height

                Image {
                    id: avatarImage

                    width: 32
                    height: 32
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

                        font {
                            family: "Arial"
                            pixelSize: 14
                            bold: root.isUnreadMessages
                        }

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
                        font {
                            family: "Arial"
                            pixelSize: 12
                        }
                    }

                    Text {
                        id: statusText

                        anchors {
                            baseline: parent.bottom
                            baselineOffset: -10
                        }

                        visible: !newMessageStatus.visible
                        color: "#5B6F81"
                        font {
                            family: "Arial"
                            pixelSize: 12
                        }
                    }
                }

                Rectangle {
                    id: presenceIcon

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

    Rectangle {
        height: 1
        width: parent.width
        color: root.isUnreadMessages
               ? "#108211"
               : (isCurrent ? "#243148" : "#E5E5E5")
        anchors.bottom: parent.bottom
    }

    CursorMouseArea {
        anchors.fill: parent
        onClicked: root.clicked();
    }
}
