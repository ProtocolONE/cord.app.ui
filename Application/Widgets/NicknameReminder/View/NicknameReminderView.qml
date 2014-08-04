/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0

import Application.Blocks.Popup 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App
import "../../../Core/Popup.js" as Popup

PopupBase {
    id: root

    title: qsTr("USER_LOST_NICK_NAME_TITLE")
    width: 670
    clip: true

    Item {
        id: body

        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }
        width: root.width - 40
        height: childrenRect.height

        Row {
            spacing: 20

            Image {
                source: installPath + "Assets/Images/Application/Widgets/NicknameLost/who.png"
            }

            Text {
                width: 400
                font {
                    family: 'Arial'
                    pixelSize: 14
                }
                color: defaultTextColor
                smooth: true
                wrapMode: Text.WordWrap
                text: qsTr("USER_LOST_NICKNAME_BODY_TEXT")
            }

        }
    }

    PopupHorizontalSplit {
        width: root.width
    }

    Button {
        id: activateButton

        width: 200
        height: 48
        anchors {
            left: parent.left
            leftMargin: 20
        }
        text: qsTr("USER_LOST_NICKNAME_ENTER_BUTTON_TEXT")
        onClicked: {
            Popup.show('NicknameEdit', '');
            root.close();
        }
    }
}
