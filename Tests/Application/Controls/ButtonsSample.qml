/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0 as AppControl

Rectangle {
    id: root

    color: "#002336"
    width: 800
    height: 600

    Column {
        x: 50
        y: 30
        spacing: 20

        AppControl.PrimaryButton {
            id: firstButton

            width: 200
            height: 50

            text: "Button"
            toolTip: "Simple button tooltip"
            inProgress: inProgressRadioButton.checked
            enabled: !disabledRadioButton.checked

        }

        AppControl.PrimaryButton {
            enabled: false

            width: 200
            height: 50

            toolTip: "Disabled button"
            text: "Button2"
        }

        TextButton {
            width: 350
            height: 40
            text: "Text button"
            toolTip: "Text button tooltip"
            style {
                normal: "#3498db"
                hover: "#3670DC"
                disabled: "#3498db"
            }
        }

        ImageButton {
            width: 40
            height: 40

            toolTip: "Iconed button"

            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
                disabled: "#1ABC9C"
            }
            styleImages: ButtonStyleImages {
                normal: installPath + "Samples/images/mail.png"
            }
        }

        AppControl.CheckBox {
            text: "Check box"
            toolTip: "CheckBox button tooltip"
        }

        AppControl.RadioButton {
            id: inProgressRadioButton

            text: "In progress"
            toolTip: "In progress button tooltip"
            onClicked: {
                if (disabledRadioButton.checked) {
                    disabledRadioButton.checked = false;
                }

                if (normalRadioButton.checked) {
                    normalRadioButton.checked = false;
                }

                checked = true;
            }
        }

        AppControl.RadioButton {
            id: disabledRadioButton

            text: "Disable button"
            toolTip: "Disable button tooltip"

            onClicked: {
                if (inProgressRadioButton.checked) {
                    inProgressRadioButton.checked = false;
                }

                if (normalRadioButton.checked) {
                    normalRadioButton.checked = false;
                }

                checked = true;
            }
        }

        AppControl.RadioButton {
            id: normalRadioButton

            text: "Normal state button"
            toolTip: "Normal state button tooltip"
            onClicked: {
                if (inProgressRadioButton.checked) {
                    inProgressRadioButton.checked = false;
                }
                if (disabledRadioButton.checked) {
                    disabledRadioButton.checked = false;
                }

                checked = true;
            }
        }
    }
}
