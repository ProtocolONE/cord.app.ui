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

import "../../Controls"

ErrorContainer {
    id: root

    default property alias someName: root.data

    property alias placeholder: control.placeholder
    property alias text: control.text
    property alias error: control.error

    error: control.error

    style: ErrorMessageStyle {
        text: "#FF2E44"
        background: "#00000000"
    }

    onFocusChanged: {
        if (focus) {
            control.focus = true
        }
    }

    Input {
        id: control

        property bool passwordVisible: false

        iconCursor: CursorArea.PointingHandCursor

        onIconClicked: {
            passwordVisible = true;
            iconCursor = CursorArea.ArrowCursor;
        }

        echoMode: passwordVisible ? TextInput.Normal : TextInput.Password

        height: 48
        width: parent.width
        maximumLength: 32

        StateGroup {
            states: [
                State {
                    name: "PasswordHidden"
                    when: !control.passwordVisible && !control.iconHovered
                    PropertyChanges {
                        target: control
                        iconBackground: "#1ABC9C"
                        icon: installPath + "images/Controls/PasswordInput/openpass.png"
                    }
                },
                State {
                    name: "ShowHiddenPassword"
                    when: !control.passwordVisible && control.iconHovered
                    PropertyChanges {
                        target: control
                        iconBackground: "#019074"
                        icon: installPath + "images/Controls/PasswordInput/openpass.png"
                    }
                },
                State {
                    name: "PasswordVisible"
                    when: control.passwordVisible
                    PropertyChanges {
                        target: control
                        iconBackground: "#FFFFFF"
                        icon: installPath + "images/Controls/PasswordInput/lock.png"
                    }
                }
            ]
        }
    }
}
