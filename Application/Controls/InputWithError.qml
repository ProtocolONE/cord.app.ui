/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (В©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/Styles.js" as Styles

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
    property alias validator: input.validator

    signal validate(string value)
    signal textChanged()
    signal enterPressed()
    signal tabPressed()
    signal backTabPressed()

    implicitWidth: parent.width
    error: input.error

    style {
        text: Styles.style.errorContainerText
        background: Styles.style.errorContainerBackground
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
        onEnterPressed: {
            root.enterPressed();
        }
        onTabPressed: {
            root.tabPressed();
        }
        onBackTabPressed: {
            root.backTabPressed();
        }
    }

    Timer {
        id: validateTimer

        interval: root.validationTimeout
        onTriggered: root.validate(input.text);
    }
}
