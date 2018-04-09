/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0

import GameNet.Controls 1.0
import GameNet.Core 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Authorization 1.0
import Application.Core.Styles 1.0

import "./Controls"
import "./Controls/Inputs"

Form {
    id: root

    signal securityCodeRequired(bool appCode);
    signal authDone(string userId, string appKey, string cookie, bool remember);
    signal error(string message);
    signal cancel();

    property string login
    property string password
    property string captcha
    property bool remember
    property bool appCode: false
    property int bottomMargin: 160

    title: qsTr("AUTH_SECCODE_BODY_TITLE")
    subTitle: appCode ? qsTr("AUTH_APPCODE_BODY_SUB_TITLE") : qsTr("AUTH_SMSCODE_BODY_SUB_TITLE")

    onVisibleChanged: {
        codeError.error = false;
        codeInput.text = "";
        if (root.visible && !root.appCode) {
            d.sendSMS();
        }
        codeInput.forceActiveFocus();
    }

    QtObject {
        id: d
        property bool inProgress: false
        property alias code2fa: codeInput.text
        property int timeoutSMS

        function sendSMS() {
            d.inProgress = true;
            Authorization.requestSMSCode(root.login, function(error, response) {

                d.inProgress = false;

                if (Authorization.isSuccess(error)) {
                    timeout.text = qsTr("AUTH_SMSCODE_BODY_TIMEOUT_TEXT").arg(d.timeoutSMS = 60);
                    smsTimer.start();
                    return;
                }

                if (error === Authorization.Result.SecurityCodeInvalid) {
                    codeError.errorMessage = qsTr("AUTH_SECURITY_CODE_INVALID");
                    codeError.error = true;
                    return;
                }

                if (error === Authorization.Result.SecurityCodeTimeoutIsNotExpired) {
                    codeError.errorMessage = qsTr("AUTH_SMS_TIMEOUT_IS_NOT_EXPIRED");
                    codeError.error = true;
                    return;
                }

                if (!response) {
                    root.error(qsTr("AUTH_FAIL_GAMENET_UNAVAILABLE"));
                    return;
                }

                var errorMessage = response.message || (qsTr("AUTH_FAIL_GAMENET_UNKNOWN").arg(response.code));
                root.error(errorMessage);
            });
        }

        function authSuccess(response) {
            root.authDone(response.userId, response.appKey, response.cookie, root.remember);
        }

        function onSMSTimer() {
            d.timeoutSMS--;
            timeout.text = qsTr("AUTH_SMSCODE_BODY_TIMEOUT_TEXT").arg(d.timeoutSMS);
            if (d.timeoutSMS == 0)
                smsTimer.stop();
        }

        function genericAuth() {

            if (d.inProgress || !App.authAccepted) {
                return;
            }

            d.inProgress = true;
            codeError.error = false;

            Authorization.setCaptcha(root.captcha);
            Authorization.setCode2fa(d.code2fa);
            d.code2fa = "";

            Authorization.loginByGameNet(root.login, root.password, root.remember, function(error, response) {

                d.inProgress = false;
                codeInput.text = "";

                if (Authorization.isSuccess(error)) {
                    console.log("Authorization is Successed");
                    d.authSuccess(response);
                    return;
                }

                if (error === Authorization.Result.SecurityCodeInvalid) {
                    codeError.errorMessage = qsTr("AUTH_SECURITY_CODE_INVALID");
                    codeError.error = true;
                    return;
                }

                if (error === Authorization.Result.SecurityCodeTimeoutIsNotExpired) {
                    codeError.errorMessage = qsTr("AUTH_SMS_TIMEOUT_IS_NOT_EXPIRED");
                    codeError.error = true;
                    return;
                }

                if (!response) {
                    root.error(qsTr("AUTH_FAIL_GAMENET_UNAVAILABLE"));
                    return;
                }

                var msg = {
                    0: qsTr("AUTH_FAIL_MESSAGE_UNKNOWN_ERROR"),
                };

                msg[RestApi.Error.AUTHORIZATION_FAILED] = qsTr("AUTH_FAIL_MESSAGE_WRONG");
                msg[RestApi.Error.INCORRECT_FORMAT_EMAIL] = qsTr("AUTH_FAIL_MESSAGE_INCORRECT_EMAIL_FORMAT");
                msg[RestApi.Error.ACCOUNT_NOT_EXISTS] = qsTr("AUTH_FAIL_MESSAGE_ACCOUNT_NOT_EXISTS");
                msg[Authorization.Result.ServiceAccountBlocked] = qsTr("AUTH_FAIL_ACCOUNT_BLOCKED");
                msg[Authorization.Result.WrongLoginOrPassword] = qsTr("AUTH_FAIL_MESSAGE_WRONG");

                var errorMessage;
                if (msg[error]) {
                    errorMessage = msg[error];
                } else {
                    errorMessage = response ? (msg[response.code] || msg[0]) : msg[0];
                }

                root.error(errorMessage);
            });
        }
    }

    Timer {
        id: smsTimer

        repeat: true
        interval: 1000
        onTriggered: d.onSMSTimer();
    }

    Column {
        width: parent.width
        spacing: 15

        Column {
            width: parent.width
            z: 1

            Input {
                id: codeInput

                width: parent.width
                height: 48
                placeholder: qsTr("AUTH_SECCODE_BODY_CODE_PLACEHOLDER")
                icon: installPath + Styles.inputPasswordIcon
                enabled: !d.inProgress;
            }

            ErrorContainer {
                id: codeError

                width: parent.width
                height: 16
            }
        }

        Item {
            width: parent.width
            height: 48

            Text {
                id: timeout
                width: parent.width
                height: parent.height
                wrapMode: Text.WordWrap
                anchors.left: parent.left
                visible: d.timeoutSMS != 0;
                color: Styles.infoText
                text: qsTr("AUTH_SMSCODE_BODY_TIMEOUT_TEXT").arg(d.timeoutSMS)
            }

            TextButton {
                width: parent.width
                height: parent.height
                visible: d.timeoutSMS == 0;
                text: qsTr("AUTH_SMSCODE_BODY_SEND_BUTTON")
                fontSize: 12
                onClicked: d.sendSMS();
                enabled: !d.inProgress;
                analytics {
                   category: 'Auth security code'
                   label: 'resend sms code'
                }
            }

            TextButton {
                text: qsTr("AUTH_CANCEL_BUTTON")

                width: 80
                height: parent.height
                anchors.right: parent.right
                anchors.rightMargin: 150

                font {family: "Open Sans Regular"; pixelSize: 15}
                onClicked: root.cancel();
                analytics {
                    category: 'Auth security Code'
                    label: 'Code cancel'
                }
            }

            PrimaryButton {
                width: 150
                height: parent.height
                anchors.right: parent.right

                text: qsTr("AUTH_SECCODE_BODY_CONFIRM_BUTTON")
                font {family: "Open Sans Regular"; pixelSize: 15}
                inProgress: d.inProgress;
                enabled: codeInput.text.length >= 6
                onClicked: d.genericAuth();
                analytics {
                   category: 'Auth security code'
                   label: 'Confirm security code'
                }
            }
        }
    }
}
