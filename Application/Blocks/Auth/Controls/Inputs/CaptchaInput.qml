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

import "../../../../Core/Authorization.js" as Authorization
import "../../../../Core/Styles.js" as Styles

Item {
    id: root

    default property alias data: root.data

    property alias text: captchaInput.text
    property alias source: captchaImage.source
    property alias error: captchaInput.error
    property alias errorMessage: errorContainer.errorMessage

    signal refresh();
    signal tabPressed()
    signal backTabPressed()

    height: 64
    implicitWidth: parent.width

    onFocusChanged: {
        if (focus) {
            captchaInput.focus = true
        }
    }

    Column {
        anchors.fill: parent

        Input {
            id: captchaInput

            height: 48
            maximumLength: 10
            width: parent.width
            showCapslock: false
            showLanguage: false
            icon: installPath + "Assets/Images/GameNet/Controls/Input/captcha.png"

            placeholder: qsTr("CAPTCHA_INPUT_PLACEHOLDER")
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

            Row {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    margins: 2
                }

                width: 240
                clip: true

                Item {
                    width: parent.width - parent.height
                    height: parent.height - 4

                    Image {
                        id: captchaImage

                        anchors.centerIn: parent
                    }
                }

                ImageButton {
                    width: parent.height
                    height: parent.height

                    toolTip: qsTr("CAPTCHA_INPUT_REFRESH_BUTTON_TOOLTIP")

                    style {
                        normal: "#00000000"
                        hover: "#00000000"
                        disabled: "#00000000"
                    }

                    styleImages {
                        normal: installPath + "Assets/Images/GameNet/Controls/Input/update.png"
                        hover: installPath + "Assets/Images/GameNet/Controls/Input/update_hover.png"
                    }

                    onClicked: root.refresh();
                }
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


