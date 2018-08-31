import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Authorization 1.0
import Application.Core.Styles 1.0

import "./Controls"
import "./Controls/Inputs"

Form {
    id: root

    property string login
    property bool codeSended: false

    signal success();
    signal cancel();

    title: qsTr("CODE_BODY_TITLE")
    subTitle: qsTr("CODE_BODY_INFO")

    footer {
        visible: true
    }

    onVisibleChanged: requestError.error = false;

    QtObject {
        id: d

        function getCode(method) {
            SignalBus.setGlobalProgressVisible(true, 0);
            Authorization.sendUnblockCode(root.login, method, function(result, response) {
                SignalBus.setGlobalProgressVisible(false, 0);

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
            SignalBus.setGlobalProgressVisible(true, 0);
            Authorization.unblock(root.login, codeInput.text, function(result, response) {
                SignalBus.setGlobalProgressVisible(false, 0);

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
        width: parent.width
        spacing: 20

        TopErrorContainer {
            id: requestError

            Row {
                width: parent.width
                height: 48
                spacing: 20

                AuxiliaryButton {
                    height: parent.height
                    width: 240
                    text: qsTr("CODE_BODY_SEND_BY_MAIL")
                    onClicked: d.getCode('email');
                    analytics {
                        category: 'Auth Code'
                        label: 'Send Code By Email'
                    }
                }

                AuxiliaryButton {
                    height: parent.height
                    width: 240
                    text: qsTr("CODE_BODY_SEND_BY_SMS")
                    onClicked: d.getCode('sms');
                    analytics {
                        category: 'Auth Code'
                        label: 'Send Code By Sms'
                    }
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
                icon: installPath + Styles.inputPasswordIcon
            }
        }

        Row {
            width: parent.width
            height: 48
            spacing: 30

            PrimaryButton {
                width: 200
                height: parent.height
                analytics {
                    category: 'Auth Code'
                    label: 'Confirm code'
                }

                text: qsTr("CODE_BODY_CONFIRM_BUTTON")
                enabled: root.codeSended
                onClicked: d.unblock();
            }

            ContentStroke {
                width: 1
                height: parent.height
                opacity: 0.25
            }

            TextButton {
                text: qsTr("CODE_BODY_CANCEL_BUTTON")

                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.cancel();
                analytics {
                    category: 'Auth Code'
                    label: 'Code Cancel'
                }
            }
        }
    }
}
