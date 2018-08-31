import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Authorization 1.0
import Application.Core.Styles 1.0

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
            icon: installPath + Styles.inputCaptchaIcon

            placeholder: qsTr("CAPTCHA_INPUT_PLACEHOLDER")
            onTabPressed: root.tabPressed();
            onBackTabPressed: root.backTabPressed();

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
                        normal: installPath + Styles.inputUpdateIcon //"Assets/Images/ProtocolOne/Controls/Input/update.png"
                        hover: installPath + Styles.inputUpdateIcon.replace('.png', '_hover.png') //"Assets/Images/ProtocolOne/Controls/Input/update_hover.png"
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


