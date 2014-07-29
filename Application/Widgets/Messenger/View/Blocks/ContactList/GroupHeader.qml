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
import GameNet.Controls 1.0
import "../../../../../Core/Styles.js" as Styles

Item {
    id: root

    property string groupName: ""
    property int usersCount: 0
    property bool opened: false
    property int unreadUsersCount: 0

    signal clicked();

    implicitWidth: 180
    implicitHeight: 33

    Column {
        anchors.fill: parent

        Rectangle {
            height: 1
            width: parent.width
            color: Qt.lighter(groupTitle.color, Styles.style.lighterFactor)
        }

        Rectangle {
            id: groupTitle

            width: parent.width
            height: 31
            color: Styles.style.messengerContactGroupBackground

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }

                text: root.groupName + " ( " + root.usersCount + " ) "
                font {
                    family: "Arial"
                    pixelSize: 12
                    capitalization: Font.AllUppercase
                }

                color: Styles.style.messengerContactGroupName
            }

            Row {
                height: parent.height
                anchors {
                    right: parent.right
                    rightMargin: 10
                }

                spacing: 10
                layoutDirection: Qt.RightToLeft

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: installPath +
                            (root.opened
                             ? "/Assets/Images/Application/Widgets/Messenger/chat_arrow_up.png"
                             : "/Assets/Images/Application/Widgets/Messenger/chat_arrow_down.png")
                }

                Rectangle {
                    visible: root.unreadUsersCount > 0
                    width: 21
                    height: 16
                    radius: 7
                    color: Styles.style.messengerContactGroupUnreadBackground
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: root.unreadUsersCount
                        color: Styles.style.messengerContactGroupUnread
                        font {
                            family: "Arial"
                            pixelSize: 12
                        }
                    }
                }
            }

            CursorMouseArea {
                anchors.fill: parent
                onClicked: root.clicked();
            }
        }

        Rectangle {
            height: 1
            width: parent.width
            color: Qt.darker(groupTitle.color, Styles.style.darkerFactor)
        }
    }
}
