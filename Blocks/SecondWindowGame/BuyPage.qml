/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import "../../Elements" as Elements
import ".." as Blocks
import "../../js/restapi.js" as RestApi
import "../../js/Core.js" as Core
import "../../js/UserInfo.js" as UserInfo
import "../../Proxy/App.js" as App

Blocks.MoveUpPage {
    id: page

    openHeight: 462

    property int daysLeft: 35

    onFinishOpening: {
        page.state = "PurchaseOptionSelection";
        optionsModel.clear();

        RestApi.Premium.getGrid(function(response) {
            var i;

            for (i = 0; i < response.length; i++) {
                addOption(response[i].gridId, response[i].days, response[i].price, (i == 0));
            }
        }, function(response) {});
    }

    onFinishClosing: {
        //   необходимо, чтобы на экране не проскакивал ненужный стейт
        page.state = "PurchaseOptionSelection";
    }

    function tryPurchaseItem() {
        var currentOption = optionsList.currentOption.optionId;

        d.currentDays = optionsList.currentOption.daysCount;
        d.purchaseInProgress = true;

        //  здесь проверка нужна на случай, если пользователь разлогинился во время выбора опций
        if (UserInfo.isAuthorized()) {
            d.purchaseInProgress = true;
            RestApi.Premium.purchase(currentOption,
                                     purchaseComplete,
                                     function(response) {
                                         page.state = 'PurchaseFailed';
                                         errorMessageText.text = qsTr("PREMIUM_SHOP_DETAILS_ERROR_UNKNOWN");
                                         d.purchaseInProgress = false;
                                     });
        } else {
            Core.needAuth();
        }
    }

    function purchaseComplete(response) {
        if (response && response.error) {
            errorMessageText.text = response.error.message;

            page.state = 'PurchaseFailed';
            d.purchaseInProgress = false;
        } else {
            page.state = 'PurchaseSuccessfull';
            d.purchaseInProgress = false;
        }

        UserInfo.refreshBalance();
        UserInfo.refreshPremium();
    }

    function addOption(optId, daysCount, optionPrice, isDefault) {
        optionsModel.append({optionId: optId, label: makeDays(daysCount), price: optionPrice, defaultItem: isDefault, days: daysCount});
    }

    function makeDays(daysCount) {
        var resultStr;
        var map = {
            0: qsTr('PREMIUM_SHOP_DAYS_OTHER'),
            1: qsTr('PREMIUM_SHOP_DAYS_1'),
            2: qsTr('PREMIUM_SHOP_DAYS_2_4'),
            3: qsTr('PREMIUM_SHOP_DAYS_2_4'),
            4: qsTr('PREMIUM_SHOP_DAYS_2_4'),
        };

        resultStr = map[daysCount] || map[0];
        return resultStr.arg(daysCount);
    }

    state: "PurchaseOptionSelection"

    QtObject {
        id: d

        property bool purchaseInProgress: false
        property int currentDays
    }

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
    }

    ListModel {
        id: optionsModel
    }

    Rectangle {
        color: "#084d84"
        anchors.fill: parent

        Rectangle {
            anchors { left: parent.left; top: parent.top; right: parent.right; topMargin: 1 }
            height: 46
            color: '#063a62'

            Text {
                width: 230
                height: parent.height
                font { family: "Arial"; pixelSize: 22 }
                text: qsTr("TITLE_PREMIUM_ACCOUNT_BUY")
                anchors { left: parent.left; leftMargin: 146; top: parent.top; topMargin: height / 4 }
                color: "#e8ecef"
                smooth: true
            }

        }

        Rectangle {
            id: titleIconArea

            anchors { left: parent.left; top: parent.top; topMargin: 80; leftMargin: 146 }
            width: 150
            height: 100
            color: '#14568a'

            border { color: '#2d6795' }

            PremiumAccountLabel {
                anchors { centerIn: parent }
            }
        }

        Column {
            anchors { left: titleIconArea.right; top: titleIconArea.top; leftMargin: 20 }
            width: 510
            height: page.height - 200
            spacing: 30

            Column {
                id: purchaseOptionsBlock

                visible: false
                width: parent.width
                spacing: 10

                Text {
                    width: parent.width
                    font { family: "Arial"; pixelSize: 14 }
                    text: qsTr("TITLE_PREMIUM_ACCOUNT_INFO_TEXT")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#e8ecef"
                    smooth: true
                    onLinkActivated: App.openExternalUrlWithAuth(link);
                }

                Text {
                    id: leftDays

                    function getPremiumDays() {
                        return Math.floor(UserInfo.premiumDuration() / 86400);
                    }

                    function getText() {
                        if (!UserInfo.isPremium()) {
                            return "";
                        }

                        var days = leftDays.getPremiumDays();
                        return qsTr("TITLE_PREMIUM_ACCOUNT_LEFT_TIME_LABEL").arg(days);
                    }

                    width: parent.width
                    font { family: "Arial"; pixelSize: 16 }
                    text: leftDays.getText()
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#e8ecef"
                    smooth: true
                }

                Text {
                    width: parent.width
                    font { family: "Arial"; pixelSize: 14 }
                    text: qsTr("TITLE_PREMIUM_ACCOUNT_CONTINUE_ACCOUNT_LABEL")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#e8ecef"
                    smooth: true
                }

                Item {
                    width: 250
                    height: 130

                    Elements.OptionGroup {
                        id: optionsList
                    }

                    ListView {
                        clip: true
                        interactive: false
                        anchors.fill: parent
                        spacing: 10
                        model: optionsModel

                        delegate: PurchaseOption {
                            property int optionId: model.optionId

                            style: Elements.OptionStyle {
                                property color normalColor: "#00000000"
                                property color hoverColor: "#43382A"
                                property color selectedColor: "#FDC809"
                            }

                            checked: defaultItem == true
                            daysCount: model.days;
                            group: optionsList
                            width: 250
                            height: 25
                        }
                    }
                }

                Rectangle {
                    id: errorMessageContainer

                    visible: false
                    width: 450
                    height: 45

                    Text {
                        id: errorMessageText

                        width: 380
                        anchors.centerIn: parent
                        font { family: "Arial"; pixelSize: 14 }
                        text: ""
                        wrapMode: Text.WordWrap
                        onLinkActivated: App.openExternalUrlWithAuth(link);
                        color: "#333333"
                        lineHeight: 1.1
                    }
                }

                Row {
                    spacing: 5

                    Elements.Button {
                        text: qsTr("ACCEPT_BUY_BUTTON_TEXT")
                        onClicked: page.tryPurchaseItem();
                    }

                    Elements.Button {
                        text: qsTr("CANCEL_BUY_BUTTON_TEXT")
                        onClicked: page.closeMoveUpPage();
                    }
                }
            }

            Item {
                id: purchaseSuccesfullBlock

                visible: false

                Column {
                    spacing: 10

                    Text {
                        id: successMessage

                        width: 450
                        wrapMode: Text.WordWrap
                        text: qsTr("PREMIUM_SHOP_DETAILS_PURCHASE_SUCCESS").arg(page.makeDays(d.currentDays))
                        color: "#FFFFFF"
                        font { family: "Arial"; pixelSize: 18 }
                    }

                    Elements.Button2 {
                        id: close

                        buttonText: qsTr("PREMIUM_SHOP_DETAILS_CLOSE")
                        onClicked: page.closeMoveUpPage();
                    }
                }
            }
        }
    }


    Elements.WorkInProgress {
        active: d.purchaseInProgress
        interval: 50
    }

    states: [
        State {
            name: "PurchaseOptionSelection"
            PropertyChanges {
                target: purchaseOptionsBlock
                visible: true
            }
        },
        State {
            name: "PurchaseSuccessfull"
            PropertyChanges {
                target: purchaseSuccesfullBlock
                visible: true
            }
        },
        State {
            name: "PurchaseFailed"
            PropertyChanges {
                target: purchaseOptionsBlock
                visible: true
            }
            PropertyChanges {
                target: errorMessageContainer
                visible: true
            }
        }
    ]
}
