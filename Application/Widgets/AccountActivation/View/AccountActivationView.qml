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
import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../../Core/restapi.js" as RestApiJs

PopupBase {
    id: root

    clip: true
    title: qsTr("ACCOUNT_ACTIVATION")

    QtObject {
        id: d

        property bool inProgress: false
        property int pendingCodeRequests: 0

        function requestActivationCode() {
            d.inProgress = true;
            RestApiJs.User.sendMobileActivationCode(
                        phone.text,
                        function(response) {
                            d.inProgress = false;

                            if (response.result === 1) {
                                phone.error = false;
                                requestCodeError.error = false;
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
                            d.inProgress = false;

                            phone.error = true;
                            requestCodeError.error = true;
                            requestCodeError.errorMessage = qsTr("ACCOUNT_ACTIVATION_PHONE_NOT_FOUND");
                        });
        }

        function validateActivationCode() {
            d.inProgress = true;
            RestApiJs.User.validateMobileActivationCode(
                        code.text,
                        function(response) {
                            d.inProgress = false;

                            if (response.result === 1) {
                                code.error = false;
                                validateCodeError.error = false;
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
                            d.inProgress = false;

                            code.error = true;
                            validateCodeError.error = true;
                            validateCodeError.errorMessage = qsTr("ACCOUNT_ACTIVATION_ERROR");
                        });
        }
    }


    Text {
        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
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
        width: root.width
    }

    Item {
        id: body
        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
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
            readOnly: d.inProgress
            width: body.width
            placeholder: qsTr("PLACEHOLDER_PHONE")
            onEnterPressed: d.requestActivationCode();
            onTextChanged: requestCodeError.error = false;
            onTabPressed: code.focus = true;
            onBackTabPressed: code.focus = true;
        }
    }

    Item {
        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }
        height: childrenRect.height

        Row {
            spacing: 20

            Button {
                id: requestCodeButton

                width: 200
                height: 48
                enabled: phone.text.length > 0
                text: qsTr("BUTTON_GET_CODE")

                analytics: GoogleAnalyticsEvent {
                    page: "/AccountActivation/"
                    category: "Auth"
                    action: "Request phone code"
                }

                onClicked: d.requestActivationCode();
            }

            ErrorContainer {
                id: requestCodeError

                width: 350
                height: 48
            }
        }
    }

    PopupHorizontalSplit {
        width: root.width
    }

    Item {
        id: step2
        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
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
            icon: installPath + "Assets/Images/Application/Widgets/AccountActivation/lock.png"
            readOnly: d.inProgress
            validator: RegExpValidator { regExp: /[0-9]{,10}/ }
            placeholder: qsTr("PLACEHOLDER_ACTIVATION_CODE_INPUT")
            onEnterPressed: d.validateActivationCode();
            onTextChanged: validateCodeError.error = false;
            onTabPressed: phone.focus = true;
            onBackTabPressed: phone.focus = true;
        }
    }

    PopupHorizontalSplit {
        width: root.width
    }

    Item {
        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }
        height: childrenRect.height

        Row {
            spacing: 20

            Button {
                id: validateCodeButton

                width: 200
                height: 48
                enabled: code.text.length > 0
                text: qsTr("BUTTON_CODE_CONFIRM")

                analytics: GoogleAnalyticsEvent {
                    page: "/AccountActivation/"
                    category: "Auth"
                    action: "Validate phone code"
                }

                onClicked: d.validateActivationCode();
            }

            ErrorContainer {
                id: validateCodeError

                width: 350
                height: 48
            }
        }
    }
}
