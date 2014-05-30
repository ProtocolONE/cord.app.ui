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

import "../../../js/Authorization.js" as Authorization
import "../../../js/Core.js" as Core

Item {
    id: root

    property string login
    property bool codeSended: false

    implicitHeight: 473
    implicitWidth: 500

    onVisibleChanged: requestError.error = false;

    signal success();
    signal cancel();

    QtObject {
        id: d

        function getCode(method) {
            Core.setGlobalProgressVisible(true);
            Authorization.sendUnblockCode(root.login, method, function(result, response) {
                Core.setGlobalProgressVisible(false);

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
            Core.setGlobalProgressVisible(true);
            Authorization.unblock(root.login, codeInput.text, function(result, response) {
                Core.setGlobalProgressVisible(false);

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
                        color: "#363636"
                    }
                }

                Text {
                    width: parent.width
                    font { family: "Arial"; pixelSize: 14 }
                    color: "#66758F"
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

                    style: ButtonStyleColors {
                        normal: "#1ABC9C"
                        hover: "#019074"
                    }

                    onClicked: d.getCode('email');
                }

                Button {
                    height: parent.height
                    width: 240
                    text: qsTr("CODE_BODY_SEND_BY_SMS")

                    style: ButtonStyleColors {
                        normal: "#1ABC9C"
                        hover: "#019074"
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
                color: "#CCCCCC"
                height: parent.height
            }

            TextButton {
                text: qsTr("CODE_BODY_CANCEL_BUTTON")

                anchors.verticalCenter: parent.verticalCenter
                style: ButtonStyleColors {
                    normal: "#3498db"
                    hover: "#3670DC"
                    disabled: "#3498db"
                }

                onClicked: root.cancel();
            }
        }
    }
}
