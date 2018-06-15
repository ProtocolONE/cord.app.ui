/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2018, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0
import Application.Blocks.Popup 1.0
import Application.Core.Popup 1.0
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Settings 1.0
import Application.Core.Authorization 1.0
import Application.Core.Styles 1.0

PopupBase {
    id: root

    title: qsTr("RESET_PIN_VIEW_HEADER_TEXT")

    onVisibleChanged: {
        codeError.error = false;
        codeInput.text = "";
        if (root.visible) {
            d.checkBDAccountsAnd2FaStatus();
        }
    }

    QtObject {
        id: d

        property bool inProgress: false
        property bool isBDAccounts: false
        property bool appCode: false
        property bool is2fa: false
        property int timeoutSMS

        function checkBDAccountsAnd2FaStatus() {

            d.inProgress = true;
            d.is2fa = false;
            d.isBDAccounts = false;

            RestApi.User.getCharsByGame(User.userId(), 1021, function(response) {

                d.inProgress = true;
                try
                {
                    d.isBDAccounts = response.length > 0;
                } catch(e) {
                    d.isBDAccounts = false;
                }

                if (d.isBDAccounts) {
                    d.get2FaStatus();
                }

            }, function(response) {
                console.log("checkBDAccountsAnd2FaStatus error");
            });

            return false;
        }

        function get2FaStatus() {

            d.inProgress = true;
            RestApi.User.get2FaStatus(function(response) {

                d.inProgress = false;

                if (response) {
                    d.is2fa = response.has2Fa;
                    d.appCode = response.hasApp;

                    if (d.is2fa && !d.appCode) {
                        d.getSMSCode();
                        return;
                    }
                }
            });
        }

        function getSMSCode() {

            d.inProgress = true;

            RestApi.User.getSMSCode(function(response) {

                d.inProgress = false;

                if (response.result === 1) {

                    timeout.text = qsTr("AUTH_SMSCODE_BODY_TIMEOUT_TEXT").arg(d.timeoutSMS = 60);
                    smsTimer.start();
                    return;

                }

                var error = response.error || null;

                if (!error) {

                    codeError.errorMessage = qsTr("RESET_PIN_FAIL_UNKNOWN");
                    codeError.error = true;

                } else {

                    codeError.errorMessage = error.message;
                    codeError.error = true;
                }

            }, function(response) {

                codeError.errorMessage = qsTr("RESET_PIN_FAIL_UNKNOWN");
                codeError.error = true;

            });
        }

        function resetPin() {

            d.inProgress = true;
            codeError.error = false;

            RestApi.Games.resetBlackDesertPin(codeInput.text, function(response) {

                d.inProgress = false;
                codeInput.text = "";

                if (response.result === 1) {

                    MessageBox.show(qsTr("RESET_PIN_INFO"), qsTr("RESET_PIN_MESSAGE"), MessageBox.button.ok);
                    root.close();
                    return;
                }

                var error = response.error || null;

                if (!error) {

                    codeError.errorMessage = qsTr("RESET_PIN_FAIL_UNKNOWN");
                    codeError.error = true;

                } else {

                    codeError.errorMessage = error.message;
                    codeError.error = true;
                }

            }, function(response) {

                codeError.errorMessage = qsTr("RESET_PIN_FAIL_UNKNOWN");
                codeError.error = true;

            });
        }

        function onSMSTimer() {
            d.timeoutSMS--;
            timeout.text = qsTr("AUTH_SMSCODE_BODY_TIMEOUT_TEXT").arg(d.timeoutSMS);
            if (d.timeoutSMS == 0)
                smsTimer.stop();
        }

        function getInfoText() {

            if (!d.isBDAccounts) {
                return qsTr("NO_BD_ACCOUNTS_SUB_TITLE");
            } else if(!d.is2fa) {
                return qsTr("NO_2FA_BODY_SUB_TITLE").arg(Config.GnUrl.site("/my-settings/security/"));
            } else if (d.appCode) {
                return qsTr("AUTH_APPCODE_BODY_SUB_TITLE");
            } else {
                return qsTr("AUTH_SMSCODE_BODY_SUB_TITLE");
            }
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

        Text {
            width: parent.width
            text: d.getInfoText()
            color: defaultTextColor

            font { family: "Open Sans Regular"; pixelSize: 15 }
            wrapMode: Text.WordWrap
            anchors{
                baseline: parent.top
                baselineOffset: 15
            }
            smooth: true
            textFormat: Text.StyledText
            linkColor: Styles.linkText
            onLinkActivated: App.openExternalUrlWithAuth(link)

            MouseArea {
                anchors.fill: parent
                cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                acceptedButtons: Qt.NoButton
            }
        }

        Item {
            visible: !d.is2fa;
            width: parent.width
            height: 48

            TextButton {
                text: qsTr("CLOSE_BUTTON_LABEL")

                height: parent.height
                anchors.right: parent.right
                font {family: "Open Sans Regular"; pixelSize: 15}
                onClicked: root.close();
            }
        }

        Column {
            visible: d.is2fa;
            spacing: 24
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
                height: 48
            }
        }

        Item {
            visible: d.is2fa;
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
                height: parent.height
                visible: d.timeoutSMS == 0;
                text: qsTr("AUTH_SMSCODE_BODY_SEND_BUTTON")
                fontSize: 12
                onClicked: d.getSMSCode();
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
                onClicked: root.close();
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
                onClicked: d.resetPin();
                analytics {
                   category: 'Auth security code'
                   label: 'Confirm security code'
                }
            }
        }
    }
}
