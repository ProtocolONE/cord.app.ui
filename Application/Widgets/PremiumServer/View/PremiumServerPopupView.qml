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
import Application.Core.MessageBox 1.0
import Application.Core.Styles 1.0

PopupBase {
    id: root

    property variant serviceId
    property variant gameId
    property variant remainTime

    property variant currentItem: getCurrentItem()
    property string currentId: currentItem ? currentItem.id : 0
    property int currentCost: currentItem ? currentItem.cost : 0

    property bool inProgress: false

    property bool shopDisabled: false

    implicitWidth: 830
    title: qsTr("Доступ к премиум-серверу")

    function getItems() {
        RestApi.Service.getItems(root.serviceId, 3, function(response) {
            response.sort(function(a, b) {
                return a.cost - b.cost;
            });

            optionsModel.clear();
            response.forEach(function(e){
                optionsModel.append({
                                        id: String(e.id),
                                        name: e.name,
                                        cost: e.cost|0
                                    });
            });

            listView.currentIndex = response.length - 1;
        });
    }

    function modelValid() {
        return optionsModel.count > 0;
    }

    function getCurrentItem() {
        if (listView.currentIndex < 0) {
            return 0;
        }

        return optionsModel.get(listView.currentIndex);
    }

    function stopProgress() {
         root.inProgress = false;
    }

    function buy(itemId) {
        root.inProgress = true;
        console.log('Billing.purchaseItem', itemId);
        RestApi.Billing.purchaseItem(root.gameId, itemId, 1, purchaseComplete, showError);
    }

    function purchaseComplete(response) {
        root.stopProgress();
        if (!response) {
            root.showError();
        }

        if (!response.result) {
            if (response.code === -7) {
                notEnoughMoneyBlock.visible = true;
                return;
            }

            root.showError(response.message, response.code);
            return;
        }

        User.refreshBalance();
        User.refreshUserInfo();

        root.close();
    }

    function showError(message, code) {
        root.stopProgress();

        if (code == -50 ||
            code == -60 ||
            code == -70 ||
            code == -80) {
            var text;
            if (code == -50) {
                text = qsTr("Нельзя приобрести доступ на премиум сервер");
            }

            if (code == -60) {
                text = qsTr("Нельзя продлить доступ на премиум сервер");
            }

            if (code == -70) {
                text = qsTr("Нельзя приобрести доступ на премиум сервер");
            }

            if (code == -80) {
                text = qsTr("Нельзя приобрести больше одного товара в месяц");
            }

            MessageBox.show(qsTr("Невозможно купить"), text, MessageBox.button.ok);
            return;
        }

        MessageBox.show(qsTr("Упс! Что-то пошло не так..."),
                        message || qsTr("Произошла ошибка в процессе покупки. Пожалуйста, попробуйте позже."),
                        MessageBox.button.ok);
    }

    Component.onCompleted: {
        var currentGame = App.currentGame();
        root.serviceId = currentGame.serviceId;
        root.gameId = currentGame.gameId;
        root.remainTime = User.getSubscriptionRemainTime(currentGame.serviceId);

        // INFO GN-13377 27.10.2017 Оставил пока включенным
        if (root.serviceId == "30000000000") {
            function checkLisenceResponseCb(response) {
                if (!!!response || !response.hasOwnProperty("result")) {
                    root.getItems();
                    return;
                }

                if (response.result) {
                    console.log("Premium server shop disabled. P2PTransferRequest accepted");
                    root.shopDisabled = true;
                    return;
                }

                root.getItems();
            }

            RestApi.Core.execute('user.isLicenseAccepted',
                                 {
                                     serviceId : "30000000000",
                                     licenseId: "390" // INFO P2PTransferRequestModel
                                 },
                                 true, checkLisenceResponseCb, checkLisenceResponseCb);
        } else {
           root.getItems();
        }

//        if (root.serviceId == "30000000000") {
//            var canBuy = User.hadSubscriptionsByService("30000000000");
//            if (!canBuy) {
//                console.log("Premium server shop disabled.");
//                root.shopDisabled = true;
//                return;
//            }
//        }

//        root.getItems();
    }

    ListModel {
        id: optionsModel
    }

    Text {
        visible: root.shopDisabled
        anchors {
            left: parent.left
            right: parent.right
        }

        font {
            family: 'Arial'
            pixelSize: 14
        }

        color: defaultTextColor
        smooth: true
        textFormat: Text.StyledText
        linkColor: Styles.linkText
        onLinkActivated: App.openExternalUrl(link)
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        //text: qsTr("Доступ на премиум сервер для новых пользователей временно недоступен.")
        text: qsTr("Доступ на премиум сервер для пользователей совершивших трансфер на бесплатный сервер недоступен.")

        MouseArea {
            anchors.fill: parent
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
    }

    Text {
        visible: !root.shopDisabled
        anchors {
            left: parent.left
            right: parent.right
        }

        font {
            family: 'Arial'
            pixelSize: 14
        }

        color: defaultTextColor
        smooth: true
        textFormat: Text.StyledText
        linkColor: Styles.linkText
        onLinkActivated: App.openExternalUrl(link)
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr("Премиум сервер — место развития и сражений для тех, кто ценит комфорт в игре и атмосферу закрытого сообщества.")

        MouseArea {
            anchors.fill: parent
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
    }

    Text {
        visible: !root.shopDisabled
        anchors {
            left: parent.left
            right: parent.right
        }

        font {
            family: 'Arial'
            pixelSize: 14
        }

        color: defaultTextColor
        smooth: true
        textFormat: Text.StyledText
        linkColor: Styles.linkText
        onLinkActivated: App.openExternalUrl(link)
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr("Обратите внимание: перенос персонажей между серверами не осуществляется. Персонаж доступен только на том сервере, на котором он создан.")

        MouseArea {
            anchors.fill: parent
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
    }

    Text {
        function getText() {
            if (root.remainTime <= 0) {
                return "";
            }

            return qsTr("Осталось: %1 %2")
                .arg(root.remainTime)
                .arg(StringHelper.pluralForm(root.remainTime, [qsTr("день"), qsTr("дня"), qsTr("дней")]));
        }

        anchors {
            left: parent.left
            right: parent.right
        }
        font { family: "Arial"; pixelSize: 14 }
        text: getText()
        visible: !!text.length && !root.shopDisabled
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color: defaultTextColor
        smooth: true
    }

    Column {
        visible: !root.shopDisabled

        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: 10

        Item {
            width: parent.width
            height: modelValid() ? purchaseItems.height : 100

            AnimatedImage {
                anchors.centerIn: parent
                source: installPath + "/Assets/Images/wait_animation.gif"
                visible: !modelValid()
            }

            Column {
                id: purchaseItems

                width: parent.width
                visible: modelValid()
                spacing: 10

                Text {
                    width: parent.width
                    font { family: "Arial"; pixelSize: 18}
                    text: User.getSubscriptionRemainTime(root.serviceId) > 0
                          ? qsTr("Получите доступ к премиум серверу:")
                          : qsTr("Продлите доступ к премиум серверу:")

                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: Styles.lightText
                    smooth: true
                }

                Item {
                    height: listView.height

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    ListView {
                        id: listView

                        width: 430
                        height: Math.max(model ? (30 * model.count + (model.count === 0 ? 1 : 0)) : 0, 90)
                        interactive: false
                        spacing: 15

                        onCurrentIndexChanged: notEnoughMoneyBlock.visible = false;
                        model: optionsModel

                        delegate: RadioButton {
                            width: listView.width
                            checked: listView.currentIndex == index
                            text: name + " – " + cost  + " GN"
                            onClicked: listView.currentIndex = index;
                        }
                    }

                    Rectangle {
                        id: notEnoughMoneyBlock

                        width: 285
                        height: listView.height + 20

                        color: '#ffcc01' //INFO Это кастомный блок.
                        visible: true
                        anchors {
                            top: parent.top
                            right: parent.right
                        }

                        Rectangle {
                            anchors {
                                right: parent.left
                                top: parent.top
                                rightMargin: -width/2
                                topMargin: listView.currentIndex * 30 + 8
                            }

                            width: 12
                            height: width
                            rotation: 45

                            color: parent.color
                        }

                        Text {
                            text: qsTr("На счету недостаточно GN-монет")
                            color: Styles.fieldText
                            font {
                                family: 'Arial'
                                pixelSize: 16
                            }
                            anchors {
                                left: parent.left
                                top: parent.top
                                margins: 20
                            }
                        }

                        AuxiliaryButton {
                             width: 180
                             anchors {
                                 left: parent.left
                                 bottom: parent.bottom
                                 margins: 20
                             }
                             text: qsTr('Пополнить счет')
                             onClicked: App.replenishAccount();
                        }
                    }
                }
            }
        }
    }

    PopupHorizontalSplit {}

    Item {
        width: parent.width
        height: 48

        Text {
            visible: !root.shopDisabled

            text: qsTr('Итоговая стоимость: %1').arg(root.currentCost);
            color: root.defaultTextColor
            font {
                family: "Arial"
                pixelSize: 16
            }
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }

        PrimaryButton {
            property bool hasEnoughtMoney: User.getBalance() > root.currentCost
            anchors {
                right: parent.right
                bottom: parent.bottom
            }

            enabled: !root.shopDisabled
            visible: modelValid();

            text: qsTr('Подтвердите покупку')
            inProgress: root.inProgress
            analytics {
                category: 'PremiumServer'
                action: 'submit'
                label: hasEnoughtMoney ? 'Purchase' : 'Not enough GN'
                value: hasEnoughtMoney ? root.currentCost: 0
            }
            onClicked: {
                if (User.getBalance() < root.currentCost) {
                    notEnoughMoneyBlock.visible = true;
                } else {
                    root.buy(root.currentId);
                }
            }
        }
    }
}
