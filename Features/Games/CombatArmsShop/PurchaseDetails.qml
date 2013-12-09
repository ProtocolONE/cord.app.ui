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
import "../../../Elements" as Elements
import "../../../Elements/Tooltip/Tooltip.js" as Tooltip
import "../../../Blocks" as Blocks
import "../../../js/Core.js" as Core
import "../../../js/restapi.js" as RestApi
import "../../../js/UserInfo.js" as UserInfo
import "../../../Proxy/App.js" as App


Blocks.MoveUpPage {
    id: page

    property variant purchaseDetails
    property bool purchaseInProgress: false

    openHeight: 465
    width: parent.width

    onFinishOpening: optionsList.reset();

    function setPurchaseOptions(purchaseOptions) {
        purchaseDetails = purchaseOptions;

        page.state = "PurchaseOptionSelection";
        page.purchaseInProgress = false;
    }

    function tryPurchaseItem() {
        //  здесь проверка нужна на случай, если пользователь разлогинился во время выбора опций
        if (UserInfo.isAuthorized()) {
            //  ID для Combat Arms == 92
            var combatArmsGameId = 92;

            page.purchaseInProgress = true;

            RestApi.Billing.purchaseItem(combatArmsGameId, optionsList.currentOption.optionId, 1, function(response) {
                purchaseComplete(response);
            });
        } else {
            Core.needAuth();
        }
    }

    function purchaseComplete(result) {
        var map = {
            0: ['PurchaseFailed', qsTr("CA_SHOP_DETAILS_ERROR_UNKNOWN")],
            1: ['PurchaseSuccessfull', ""],
            7: ['PurchaseFailed', qsTr("CA_SHOP_DETAILS_ERROR_INSUFFICIENT_GN")],
            111: ['PurchaseFailed', qsTr("CA_SHOP_DETAILS_ERROR_NO_CHAR")]
        };

        var e = map[Math.abs(result)] || map[0];

        page.state = e[0];
        errorMessageText.text = e[1];
        page.purchaseInProgress = false;
    }

    state: "PurchaseOptionSelection"

    Item {
        id: container

        width: parent.width
        height: 465

        Column {

            Rectangle {
                id: pageTitle

                width: container.width
                height: 50
                color: "#322A1F"

                Text {
                    x: 150
                    y: 10
                    text: qsTr("CA_SHOP_DETAILS_TITLE")
                    horizontalAlignment: Text.AlignHCenter
                    color: "#FFFFFF"
                    font { family: "Arial"; pixelSize: 21 }
                }
            }

            Rectangle {
                width: parent.width
                height: container.height - pageTitle.height
                color: "#43382A"

                Rectangle {
                    id: previewContainer

                    color: "#4D4235"
                    border.color: "#5F564A"
                    x: 150
                    y: 30
                    width: 150
                    height: 100

                    Image {
                        anchors.fill: parent
                        source: installPath +  page.purchaseDetails.preview
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Column {
                    id: purchaseOptionsBlock

                    visible: false
                    spacing: 10
                    anchors { top: previewContainer.top; left: previewContainer.right; leftMargin: 10 }

                    Text {
                        width: 450
                        wrapMode: Text.WordWrap
                        text: page.purchaseDetails.title
                        color: "#FFFFFF"
                        font { family: "Arial"; pixelSize: 18 }
                    }

                    Text {
                        width: 450
                        wrapMode: Text.WordWrap
                        text: page.purchaseDetails.description
                        color: "#FFFFFF"
                        font { family: "Arial"; pixelSize: 16 }
                    }

                    Item {
                        width: 250
                        height: 100

                        Elements.OptionGroup {
                            id: optionsList
                        }

                        ListView {
                            clip: true
                            interactive: false
                            anchors.fill: parent
                            spacing: 10
                            model: page.purchaseDetails.options

                            delegate: PurchaseOption {
                                property int optionId: model.optionId

                                checked: defaultItem == true
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

                    Item {
                        id: buttonBox

                        width: 250
                        height: 50

                        Row {
                            spacing: 10

                            Elements.Button2 {
                                id: confirmPurchase

                                hoverColor: "#339900"
                                buttonText: qsTr("CA_SHOP_DETAILS_CONFIRM")
                                onClicked: page.tryPurchaseItem();
                            }

                            Elements.Button2 {
                                id: cancel;
                                buttonText: qsTr("CA_SHOP_DETAILS_CANCEL")

                                onClicked: page.closeMoveUpPage();
                            }
                        }
                    }
                }

                Item {
                    id: purchaseSuccesfullBlock

                    visible: false
                    anchors { top: previewContainer.top; left: previewContainer.right; leftMargin: 20 }

                    Column {
                        spacing: 10

                        Text {
                            id: successMessage

                            width: 450
                            wrapMode: Text.WordWrap
                            text: qsTr("CA_SHOP_DETAILS_PURCHASE_SUCCESS").arg(page.purchaseDetails.title)
                            color: "#FFFFFF"
                            font { family: "Arial"; pixelSize: 18 }
                        }

                        Elements.Button2 {
                            id: close

                            buttonText: qsTr("CA_SHOP_DETAILS_CLOSE")
                            onClicked: page.closeMoveUpPage();
                        }
                    }
                }
            }
        }
    }

    Elements.WorkInProgress {
        active: page.purchaseInProgress
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

