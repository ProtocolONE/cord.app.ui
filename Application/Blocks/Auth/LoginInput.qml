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
import "../../../Proxy/App.js" as App

ErrorContainer {
    id: root

    default property alias data: root.data

    property alias placeholder: input.placeholder
    property alias text: input.text
    property alias error: input.error
    property alias typeahead: input.typeahead

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

        icon: installPath + "Assets/Images/GameNet/Controls/LoginInput/login.png"
        width: parent.width
        height: 48
        language: App.keyboardLayout()
        capsLock: App.isCapsLockEnabled()

        typeahead: TypeaheadBehaviour {
            dictionary: ["nikita.gorbunov@syncopate.ruaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                "nikolay.bondarenko@syncopate.ru",
                "nikita.kravchuk@syncopate.ru",
                "nikita.gorbunov@syncopate.ru",
                                    "nikolay.bondarenko@syncopate.ru",
                                    "nikita.kravchuk@syncopate.ru",
                "nikita.gorbunov@syncopate.ru",
                                    "nikolay.bondarenko@syncopate.ru",
                                    "nikita.kravchuk@syncopate.ru",
                "nikita.gorbunov@syncopate.ru",
                                    "nikolay.bondarenko@syncopate.ru",
                                    "nikita.kravchuk@syncopate.ru"
            ]
        }
    }

}
