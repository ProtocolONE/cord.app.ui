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
import GameNet.Controls 1.0
import "../../js/Authorization.js" as Authorization

ErrorContainer {
    id: root

    default property alias data: root.data

    property alias text: captchaInput.text
    property alias source: captchaImage.source
    property alias error: captchaInput.error


    signal refresh();

    implicitWidth: parent.width
    error: root.error

    onFocusChanged: {
        if (focus) {
            captchaInput.focus = true
        }
    }

    Item {
        width: parent.width
        height: 48

        Row {
            anchors.fill: parent
            spacing: 20

            Input {
                id: captchaInput

                height: 48
                width: 240
                showCapslock: false
                showLanguage: false
                icon: installPath + "Assets/Images/Auth/captcha.png"

                //placeholder: "Код с картинки справа"
                placeholder: qsTr("CAPTCHA_INPUT_PLACEHOLDER")
            }

            Item {
                height: 48
                width: 240

                Rectangle {
                    color: "#FFFFFF"
                    anchors { fill: parent; margins: 1 }
                    border { color: "#CDCDCD"; width: 2 }
                }

                Row {
                    anchors { fill: parent; margins: 2 }

                    Item {
                        width: parent.width - parent.height
                        height: parent.height

                        Image {
                            id: captchaImage

                            anchors.centerIn: parent
                        }
                    }

                    ImageButton {
                        width: parent.height
                        height: parent.height

                        //toolTip: "Refresh"
                        toolTip: qsTr("CAPTCHA_INPUT_REFRESH_BUTTON_TOOLTIP")

                        style: ButtonStyleColors {
                            normal: "#1BBC9B"
                            hover: "#019074"
                            disabled: "#1ABC9C"
                        }

                        styleImages: ButtonStyleImages {
                            normal: installPath + "Assets/Images/Auth/refresh.png"
                        }

                        onClicked: root.refresh();
                    }
                }
            }

        }

    }
}

