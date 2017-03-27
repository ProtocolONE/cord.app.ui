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

        property string sslCertificate: "-----BEGIN CERTIFICATE-----
MIIFQjCCBCqgAwIBAgIJAIOUs3hTeTfDMA0GCSqGSIb3DQEBCwUAMIG0MQswCQYD
VQQGEwJVUzEQMA4GA1UECBMHQXJpem9uYTETMBEGA1UEBxMKU2NvdHRzZGFsZTEa
MBgGA1UEChMRR29EYWRkeS5jb20sIEluYy4xLTArBgNVBAsTJGh0dHA6Ly9jZXJ0
cy5nb2RhZGR5LmNvbS9yZXBvc2l0b3J5LzEzMDEGA1UEAxMqR28gRGFkZHkgU2Vj
dXJlIENlcnRpZmljYXRlIEF1dGhvcml0eSAtIEcyMB4XDTE3MDEyOTEzNTcwMFoX
DTE4MDMzMDA3MzkzOFowQDEhMB8GA1UECxMYRG9tYWluIENvbnRyb2wgVmFsaWRh
dGVkMRswGQYDVQQDExJjb25uZWN0LmdhbWVuZXQucnUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDBiYNTQO46PW5k9S9H9GVbMtGoLaW+vvx/doAjtHJI
hGLvgxe16VMhWoUoigZYd6HcXFYQQ6sswrgiW+7UKAvOXhZhipoH+CtC5O7x7sE2
ta3OltmYpJwdhboSqII443D2WQXwsKzYrmPNLESqtKk9lWCPhTKtPeme/Bv/773g
2PqhvjCEiyOoTYAwohXUU69t3Ilj9c3fX+XEiIZe2zuJu3xWx64h6uzdvCEdrbb3
/jJdAqYuy7QdlsSUHAkSDHMez3ZqcMnNCeECR685ZywJMe2BRgIYZWWKJkTuOD3t
5FuK+cExQ8UtlLYUYp6zjz42oepwIFtI4lQCZJy6HXOVAgMBAAGjggHIMIIBxDAM
BgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAOBgNV
HQ8BAf8EBAMCBaAwNwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NybC5nb2RhZGR5
LmNvbS9nZGlnMnMxLTM5Ny5jcmwwXQYDVR0gBFYwVDBIBgtghkgBhv1tAQcXATA5
MDcGCCsGAQUFBwIBFitodHRwOi8vY2VydGlmaWNhdGVzLmdvZGFkZHkuY29tL3Jl
cG9zaXRvcnkvMAgGBmeBDAECATB2BggrBgEFBQcBAQRqMGgwJAYIKwYBBQUHMAGG
GGh0dHA6Ly9vY3NwLmdvZGFkZHkuY29tLzBABggrBgEFBQcwAoY0aHR0cDovL2Nl
cnRpZmljYXRlcy5nb2RhZGR5LmNvbS9yZXBvc2l0b3J5L2dkaWcyLmNydDAfBgNV
HSMEGDAWgBRAwr0njsw0gzCiM9f7bLPwtCyAzjA1BgNVHREELjAsghJjb25uZWN0
LmdhbWVuZXQucnWCFnd3dy5jb25uZWN0LmdhbWVuZXQucnUwHQYDVR0OBBYEFOSC
F3MwLht/0CiOsKky0r/sw5SJMA0GCSqGSIb3DQEBCwUAA4IBAQCNqNNVQ7zPcarn
/8LOJNTHpzEIiYDYHflFSOH8Hf7k/V8UFsNK37ogSx1WYKCs7tV94H6MP+H4sWB1
v3AoBI1qHaElUlXbjUON5rADdcjQBtzQoeEV/NP7Ii/ui68ttrA8fsuWvgCxqPni
jDNjKP9JZDVYPqcNy1q3z6M5H/ffH3VYSTjipzjekVXW6cm/O+hI8rL8GzrwvqMF
ykTOa8ZUCm4rpViAftJFDFhob2x4vq2+yrTCE2bjHREtXUJjiOmrDB1GWCYUhGgR
te5V6r9KIlJuSUaoy4/1+ZJIXc7WdmQ7RMONY4INuKjg9A9Se7aSObnA20rAgcdN
G2ox3KaX
-----END CERTIFICATE-----
"

        property string sslKey: "-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDBiYNTQO46PW5k
