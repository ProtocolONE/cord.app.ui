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

import "../../../../../Core/Styles.js" as Styles

Rectangle {
    property bool showSearchTipOnly: false

    anchors.fill: parent
    color: Styles.style.messengerEmptyContactListInfoBackground

    Image {
        x: 19
        y: 1
        source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/greenArrow.png"

        Text {
            text: qsTr("EMPTY_CONTACT_LIST_FIND_USER")
            width: 100
            color: "#41B700"
            wrapMode: Text.Wrap
            anchors {
                verticalCenter: parent.bottom
                left: parent.right
                leftMargin: 10
            }
        }
    }

    Item {
        visible: !showSearchTipOnly
        anchors.fill: parent

        Image {
            x: 56
            y: 3
            source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/redArrow.png"

            Text {
                text: qsTr("EMPTY_CONTACT_LIST_FIND_CONTACT")
                width: 100
                color: "#E6471F"
                wrapMode: Text.Wrap
                anchors {
                    verticalCenter: parent.bottom
                    left: parent.right
                    leftMargin: 10
                }
            }
        }

        Image {
            x: 16
            y: parent.height - 131
            source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/blueArrow.png"

            Text {
                text: qsTr("EMPTY_CONTACT_LIST_SYSTEM_NOTIFICATION")
                width: 100
                color: "#028ABC"
                wrapMode: Text.Wrap
                anchors {
                    verticalCenter: parent.top
                    left: parent.right
                    leftMargin: 10
                }
            }
        }

        Image {
            x: 90
            y: 312 + 12
            source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/violetArrow.png"
            // INFO когда появятся фильтры обновить текст и показать.
            visible: false

            Text {
                text: qsTr("EMPTY_CONTACT_LIST_CONTACT_FILTER")
                width: 70
                color: "#732EAF"
                wrapMode: Text.Wrap
                anchors {
                    verticalCenter: parent.top
                    left: parent.right
                    leftMargin: 10
                }
            }
        }

        Item {
            height: 63
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 163
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#A4B1BA"
            }

            Image {
                anchors {
                    left: parent.left
                    leftMargin: 10
                    top: parent.top
                }

                source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/lamp.png"
            }

            Text {
                width: 163

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 10
                }

                wrapMode: Text.Wrap
                color: "#EC6C00"
                text: qsTr("EMPTY_CONTACT_LIST_INFO")
            }

            Rectangle {
                width: 163
                height: 1
                anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                color: "#A4B1BA"
            }
        }
    }
}
