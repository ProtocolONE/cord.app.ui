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
import Application.Controls 1.0

import "../../../Core/App.js" as App
import "../../../Core/Popup.js" as Popup

PopupBase {
    id: root

    title: qsTr("USER_LOST_NICK_NAME_TITLE")
    width: 730
    clip: true

    Row {
        spacing: 20
        width: parent.width

        Image {
            id: nickNameLostImage
            source: installPath + "Assets/Images/Application/Widgets/NicknameLost/who.png"
        }

        Text {
            font {
                family: 'Arial'
                pixelSize: 14
            }
            width: parent.width - nickNameLostImage.width + parent.spacing
            color: defaultTextColor
            smooth: true
            wrapMode: Text.WordWrap
            text: qsTr("USER_LOST_NICKNAME_BODY_TEXT")
        }
    }

    PopupHorizontalSplit{}

    PrimaryButton {
        id: activateButton

        width: 200
        text: qsTr("USER_LOST_NICKNAME_ENTER_BUTTON_TEXT")
        onClicked: {
            Popup.show('NicknameEdit', '');
            root.close();
        }
    }
}
