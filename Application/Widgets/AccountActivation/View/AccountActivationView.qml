/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

PopupBase {
    id: root

    clip: true
    title: qsTr("ACCOUNT_ACTIVATION")

    Component.onCompleted: d.requestServiceId = App.currentGame().serviceId;

    QtObject {
        id: d

        property string requestServiceId

        function requestActivationCode() {
            requestCodeButton.inProgress = true;

            RestApi.User.sendMobileActivationCode(
                        phone.text,
                        function(response) {
                            requestCodeButton.inProgress = false;

                            if (response.result === 1) {
                                phone.error = false;
                                requestCodeError.error = false;
                                stateGroup.state = "ValidateCode";
                                code.forceActiveFocus();
                                return;
                            }

                            if (response.error) {
                                phone.error = true;
                                requestCodeError.error = true;

                                if (response.error.message != "") {
                                    requestCodeError.errorMessage = response.error.message;
                                } else {
                                    requestCodeError.errorMessage = qsTr("ACCOUNT_ACTIVATION_PHONE_NOT_FOUND");
                                }
                            }
                        },
                        function(response) {
                            requestCodeButton.inProgress = false;

                            phone.error = true;
                            requestCodeError.error = true;
                            requestCodeError.errorMessage = qsTr("ACCOUNT_ACTIVATION_PHONE_NOT_FOUND");
                        });
        }

        function validateActivationCode() {
            validateCodeButton.inProgress = true;

            RestApi.User.validateMobileActivationCode(
                        code.text,
                        function(response) {
                            validateCodeButton.inProgress = false;

                            if (response.result === 1) {
                                code.error = false;
                                validateCodeError.error = false;
                                if (d.requestServiceId) {
                                    App.downloadButtonStart(d.requestServiceId);
                                }
                                root.close();
                                return;
                            }


                            if (response.error) {
                                code.error = true;
                                validateCodeError.error = true;
                                if (response.error.message != "") {
                                    validateCodeError.errorMessage = response.error.message;
                                } else {
                                    validateCodeError.errorMessage = qsTr("ACCOUNT_ACTIVATION_ERROR");
                                }
                            }
                        },
                        function(response) {
                            validateCodeButton.inProgress = false;

                            code.error = true;
                            validateCodeError.error = true;
                            validateCodeError.errorMessage = qsTr("ACCOUNT_ACTIVATION_ERROR");
                        });
        }
    }

    Text {
        anchors {
            left: parent.left
            right: parent.right
        }
        font {
            family: 'Arial'
            pixelSize: 14
        }
        color: defaultTextColor
        smooth: true
        wrapMode: Text.WordWrap
        text: qsTr("ACCOUNT_ACTIVATION_TIP")
    }

    PopupHorizontalSplit {
    }

    Item {
        id: body

        anchors {
            left: parent.left
            right: parent.right
        }
        height: childrenRect.height

        Text {
            id: phoneLabel

            font {
                family: 'Arial'
                pixelSize: 14
            }
            color: defaultTextColor
            smooth: true
            text: qsTr("FIRST_STEP_TIP")
        }

        PhoneInput {
            id: phone

            anchors {
                top: phoneLabel.bottom
                topMargin: 16
            }
            readOnly: requestCodeButton.inProgress
            width: body.width
            placeholder: qsTr("PLACEHOLDER_PHONE")
            onEnterPressed: d.requestActivationCode();
            onTextChanged: requestCodeError.error = false;
            onTabPressed: code.forceActiveFocus();
            onBackTabPressed: code.forceActiveFocus();
        }
    }

    Row {
        spacing: 10
        anchors {
            left: parent.left
            right: parent.right
        }

        PrimaryButton {
            id: requestCodeButton

            width: 200
            height: 48
            enabled: phone.text.length > 0 && stateGroup.state == "RequestCode"
            text: qsTr("BUTTON_GET_CODE")

            analytics {
                category: "AccountActivation"
                action: "submit"
                label: "Request phone code"
            }
            onClicked: d.requestActivationCode();
        }

        ErrorContainer {
            id: requestCodeError

            width: parent.width - requestCodeButton.width - parent.spacing
            height: 48
        }
    }

    PopupHorizontalSplit {}

    Item {
        id: step2

        anchors {
            left: parent.left
            right: parent.right
        }
        height: childrenRect.height

        Text {
            id: codeLabel

            font {
                family: 'Arial'
                pixelSize: 14
            }
            color: defaultTextColor
            smooth: true
            text: qsTr("SECOND_STEP_TIP")
        }

        InputWithError {
            id: code

            anchors {
                top: codeLabel.bottom
                topMargin: 16
            }

            width: body.width
            icon: installPath + Styles.accountActivationLockIcon
            readOnly: validateCodeButton.inProgress
            validator: RegExpValidator { regExp: /[0-9]{,10}/ }
            placeholder: qsTr("PLACEHOLDER_ACTIVATION_CODE_INPUT")
            onEnterPressed: d.validateActivationCode();
            onTextChanged: validateCodeError.error = false;
            onTabPressed: phone.forceActiveFocus();
            onBackTabPressed: phone.forceActiveFocus();
        }
    }

    PopupHorizontalSplit {}

    Row {
        spacing: 10
        anchors {
            left: parent.left
            right: parent.right
        }

        PrimaryButton {
            id: validateCodeButton

            width: 200
            height: 48
            enabled: code.text.length > 0 && stateGroup.state == "ValidateCode"
            text: qsTr("BUTTON_CODE_CONFIRM")

            analytics {
                category: "AccountActivation"
                action: "submit"
                label: "Validate phone code"
            }

            onClicked: d.validateActivationCode();
        }

        ErrorContainer {
            id: validateCodeError

            width: parent.width - validateCodeButton.width - parent.spacing
            height: 48
        }
    }

    StateGroup {
        id:  stateGroup

        state: "RequestCode"
        states: [
            State {
                name: "RequestCode"
                PropertyChanges { target: code; enabled: false }
            },
            State {
                name: "ValidateCode"
                PropertyChanges { target: phone; enabled: false }
            }
        ]
    }
}
