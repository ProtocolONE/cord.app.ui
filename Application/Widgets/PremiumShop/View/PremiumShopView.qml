import QtQuick 2.4

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.Config 1.0

PopupBase {
    id: root

    implicitWidth: 630
    title: qsTr("PREMIUM_ACCOUNT_HEADER_TEXT_BLOCK")

    QtObject {
        id: d

        property variant currentItem: getCurrentItem()

        property int currentCoin: d.currentItem ? d.currentItem.cost : 0
        property int currentOptionId: d.currentItem ? d.currentItem.id : 0

        function getCurrentItem() {
            if (!root.model || !root.model.premiumModel) {
                return 0;
            }

            var currentIndex = listView.currentIndex;
            var premiumModel = root.model.premiumModel;
            if (currentIndex < 0 || currentIndex >= premiumModel.count) {
                return 0;
            }

            return premiumModel.get(currentIndex);
        }

        function buyInProgress() {
            if (!root.model) {
                return false;
            }

            return root.model.inProgress;
        }

        function modelValid() {
            if (!root.model) {
                return false;
            }

            if (!root.model.premiumModel) {
                return false;
            }

            return root.model.premiumModel.count > 0;
        }
    }

    Connections {
        target: root.model

        onModelChanged: {
            listView.currentIndex = root.model.defaultIndex;
        }

        onPurchaseCompleted: {
            root.close();
        }
    }

    //  INFO: опрос вызывается каждый раз вьявную при создании вьюхи, модель сделана
    //  синглтонной для того, чтобы не было ошибок контекста при колбэке из RestApi
    Component.onCompleted: {
        root.model.refreshModel();
    }

    Text {
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
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr("Расширенный аккаунт ProtocolOne - возможность играть двумя аккаунтами одновременно в игры %1. Мы постоянно добавляем в расширенный аккаунт новые приятные бонусы. <a href=\"bonus\">Подробности здесь.</a>").arg(root.model ? root.model.supportedGames: '')
        linkColor: Styles.linkText
        onLinkActivated: App.openExternalUrlWithAuth(Config.site("/extra/"));

        MouseArea {
            anchors.fill: parent
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
    }

    Text {
        id: leftDays

        function getPremiumDays() {
            return Math.floor(User.getPremiumDuration() / 86400);
        }

        function getText() {
            if (!User.isPremium()) {
                return "";
            }

            var days = leftDays.getPremiumDays();
            return days > 2000
                    ? qsTr("Осталось более 2000 дней")
                    : qsTr("TITLE_PREMIUM_ACCOUNT_LEFT_TIME_LABEL").arg(days);
        }

        anchors {
            left: parent.left
            right: parent.right
        }
        font { family: "Arial"; pixelSize: 14 }
        text: leftDays.getText()
        visible: !!text.length
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color: defaultTextColor
        smooth: true
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: 10

        Item {
            width: parent.width
            height: d.modelValid() ? purchaseItems.height : 100

            AnimatedImage {
                anchors.centerIn: parent
                source: installPath + "/Assets/Images/Application/Widgets/PremiumShop/wait_animation.gif"
                visible: !d.modelValid()
            }

            Column {
                id: purchaseItems

                width: parent.width
                visible: d.modelValid()
                spacing: 10

                Text {
                    width: parent.width
                    font { family: "Arial"; pixelSize: 18}
                    text: qsTr("TITLE_PREMIUM_ACCOUNT_CONTINUE_ACCOUNT_LABEL")
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

                        width: 250
                        height: model ? (30 * model.count + (model.count === 0 ? 1 : 0)) : 0
                        interactive: false
                        currentIndex: 0
                        spacing: 15

                        onCurrentIndexChanged: notEnoughMoneyBlock.visible = false;
                        model: root.model.premiumModel

                        delegate: RadioButton {
                            width: listView.width
                            checked: listView.currentIndex == index
                            text: name
                            onClicked: listView.currentIndex = index;
                        }
                    }

                    Rectangle {
                        id: notEnoughMoneyBlock

                        //INFO Это совсем касмный блок. Все его цвета должны быть забиты без стилей.
                        width: 305
                        height: listView.height

                        color: '#ffcc01'
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
                            text: qsTr("NOT_ENOUGH_MONEY")
                            color: '#38362a'
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

                        Button {
                            width: 180
                            height: 36
                            anchors {
                                left: parent.left
                                bottom: parent.bottom
                                margins: 20
                            }

                            style: ButtonStyleColors {
                                normal: "#3598dc"
                                hover: "#4b90c0"
                                disabled: "#FF4F02"

                            }

                            text: qsTr('ADD_MONEY_BUTTON_TEXT')
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
            text: qsTr('MONEY_TOTAL %1').arg(d.currentCoin);
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
            property bool hasEnoughtMoney: User.getBalance() > d.currentCoin
            anchors {
                right: parent.right
                bottom: parent.bottom
            }

            visible: d.modelValid();

            text: qsTr('ACCEPT_BUY')
            inProgress: d.buyInProgress()
            analytics {
                category: 'PremiumShop'
                action: 'submit'
                label: hasEnoughtMoney ? 'Purchase' : 'Not enough GN'
                value: hasEnoughtMoney ? d.currentCoin: 0
            }
            onClicked: {
                if (User.getBalance() < d.currentCoin) {
                    notEnoughMoneyBlock.visible = true;
                } else {
                    root.model.buy(d.currentOptionId);
                }
            }
        }
    }
}
