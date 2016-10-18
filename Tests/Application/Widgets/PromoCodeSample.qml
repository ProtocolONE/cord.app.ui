/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Dev 1.0
import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0

import Application.Core.Styles 1.0
import Application.Core.Popup 1.0
import Application.Core.Authorization 1.0

import "./PromoCodeSample.js" as Js
Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    // Initialization

    function initRestApi(defaultApiUrl) {
        RestApi.Core.setup({
                               lang: 'ru',
                               url: defaultApiUrl,
                               genericErrorCallback: function(code, message) {
                                   if (code == RestApi.Error.AUTHORIZATION_FAILED
                                       || code == RestApi.Error.ACCOUNT_NOT_EXISTS
                                       || code == RestApi.Error.AUTHORIZATION_LIMIT_EXCEED
                                       || code == RestApi.Error.UNKNOWN_ACCOUNT_STATUS) {
                                       console.log('RestApi generic error', code, message);
                                   }
                               }
                           });
    }

    function setPromoResult(object) {
        Js.result = object;
    }

    Component.onCompleted: {
        Styles.init();
        //Styles.setCurrentStyle('sand');
        Styles.setCurrentStyle('main');
        //Styles.setCurrentStyle('green');

        Popup.init(popupLayer);

//        initRestApi('http://api.sabirov.dev');
//        Authorization._gnLoginUrl = 'http://gnlogin.sabirov.dev';
//        Authorization._gnLoginTitleApiUrl = 'gnlogin.sabirov.dev';


        RestApi.Service.getPromoKeysSettings = function(service, callback) {
            Js.hackCallback = function() {
                callback(Js.result);
            }

            hack.restart();
        }
    }

    Timer {
        id: hack

        interval: 300
        repeat: false
        triggeredOnStart: false

        onTriggered: Js.hackCallback()
    }

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("84"));
            RestApi.Core.setUserId("400001000092302250");
            RestApi.Core.setAppKey("86c558d41c1ae4eafc88b529e12650b884d674f5");
            WidgetManager.registerWidget('Application.Widgets.PromoCode');
            WidgetManager.init();
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Grid  {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Button {
                text: "Выключен"

                onClicked: {
                        setPromoResult({
                                           "gameId": 84,
                                           "title": "",
                                           "description": "",
                                           "link": "",
                                           "isTurnedOff": true
                                         });
                        Popup.show("PromoCode");
                    }
            }

            Button {
                text: "Без ключа"

                onClicked: {
                        setPromoResult({
                                           "gameId": 84,
                                           "title": "",
                                           "description": "",
                                           "link": "",
                                           "isTurnedOff": false
                                         });
                        Popup.show("PromoCode");
                    }
            }

            Button {
                text: "Есть ссылка на ключ"

                onClicked: {
                        setPromoResult({
                                           "gameId": 84,
                                           "title": "",
                                           "description": "",
                                           "link": "https://gamenet.ru/feed/",
                                           "isTurnedOff": false
                                         });
                        Popup.show("PromoCode");
                    }
            }

            Button {
                text: "Выключен1"

                onClicked: {
                        setPromoResult({
                                           "gameId": 84,
                                           "title": "11111",
                                           "description": "22222222222",
                                           "link": "",
                                           "isTurnedOff": true
                                         });
                        Popup.show("PromoCode");
                    }
            }

            Button {
                text: "Без ключа1"

                onClicked: {
                        setPromoResult({
                                           "gameId": 84,
                                           "title": "11111",
                                           "description": "22222222222",
                                           "link": "",
                                           "isTurnedOff": false
                                         });
                        Popup.show("PromoCode");
                    }
            }

            Button {
                text: "Есть ссылка на ключ1"

                onClicked: {
                    var q = 'http://api.voronko.dev/?format=xml&appKey=ca86a616a41587787d394b744ce88720c7d51235&userId=400001000131506260&method=user.saveMainInfo&nickname=qweqwetest\n';
                     RestApi.http.request(q, function(data) {
                         console.log('Q!!!', JSON.stringify(data));
                     });


                    setPromoResult({
                                           "gameId": 84,
                                           "title": "На текущий момент игра недоступна.",
                                           "description": "по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает по кнопке да появляется поле вводя промо ключапо нет закрывает ",
                                           "link": "https://gamenet.ru/feed/",
                                           "isTurnedOff": false
                                         });
                        Popup.show("PromoCode");


                }


            }
        }



    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}
