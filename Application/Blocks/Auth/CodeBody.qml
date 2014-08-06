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
import GameNet.Controls 1.0

import "../../Core/Authorization.js" as Authorization
import "../../Core/App.js" as App
import "../../Core/Styles.js" as Styles

Item {
    id: root

    property string login
    property bool codeSended: false

    signal success();
    signal cancel();

    implicitHeight: 473
    implicitWidth: 500

    onVisibleChanged: requestError.error = false;

    QtObject {
        id: d

        function getCode(method) {
            App.setGlobalProgressVisible(true);
            Authorization.sendUnblockCode(root.login, method, function(result, response) {
                App.setGlobalProgressVisible(false);

                if (Authorization.isSuccess(result)) {
                    requestError.error = false;
                    root.codeSended = true;
                } else {
                    requestError.errorMessage = response.message;
                    requestError.error = true;
                }
            });
        }

        function unblock() {
            App.setGlobalProgressVisible(true);
            Authorization.unblock(root.login, codeInput.text, function(result, response) {
                App.setGlobalProgressVisible(false);

                if (Authorization.isSuccess(result)) {
                    root.success();
                } else {
                    codeError.errorMessage = response.message;
                    codeError.error = true;
                }
            });
        }
    }

    Column {
        anchors.fill: parent
        spacing: 20

        Item {
            width: parent.width
            height: 90

            Column {
                anchors.fill: parent
                spacing: 20

                Item {
                    width: parent.width
                    height: 35

                    Text {
                        text: qsTr("CODE_BODY_TITLE")
                        font { family: "Arial"; pixelSize: 20 }
                        anchors.baseline: parent.bottom
                        color: Styles.style.authTitleText
                    }
                }

                Text {
                    width: parent.width
                    font { family: "Arial"; pixelSize: 14 }
                    color: Styles.style.authSubTitleText
                    wrapMode: Text.WordWrap
                    text: qsTr("CODE_BODY_INFO")
                }
            }
        }

        TopErrorContainer {
            id: requestError

            Row {
                width: parent.width
                height: 48
                spacing: 20

                Button {
                    height: parent.height
                    width: 240
                    text: qsTr("CODE_BODY_SEND_BY_MAIL")

                    style {
                        normal: Styles.style.authSendCodeButtonNormal
                        hover: Styles.style.authSendCodeButtonHover
                    }

                    onClicked: d.getCode('email');
                }

                Button {
                    height: parent.height
                    width: 240
                    text: qsTr("CODE_BODY_SEND_BY_SMS")

                    style {
                        normal: Styles.style.authSendCodeButtonNormal
                        hover: Styles.style.authSendCodeButtonHover
                    }

                    onClicked: d.getCode('sms');
                }
            }

            width: parent.width
        }

        ErrorContainer {
            id: codeError

            width: parent.width
            visible: root.codeSended

            Input {
                id: codeInput

                width: parent.width
                height: 48
                placeholder: qsTr("CODE_BODY_CODE_INPUT_PLACEHOLDER")
                icon: installPath + "Assets/Images/GameNet/Controls/PasswordInput/lock.png"
            }
        }

        Row {
            width: parent.width
            height: 48
            spacing: 30

            Button {
                width: 200
                height: parent.height
                text: qsTr("CODE_BODY_CONFIRM_BUTTON")
                enabled: root.codeSended
                onClicked: d.unblock();
            }

            Rectangle {
                width: 1
                color: Styles.style.authDelimiter
                height: parent.height
            }

            TextButton {
                text: qsTr("CODE_BODY_CANCEL_BUTTON")

                anchors.verticalCenter: parent.verticalCenter
                style {
                    normal: Styles.style.authCancelCodeHormal
                    hover: Styles.style.authCancelCodeHover
                    disabled: Styles.style.authCancelCodeHormal
                }

                onClicked: root.cancel();
            }
        }
    }
}
