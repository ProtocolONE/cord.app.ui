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

    Text {
        font {
            family: 'Arial'
            pixelSize: 14
        }
        visible: !!root.gameItem && (root.gameItem.serviceId == '30000000000')
        width: parent.width
        color: defaultTextColor
        smooth: true
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        text: (function() {
            var currentDate = (Date.now()/1000)|0,
                color = Styles.style.linkText.toString();

            if (currentDate < 1443398400) { //28.09.2015
                return qsTr("Введите ключ из набора раннего доступа - это позволит начать игру за несколько дней до запуска. <a style='color: %1' href='http://go.gamenet.ru/a/233/335/'>\"Получить ключ\"</a>.").arg(color);
            }

            if (currentDate < 1444003200) { //28.09.2015 -> 05.10.2015
                return qsTr("Введите ключ из набора раннего доступа - это позволит начать игру за несколько дней до запуска, 12 октября. <a style='color: %1' href='http://go.gamenet.ru/a/233/335/'>\"Получить ключ\"</a>.").arg(color);
            }

            return qsTr("Внимание! Вход в игру ограничен до 12 октября. Чтобы начать игру сейчас, введите ключ из набора раннего доступа. <a style='color: %1' href='http://go.gamenet.ru/a/233/335/'>\"Получить ключ\"</a>.").arg(color);
        })();
        onLinkActivated: App.openExternalUrl(link)
    }

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
