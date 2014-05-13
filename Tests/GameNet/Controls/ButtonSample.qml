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

import "../Controls" as Controls
import "../Elements/Tooltip" as Tooltip

Rectangle {
    id: root

    color: "#DDDDDD"
    width: 800
    height: 600

    Column {
        x: 50
        y: 30
        spacing: 40

        Controls.Button {
            width: 200
            height: 50

            text: "Button"
            toolTip: "Simple button tooltip"
        }

        Controls.Button {
            enabled: false

            width: 200
            height: 50

            toolTip: "Disabled button"
        }

        Controls.TextButton {
            width: 350
            height: 40
            text: "Text button"
            toolTip: "Text button tooltip"
            style: Controls.ButtonStyleColors {
                normal: "#3498db"
                hover: "#3670DC"
                disabled: "#3498db"
            }
        }

        Controls.ImageButton {
            width: 40
            height: 40

            toolTip: "Iconed button"

            style: Controls.ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
                disabled: "#1ABC9C"
            }
            styleImages: Controls.ButtonStyleImages {
                normal: installPath + "Samples/images/mail.png"
            }
        }

        Controls.CheckBox {
            //width: 300
            height: 16

            text: "Check box"
            toolTip: "CheckBox button tooltip"
            style: Controls.ButtonStyleColors {
                normal: "#1ADC9C"
                hover: "#019074"
                disabled: "#1ADC9C"
            }
        }

        Controls.RadioButton {
            width: 300
            height: 40

            text: "Radio button"
            toolTip: "RadioButton button tooltip"
            style: Controls.ButtonStyleColors {
                normal: "#1ADC9C"
                hover: "#019074"
                disabled: "#1ADC9C"
            }
        }
    }


    Tooltip.Tooltip {}
}
