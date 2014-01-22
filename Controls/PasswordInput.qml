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

Input {
    id: control

    property bool passwordVisible: false

    onIconClicked: {
        passwordVisible = true;
    }

    echoMode: passwordVisible ? TextInput.Normal : TextInput.Password

    StateGroup {
        states: [
            State {
                name: "PasswordHidden"
                when: !passwordVisible && !iconHovered
                PropertyChanges {
                    target: control
                    iconBackground: "#1ABC9C"
                    icon: installPath + "Images/Controls/PasswordInput/openpass.png"
                }
            },
            State {
                name: "ShowHiddenPassword"
                when: !passwordVisible && iconHovered
                PropertyChanges {
                    target: control
                    iconBackground: "#019074"
                    icon: installPath + "Images/Controls/PasswordInput/openpass.png"
                }
            },
            State {
                name: "PasswordVisible"
                when: passwordVisible
                PropertyChanges {
                    target: control
                    iconBackground: "#FFFFFF"
                    icon: installPath + "Images/Controls/PasswordInput/lock.png"
                }
            }
        ]
    }

}
