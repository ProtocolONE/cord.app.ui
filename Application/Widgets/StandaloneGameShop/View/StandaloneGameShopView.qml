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
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

import QtWebSockets 1.0

import Tulip 1.0

PopupBase {
    id: root

    implicitWidth: 870
    implicitHeight: 460
    Component.onCompleted: d.init(root.model.serviceId);

    QtObject {
        id: d

        property string serviceId
        property string licenseUrl

        property bool buyInProgress: false

        property string resultMessage: ""
        property bool isMessagePage: !!d.resultMessage

        property int gameId
        property string itemId
        property string backgroud
        property string itemImage
        property string cost
        property string description
        property string textAfterBuy

        property string webSocketSalt: "g;c.TUsn/V=>:Q-d;Ay{"

        function init(serviceId) {
            var service = App.serviceItemByServiceId(serviceId);
            if (!service || !service.isStandalone) {
                return;
            }

            d.serviceId = serviceId;
            d.licenseUrl = service.licenseUrl;

            var sellItem = Lodash._.find(App.sellItemByServiceId(serviceId), 'isActive');

            d.backgroud = sellItem.backgroud || "";
            d.itemImage = sellItem.imageLarge || "";
            d.cost = sellItem.cost;
            d.description = sellItem.description;
            d.itemId = sellItem.id;
            d.textAfterBuy = sellItem.textAfterBuy

            d.gameId = service.gameId;

            root.title = qsTr("Покупка %1").arg(sellItem.name)
        }

        function buy() {
            d.buyInProgress = true;
            RestApi.Billing.purchaseItem(d.gameId, d.itemId, 1, d.directBuyResponse, d.directBuyResponse);
        }

        function directBuyResponse(response) {
            if (!response || !!response.error || !response.result) {
                var url = Config.GnUrl.site('/money/buyitem/?itemId=%1&serviceId=%2&port=1337'
                    .arg(d.itemId)
                    .arg(d.serviceId));

                App.openExternalUrlWithAuth(url);
                root.close();
                return;
            }

            d.buyCompleted();
        }

        function cancelBuy() {
            if (!d.buyInProgress) {
                return;
            }

            d.buyInProgress = false;
            d.resultMessage = qsTr("Что-то пошло не так");
        }

        function buyCompleted() {
            if (!d.buyInProgress) {
                return;
            }

            User.refreshUserInfo();
            d.buyInProgress = false;
            d.resultMessage = d.textAfterBuy
        }
    }

    Item {
        width: 770
        height: 358

        Image {
            source: d.backgroud
        }

        Image {
            x: 40
            y: 10

            width: 268
            height: 335
            fillMode: Image.PreserveAspectFit
            source: d.itemImage
        }

        Item {
            x: 340
            width: 430
            height: parent.height

            Item {
                anchors.fill: parent
                visible: !d.isMessagePage

                Column {
                    anchors {
                        fill: parent
                        margins: 10
                    }

                    spacing: 10

                    Text {
                        font.pixelSize: 14
                        color: defaultTextColor
                        smooth: true
                        text: qsTr("С Вашего счета будет списано:")
                    }

                    Text {
                        font {
                            pixelSize: 26
                            bold: true
                        }

                        color: defaultTextColor
                        smooth: true
                        text: qsTr("%1 GN-монет").arg(d.cost)
                    }

                    Text {
                        width: parent.width
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        font.pixelSize: 14
                        color: defaultTextColor
                        smooth: true
                        text: d.description
                    }
                }

                PrimaryButton {
                    inProgress: d.buyInProgress

                    Text {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.top
                            bottomMargin: 20
                        }

                        font {
                            pixelSize: 14
                            bold: true
                        }

                        color: defaultTextColor
                        smooth: true
                        text: qsTr("У меня: %1 GN-монет").arg(User.getBalance())
                    }

                    text: qsTr("Оплатить %1 GN-монет").arg(d.cost)

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                    }

                    onClicked: d.buy();
                }
            }

            Item {
                visible: d.isMessagePage
                anchors {
                    fill: parent
                    margins: 10
                }

                Text {
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: 14
                    color: defaultTextColor
                    smooth: true
                    text: d.resultMessage
                }
            }
        }

        TextButton {
            anchors.bottom: parent.bottom
            text: qsTr("Лицензионное соглашение")
            onClicked: App.openExternalUrl(d.licenseUrl)
        }
    }
}
