/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import "../../../Elements" as Elements
import "../../../js/Authorization.js" as Authorization

Column {
    property alias text: captchaText.text
    property string login;

    function clear() {
        captchaText.clear();
    }

    width: 238
    spacing: 11

    onVisibleChanged: {
        if (true === visible) {
            captchaImage.refreshCaptcha();
        }
    }

    Elements.Input {
        id: captchaText

        width: parent.width
        height: 28

        showKeyboardLayout: false
        editDefaultText: qsTr("PLACEHOLDER_CAPTCHA")
    }

    Rectangle {
        width: parent.width
        height: 50
        color: "#eaf5e5"

        Image {
           id: captchaImage

           function refreshCaptcha() {
               captchaImage.source = Authorization.getCaptchaImageSource(login);
           }

           anchors.fill: parent
        }
    }

    Text {
        text: qsTr("BUTTON_SHOW_ANOTHER_CAPTCHA")
        color: "#FFFFFF"
        font { family: 'Arial'; pixelSize: 14; underline: true }

        Elements.CursorMouseArea {
            anchors.fill: parent
            onClicked: captchaImage.refreshCaptcha();
        }
    }
}
