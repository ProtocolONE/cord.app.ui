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
    property string login;

    signal cancel();
    signal unblocked();
    signal showProgress(bool show);

    function clear() {
        errorText.text = '';
        codeInput.clear();
    }

    function getCode(method) {
        showProgress(true);
        Authorization.sendUnblockCode(login, method, function(result, response) {
            showProgress(false);
            if (Authorization.isSuccess(result)) {
                errorText.text = qsTr("MESSAGE_CODE_SENDED");
            } else {
                errorText.text = response.message;
            }
        });
    }

    function unblock() {
        showProgress(true);
        Authorization.unblock(login, codeInput.text, function(result, response) {
            showProgress(false);
            if (Authorization.isSuccess(result)) {
                unblocked();
            } else {
                errorText.text = response.message;
            }
        });
    }

    onUnblocked: clear();
    onCancel: clear();

    spacing: 11

    Text {
        width: 350
        text: qsTr("TITLE_TEXT_ABOUT_ENTER_CODE")
        wrapMode: Text.WordWrap
        color: "#FFFFFF"
        font { family: 'Arial'; pixelSize: 14;  }
    }

    Text {
        id: errorText

        visible: errorText.text !== ''
        width: 350
        wrapMode: Text.WordWrap
        color: "#ffff66"
        font { family: 'Arial'; pixelSize: 14; }
    }

    Row {
        height: 28
        spacing: 5

        Elements.Button {
            text: qsTr("BUTTON_SEND_BY_MAIL")
            analitics: ['/AuthCode', 'GetCode', 'Email']
            onClicked: getCode('email');
        }

        Elements.Button {
            text: qsTr("BUTTON_SEND_BY_SMS")
            analitics: ['/AuthCode', 'GetCode', 'SMS']
            onClicked: getCode('sms');
        }
    }

    Elements.Input {
        id: codeInput

        width: 238
        height: 28
        editDefaultText: qsTr("PLACEHOLDER_ENTER_CODE")
        focus: true
        onEnterPressed: unblock();
    }

    Row {
        height: 28
        spacing: 5

        Elements.Button {
            text: qsTr("BUTTON_SEND")
            analitics: ['/AuthCode', 'SendCode', 'Send']
            enabled: codeInput.text !== ''
            onClicked: unblock();
        }

        Elements.Button {
            text: qsTr("AUTH_CANCEL_BUTTON")
            analitics: ['/AuthCode', 'SendCode', 'Cancel']
            onClicked: cancel();
        }
    }
}

