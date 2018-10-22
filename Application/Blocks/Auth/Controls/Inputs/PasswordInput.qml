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
import GameNet.Controls 1.0

import "../../../../Core/App.js" as App
import "../../../../Core/Styles.js" as Styles

Item {
    id: root

    default property alias someName: root.data

    property alias placeholder: control.placeholder
    property alias text: control.text
    property alias error: control.error
    property alias errorMessage: errorContainer.errorMessage

    signal tabPressed()
    signal backTabPressed()

    height: 64
    implicitWidth: parent.width

    onFocusChanged: {
        if (focus) {
            control.focus = true
        }
    }

    Column {
        anchors.fill: parent
        Input {
            id: control

            language: App.keyboardLayout()
            capsLock: App.isCapsLockEnabled()
            passwordType: true

            height: 48
            width: parent.width
            maximumLength: 32

            onTabPressed: root.tabPressed();
            onBackTabPressed: root.backTabPressed();

            style {
                normal: Styles.style.inputNormal
                hover: Styles.style.inputHover
                active: Styles.style.inputActive
                disabled: Styles.style.inputDisabled
                error: Styles.style.inputError
                placeholder: Styles.style.inputPlaceholder
                text: Styles.style.inputText
                background: Styles.style.inputBackground
            }
            icon: installPath + "Assets/Images/GameNet/Controls/Input/password.png"
        }

        ErrorContainer {
            id: errorContainer

            error: root.error
            width: parent.width
            height: 16
        }
    }
}
