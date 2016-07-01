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
import Tulip 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Blocks.Auth 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

PopupBase {
    id: root

    title: qsTr("CONFIRM_GUEST_TITLE")

    defaultTitleColor: Styles.popupText
    defaultSpacing: 0
    defaultImplicitHeightAddition: 10

    QtObject {
        id: d

        function showError(message) {
            messageBody.backState = root.state;
            messageBody.message = message;
            root.state = "message";
        }
    }

    Column {
        id: formContainer

        anchors {
            left: parent.left
            right: parent.right
        }

        GuestConfirmBody {
            id: registration

            visible: false
            onError: d.showError(message);
            onAuthDone: {
                SignalBus.authDone(userId, appKey, cookie);

                if (root.model.serviceId) {
                    App.downloadButtonStart(root.model.serviceId);
                }

                root.close();
            }
        }

        MessageBody {
            id: messageBody

            property string backState

            height: 328
            visible: false
            onClicked: root.state = messageBody.backState;
        }
    }

    state: "registration"
    states: [
        State {
            name :"Initial"
            PropertyChanges {target: registration; visible: false}
            PropertyChanges {target: messageBody; visible: false}
        },
        State {
            name: "registration"
            extend: "Initial"
            PropertyChanges {target: registration; visible: true}
            StateChangeScript {
                script: registration.forceActiveFocus();
            }
        },
        State {
            name: "message"
            extend: "Initial"
            PropertyChanges {target: messageBody; visible: true}
        }
    ]
}
