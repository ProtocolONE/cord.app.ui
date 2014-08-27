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
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as Messenger

Item {
    id: root

    ListView {
        id: listView

        model: Messenger.getPlayingContactsModel().model

        anchors {
            fill: parent
            rightMargin: 10
        }

        boundsBehavior: Flickable.StopAtBounds
        clip: true

        delegate: ContactItemDelegate {
            width: listView.width
            height: 53
            user: model
            onClicked: select();
        }
    }

    Text {

        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }

        visible: listView.count === 0

        text: qsTr("MESSENGER_PLAYING_CONTACTS_EMPTY_INFO")
        wrapMode: Text.Wrap
        color: Styles.style.messengerPlayingContactEmptyInfo
        font {
            family: "Arial"
            pixelSize: 14
        }
    }

    ListViewScrollBar {
        id: scrollbar

        anchors.left: listView.right
        height: listView.height
        width: 10
        listView: listView
        cursorMaxHeight: listView.height
        cursorMinHeight: 50
        color: Qt.darker(Styles.style.messengerContactsBackground, Styles.style.darkerFactor);
        cursorColor: Qt.darker(Styles.style.messengerContactsBackground, Styles.style.darkerFactor * 1.5);
    }
}