9S9H9GVbMtGoLaW+vvx/doAjtHJIhGLvgxe16VMhWoUoigZYd6HcXFYQQ6sswrgi
W+7UKAvOXhZhipoH+CtC5O7x7sE2ta3OltmYpJwdhboSqII443D2WQXwsKzYrmPN
LESqtKk9lWCPhTKtPeme/Bv/773g2PqhvjCEiyOoTYAwohXUU69t3Ilj9c3fX+XE
iIZe2zuJu3xWx64h6uzdvCEdrbb3/jJdAqYuy7QdlsSUHAkSDHMez3ZqcMnNCeEC
R685ZywJMe2BRgIYZWWKJkTuOD3t5FuK+cExQ8UtlLYUYp6zjz42oepwIFtI4lQC
ZJy6HXOVAgMBAAECggEASjhfOZVEBue6J1Nz32dVW2UgzBs9XepGUOdz+r1funmy
q2GdvTCOpdLeEA7mohS26RgsFS6uPYsrLFoPPCNja6/fa2bI7Vd517yN+g/y3vVL
g1eMeSJfkF7RXghrcD+g+YhoY8aNcsdmFK/uYXzJDonzrvaI2bFNn5/VaRBaxBgm
sAoZ8ZHx8aLa1lBQ2QvuNHSHBmwvX788CskT/hom+TnaD5b3DppxaNPJ8LPblwFI
lRLblNLHbqkSeUXFJqUbmhfN0z7zZB3+1JbTtl+Ca5DJl7M3in3cqTcRh7JVSkGi
wt+/RkQtBAY7wZlEfoWhs58aAA5LgTtR83KKiGyZoQKBgQDxsQzowVYEgAfrJvJV
q0OKxNaBWJVPBLn20f1d7cAQeO7pemE9wdcnhs+5FcvERvhltQYSX34u8lCvTA15
H0m3XWIF/dXL0jY1ZROKsiphqim7DEgRFDdsIWoK707dYoJBTNu/oQE9kS4USHXB
2SZw7lC1fs3jichAiFMhziznfQKBgQDM/qjOT20wejqY2HoxJd3x6R2Lqn9e7Bm3
uEJXhNBvJMuvQSXS4v2I/GE4OUktoMRzk+AXV6gW/qzWEzNB6RoVnN3R7riljlqs
dBuACRqzYY5VGqqHA/thON1dE/zKmnLjd+Vph6stBsdrejRI4DbJiq4GFhmgDntO
15RGwBFn+QKBgAh7ajSQ9G/b/msmRsLy67/nAJAxh6vqQoyC+h1dxqvNUrUm8lq0
ftSISqn4NdqBkx4eqEPkzgzfvC0qwh5KFtA0msgTDHnGuthM386ySgJ7clN6Lt1K
lFdbJNmVZHMojeG0zNGA2QZMHg3gLSHMeSjldDeqZ5dgsoJxRlmdXr4RAoGASBIM
RSR1jgKbEVuich8PDdrYcV8LEtNNI2Nbp6thIII+PipYYvE9E+kvQPYa/Ti1eLD3
qx09UoBNQaJUdgq/CfQxpHoaXtJSnKjhdj09Lu3Qfak3ZOqIeaDlarD5Qj3UwJZJ
iLWS/+yPNgEr2qdBe9AO6MLiVXxh69EtJ0all/kCgYEAi0Hakj8zY3Nv9hOsjxD9
1ssoe1n99sxFxv7oPwn0x7bBpsdgoyd8f6fWElIGnfH6bOg++lrLIwnHvOGicoPu
4jkKwSQvBKikJH68+JUlwgaFVMImW+WPx2KbE6tmctnJ1spiPc3piekj69BnH5Lw
jfHFNaWGV390aeecxcy7HTU=
-----END PRIVATE KEY-----"

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
            RestApi.Billing.purchaseItem(d.gameId, d.itemId, -1, d.directBuyResponse, d.directBuyResponse);
        }

        function directBuyResponse(response) {
            if (!response || !!response.error || !response.result) {
                webSocketServer.buy();
                return;
            }

            d.buyCompleted();
        }

        function cancelBuy() {
            if (!d.buyInProgress) {
                return;
            }

            webSocketServer.listen = false;
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

    SslWebSocketServer {
        id: webSocketServer

        listen: true
        ssl: SslWebSocketServer.SecureMode
        sslCertificate: d.sslCertificate
        sslKey: d.sslKey

        property string crc

        function buy() {
            connectTimeout.start();
            webSocketServer.crc = Qt.md5(d.itemId + d.serviceId + User.userId() + User.appKey() + d.webSocketSalt);
            var url = 'https://www.gamenet.ru/money/buyitem/?itemId=%1&serviceId=%2&port=%3'
                .arg(d.itemId)
                .arg(d.serviceId)
                .arg(webSocketServer.port)

            App.openExternalUrl(User.getUrlWithCookieAuth(url));
        }

        function webSocketStatusChanged(status) {
            try {
                if (status == WebSocket.Closed || status == WebSocket.Error) {
                    d.cancelBuy();
                    return;
                }
            } catch(e) {
            }
        }

        function webSocketTextMessageReceived(message) {
            try {
                var response = JSON.parse(message);
                if (response.token !== webSocketServer.crc) {
                    d.cancelBuy();
                    return;
                }

                if (response.action === "canceled") {
                    d.cancelBuy();
                }

                if (response.action === "completed") {
                    d.buyCompleted();
                }
            } catch(e) {
            }
        }

        onClientConnected: {
            connectTimeout.stop();
            webSocketServer.listen = false;
            webSocket.statusChanged.connect(webSocketStatusChanged);
            webSocket.textMessageReceived.connect(webSocketTextMessageReceived);
        }
    }

    Timer {
        id: connectTimeout

        interval: 30000
        repeat: false
        onTriggered: d.cancelBuy()
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
