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
import GameNet.Controls 1.0

ErrorContainer {
    id: root

    default property alias data: root.data

    property int validationTimeout: 300
    property alias icon: input.icon
    property alias showCapslock: input.showCapslock
    property alias showLanguage: input.showLanguage
    property alias placeholder: input.placeholder
    property alias text: input.text
    property alias readOnly: input.readOnly
    property alias error: input.error

    signal validate(string value)
    signal textChanged()

    implicitWidth: parent.width
    error: input.error

    style: ErrorMessageStyle {
        text: "#FF2E44"
        background: "#00000000"
    }

    onFocusChanged: {
        if (focus) {
            input.focus = true
        }
    }

    Input {
        id: input

        width: parent.width
        height: 48
        showCapslock: false
        showLanguage: false
        error: root.error
        onTextChanged: {
            root.textChanged();
            validateTimer.restart();
        }
    }

    Timer {
        id: validateTimer

        interval: root.validationTimeout
        onTriggered: root.validate(input.text);
    }
}
