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
import Application.Controls 1.0 as AppControls

import "../../../../Core/App.js" as App
import "../../../../Core/Styles.js" as Styles

Item {
    id: root

    default property alias data: root.data

    property alias placeholder: input.placeholder
    property alias text: input.text
    property alias error: input.error
    property alias errorMessage: errorContainer.errorMessage
    property alias typeahead: input.typeahead
    property alias maximumLength: input.maximumLength

    signal tabPressed()
    signal backTabPressed()

    height: 64
    implicitWidth: parent.width

    onFocusChanged: {
        if (focus) {
            input.focus = true
        }
    }

    Column {
        anchors.fill: parent

        AppControls.Input {
            id: input

            icon: installPath + "Assets/Images/GameNet/Controls/Input/email.png"
            width: parent.width
            height: 48
            language: App.keyboardLayout()
            showCapslock: false

            onTabPressed: root.tabPressed();
            onBackTabPressed: root.backTabPressed();

            typeahead: TypeaheadBehaviour {
                dictionary: []
            }

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
        }

        ErrorContainer {
            id: errorContainer

            error: root.error
            width: parent.width
            height: 16
        }
    }
}