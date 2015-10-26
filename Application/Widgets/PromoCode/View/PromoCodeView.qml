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

import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

PopupBase {
    id: root

    property variant gameItem

    Component.onCompleted: {
        root.gameItem = App.currentGame();
    }

    title: qsTr("Активация ключа")
    clip: true

    Item {
        width: parent.width
        height: childrenRect.height

        InputWithError {
            id: promoCode

            width: parent.width
            icon: installPath + Styles.promoCodeIcon
            showLanguage: true
            placeholder: qsTr("Введите ключ")
        }
    }

    PrimaryButton {
        id: activateButton

        width: Math.max(implicitWidth, 200)
        text: qsTr("ACIVATE_BUTTON_CAPTION")
        enabled: promoCode.text.length > 0
        analytics {
            category: 'PromoCode'
            action: 'submit'
            label: root.gameItem ? root.gameItem.gaName : null
        }

        onClicked: {
            activateButton.inProgress = true;

            RestApi.User.activatePromoKey(
                        promoCode.text,
                        function(response) {
                            activateButton.inProgress = false;

                            if (response.result === 1) {
                                App.downloadButtonStart(root.gameItem.serviceId)
                                root.close();
                                return;
                            }

                            if (response.error) {
                                promoCode.errorMessage = response.error.message;
                                promoCode.error = true;


                            } else {
                                promoCode.errorMessage = qsTr("UNKNOWN_PROMO_VALIDATION_ERROR");
                                promoCode.error = true;
                            }

                        },
                        function(httpError) {
                            activateButton.inProgress = false;
                            promoCode.errorMessage = qsTr("UNKNOWN_PROMO_VALIDATION_ERROR");
                            promoCode.error = true;

                            Ga.trackException(promoCode.errorMessage, false);
                        });
        }
    }

}
