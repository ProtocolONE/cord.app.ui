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
import Tulip 1.0
import "../../../Elements" as Elements

Column {
    spacing: 11

    property alias login: loginTextInput.text
    property alias password: passwordTextInput.text
    property alias rememberChecked: rememberCheckBox.isChecked
    property alias captcha: captchaObj.text
    property bool captchaRequired: false

    signal loginMe(string login, string password, string captcha);
    signal cancel();

    function internalLogin() {
        loginMe(login, password, captcha);
        clear();
    }

    function clear() {
        passwordTextInput.clear();
        captchaObj.clear();
    }

    onCancel: clear();
    onLoginChanged: {
        if (login === '') {
            loginTextInput.clear();
        }
        captchaRequired = false;
    }

    Elements.Input {
        id: loginTextInput

        z: 1
        width: 238
        height: 28
        textEchoMode: TextInput.Normal
        editDefaultText: qsTr("PLACEHOLDER_LOGIN_INPUT")
        focus: true
        onEnterPressed: {
            if (!password) {
                passwordTextInput.textEditComponent.focus = true;
                return;
            }

            internalLogin();
        }
        onTabPressed: passwordTextInput.textEditComponent.focus = true;
        onVisibleChanged: {
            if (!visible) {
                return;
            }

            var currentValue = Settings.value("qml/auth/", "authedLogins", "{}");
            setAutoCompleteSource(JSON.parse(currentValue));
        }

        function filterFunc(a, b) {
            return (a.toLowerCase().indexOf(b.toLowerCase()) == 0) &&
                    (b != '') && (a.toLowerCase() != b.toLowerCase());
        }
    }

    Elements.Input {
        id: passwordTextInput

        width: 238
        height: 28
        textEchoMode: TextInput.Password
        editDefaultText: qsTr("PLACEHOLDER_PASSWORD_INPUT")
        showKeyboardLayout: true
        focus: true
        onEnterPressed: internalLogin();
        onTabPressed: loginTextInput.textEditComponent.focus = true;
    }

    Captcha {
        id: captchaObj

        visible: captchaRequired
        login: parent.login;
    }

    Elements.CheckBox {
        id: rememberCheckBox

        Component.onCompleted: rememberCheckBox.setValue(true);
        buttonText: qsTr("CHECKBOX_REMEMBER_ME")
    }

    Item {
        height: 34
        width: 1

        Row {
            height: 28
            spacing: 5

            Elements.Button {
                text: qsTr("AUTH_LOGIN_BUTTON")
                analitics: ['/Auth', 'Auth', 'General Login']
                onClicked: internalLogin();
            }

            Elements.Button {
                text: qsTr("AUTH_CANCEL_BUTTON")
                analitics: ['/Auth', 'Auth', 'Auth Cancel']
                onClicked: cancel();
            }
        }
    }
}
