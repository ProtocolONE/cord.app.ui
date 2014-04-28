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
import "../../Controls" as Controls
import "../../js/UserInfo.js" as UserInfo

Rectangle {
    id: root

    signal buy(int money)
    signal openDetails()
    signal addMoney();
    signal close();

    width: 630
    height: 375

    color: '#f0f5f8'

    onBuy: {
        if (UserInfo.balance() < money) {
            notEnoughMoneyBlock.visible = true;
        }
    }

    Item {
        id: headBlock

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: 55

        Image {
            source: installPath + '/images/close.png'
            anchors {
                right: parent.right
                top: parent.top
                margins: 10
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.close();
            }
        }

        Controls.HorizontalSplit {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            style: Controls.SplitterStyleColors {
                main: '#ececec'
                shadow: '#ffffff'
            }
        }

        Text {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 20
            }

            font {
                family: 'Arial'
                pixelSize: 18
                bold: true
            }

            color: '#343537'
            smooth: true
            text: qsTr("PREMIUM_ACCOUNT_HEADER_TEXT_BLOCK")
        }
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
            top: headBlock.bottom
        }

        height: 230

        Text {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 20
            }

            font {
                family: 'Arial'
                pixelSize: 14
            }

            color: '#5c6d7d'
            smooth: true
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: qsTr("PREMIUM_ACCOUNT_TEXT_MAIN")
            onLinkActivated: root.openDetails();
        }

        Item {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                topMargin: 92
                leftMargin: 20
                rightMargin: 20
                bottomMargin: 30
            }

            ListView {
                id: listView

                property int currentCoin: model.get(currentIndex).coin

                width: 250
                height: 30 * model.count
                interactive: false
                currentIndex: 0

                onCurrentIndexChanged: notEnoughMoneyBlock.visible = false;

                model: ListModel {
                    ListElement{
                        textLabel: QT_TR_NOOP("ONE_DAY_PREMIUM_TRADIO_TEXT")
                        coin: 30
                    }

                    ListElement {
                        textLabel: QT_TR_NOOP("WEEK_PREMIUM_TRADIO_TEXT")
                        coin: 180
                    }

                    ListElement {
                        textLabel: QT_TR_NOOP("MONTH_PREMIUM_TRADIO_TEXT")
                        coin: 540
                    }

                    ListElement {
                        textLabel: QT_TR_NOOP("3_MONTH_PREMIUM_TRADIO_TEXT")
                        coin: 1080
                    }
                }

                delegate: PayItem {
                    width: listView.width
                    coinValue: coin
                    checkedIndex: listView.currentIndex
                    text: qsTr(textLabel)
                    onClicked: listView.currentIndex = index;
                }
            }

            Rectangle {
                id: notEnoughMoneyBlock

                width: 305
                height: listView.height

                color: '#ffcc01'
                visible: false
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

                Controls.Button {
                    width: 180
                    height: 36
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        margins: 20
                    }

                    style: Controls.ButtonStyleColors {
                        normal: "#3598dc"
                        hover: "#4b90c0"
                        disabled: "#FF4F02"

                    }

                    text: qsTr('ADD_MONEY_BUTTON_TEXT')
                    onClicked: root.addMoney();
                }
            }
        }

        Controls.HorizontalSplit {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            style: Controls.SplitterStyleColors {
                main: '#ececec'
                shadow: '#ffffff'
            }
        }

        Text {
            text: qsTr('MONEY_TOTAL %1').arg(listView.currentCoin);
            color: '#4a4b4d'
            font {
                family: "Arial"
                pixelSize: 16
            }
            anchors {
                top: parent.bottom
                left: parent.left
                leftMargin: 20
                topMargin: 35
            }
        }

    }

    Controls.Button {
        width: 200
        height: 46
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }

        text: qsTr('ACCEPT_BUY')
        onClicked: root.buy(listView.currentCoin);
    }
}
