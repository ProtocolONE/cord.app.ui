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

import "../../../Core/App.js" as App
import "../../../Core/restapi.js" as RestApi
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

PopupBase {
    id: root

    property variant gameItem: App.currentGame()

    Component.onCompleted: sendGoogleStat('show');

    function sendGoogleStat(action) {
        if (root.gameItem) {
            GoogleAnalytics.trackEvent('/game/' + root.gameItem.gaName, 'PromoKey', action);
        }
    }

    title: qsTr("PROMO_CODE_TITLE")
    clip: true

    Item {
        id: body
        anchors {
            left: parent.left
            leftMargin: 20
        }
        width: root.width - 40
        height: childrenRect.height

        InputWithError {
            id: promoCode

            width: body.width
            icon: installPath + "Assets/Images/Application/Widgets/PromoCode/promo.png"
            showLanguage: true
            placeholder: qsTr("PROMO_CODE_PLACEHOLDER")
        }
    }

    PopupHorizontalSplit {
        width: root.width
    }

    Button {
        id: activateButton

        width: 200
        height: 48
        anchors {
            left: parent.left
            leftMargin: 20
        }
        text: qsTr("ACIVATE_BUTTON_CAPTION")
        enabled: promoCode.text.length > 0
        onClicked: {
            activateButton.inProgress = true;

            GoogleAnalytics.trackEvent('/PromoCode',
                                       'PromoKey',
                                       'Activate');

            RestApi.User.activatePromoKey(
                        promoCode.text,
                        function(response) {
                            activateButton.inProgress = false;

                            if (response.result === 1) {
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
                        });
        }
    }

}
