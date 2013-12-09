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
import "./Private" as Private
import "../../../Elements" as Elements
import "../../../Models" as Models
import "../../../js/UserInfo.js" as UserInfo
import "../../../js/Core.js" as Core

Rectangle {
    id: container;

    property variant collapsedSize: Qt.size(225, 200)
    property variant expandedSize: Qt.size(755, 200)
    property int visibleItemsCount

    signal buyItemClicked(variant itemOptions)

    onBuyItemClicked: {
        if (UserInfo.isAuthorized()) {
            Core.showPurchaseOptions(itemOptions);
        } else {
            Core.needAuth();
        }
    }

    function expand(){
        container.state = "ListExpanded";

        //  correcting currentFirstIndex
        itemsListView.currentFirstItem = itemsListView.adjustIndex(itemsListView.currentFirstItem);
        itemsListView.updateScrollButtons();
    }

    function collapse(){
        container.state ="ListCollapsed";

        //  correcting currentFirstIndex
        itemsListView.currentFirstItem = itemsListView.adjustIndex(itemsListView.currentFirstItem);
        itemsListView.updateScrollButtons();
    }

    color: "#44382A"
    state: "ListCollapsed"

    QtObject {
        id: d

        property int tempContentX
        property bool moving: itemsListView.contentX !== tempContentX
        property bool adjusting: false
    }

    Behavior on width {
        NumberAnimation {
            duration: 500
        }
    }

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
    }

    Column {
        anchors.fill: parent
        spacing: 5

        Item {
            width: 200
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: headerLabel

                anchors.centerIn: parent
                horizontalAlignment : Text.AlignHCenter
                verticalAlignment : Text.AlignVCenter
                text: qsTr("CA_SHOP_ITEMS_TITLE")
                style: Text.Normal
                smooth: true
                color: "#FFFFFF"
                font { family: "Arial"; pixelSize: 14 }
            }
        }

        Item {
            id: listViewCont

            width: container.width
            height: 135

            Private.ScrollButton {
                id: scrollLeftButton

                orientation: 'W'
                anchors {
                    left: parent.left
                    leftMargin: 5
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: -10
                }
                width: 20
                height: 75
                onClicked: itemsListView.moveUp()
            }

            ListView {
                id: itemsListView

                property int itemWidth: 150
                property int currentFirstItem: 0

                function moveUp() {
                    if (itemsListView.currentFirstItem >= 1) {
                        scrollToItem(itemsListView.currentFirstItem - 1);
                    }
                }

                function moveDown() {
                    if ((itemsListView.currentFirstItem + container.visibleItemsCount) < itemsListView.count) {
                        scrollToItem(itemsListView.currentFirstItem + 1);
                    }
                }

                function scrollToItem(itemIndex) {
                    var newX = 0;

                    var invisibleWidth = 0;
                    var visibleWidth = container.visibleItemsCount*itemsListView.itemWidth + (container.visibleItemsCount - 1)*(itemsListView.spacing);;
                    var margin = (itemsListView.width - visibleWidth)/2;

                    itemsListView.currentFirstItem = adjustIndex(itemIndex);
                    d.adjusting = true;

                    if (itemsListView.currentFirstItem == 0) {
                        newX = -margin;
                    } else {
                        invisibleWidth = itemsListView.currentFirstItem*(itemsListView.itemWidth + itemsListView.spacing);
                        newX = invisibleWidth - margin;
                    }
                    updateScrollButtons();

                    d.tempContentX = newX;
                }

                function adjustIndex(index) {
                    var actualIndex = index;

                    if (index < 0) {
                        actualIndex = 0;
                    } else if (index > (itemsListView.count - container.visibleItemsCount)) {
                        actualIndex = itemsListView.count - container.visibleItemsCount;
                    }

                    return actualIndex;
                }

                function updateScrollButtons() {
                    scrollLeftButton.enabled = true;
                    scrollRightButton.enabled = true;
                    if (itemsListView.currentFirstItem == 0) {
                        scrollLeftButton.enabled = false;
                    }
                    if (itemsListView.currentFirstItem == (itemsListView.count - container.visibleItemsCount)) {
                        scrollRightButton.enabled = false;
                    }
                }

                height: parent.height
                orientation: ListView.Horizontal
                interactive: false
                boundsBehavior: Flickable.StopAtBounds
                spacing: 27
                clip: true

                Component.onCompleted: updateScrollButtons();

                anchors {
                    left: parent.left
                    leftMargin: 35
                    right: parent.right
                    rightMargin: 35
                }

                model: Models.CombatArmsItemsModel{}

                delegate: ItemDelegate {
                    width: itemsListView.itemWidth
                    height: 125
                    onBuyClicked: container.buyItemClicked(modelItem);
                }

                Elements.WheelArea {
                    property date lastTime

                    anchors.fill: parent

                    onVerticalWheel: {
                        var currentTime = new Date();
                        if (currentTime - lastTime < 250) {
                            return;
                        }

                        lastTime = new Date();
                        if (delta > 0) {
                            itemsListView.moveUp();
                        }
                        if (delta < 0) {
                            itemsListView.moveDown();
                        }
                    }
                }

                Timer {
                    interval: 33 //30 fps
                    running: d.adjusting && d.moving
                    repeat: true
                    onTriggered: {
                        var dist = d.tempContentX - itemsListView.contentX,
                                step = dist / 4;

                        if (Math.abs(step) <= 1) {
                            itemsListView.contentX = d.tempContentX;
                        } else {
                            itemsListView.contentX += dist > 0 ? Math.max(1, step) : Math.min(-1 , step)
                        }

                        if (itemsListView.contentX == d.tempContentX) {
                            d.adjusting = false;
                        }
                    }
                }
            }

            Private.ScrollButton {
                id: scrollRightButton

                orientation: 'E'
                width: 20
                height: 75
                anchors {
                    right: listViewCont.right
                    rightMargin: 5
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: -10
                }
                onClicked: itemsListView.moveDown()
            }
        }


        ExpandCollapseButton {
            id: expandCollapseButton

            anchors.horizontalCenter: parent.horizontalCenter
            onExpanded: container.expand()
            onCollapsed: container.collapse()
        }
    }

    states: [
        State {
            name: "ListCollapsed"
            PropertyChanges {
                target: container
                width: container.collapsedSize.width
                height: container.collapsedSize.height
                visibleItemsCount: 1
            }
        },
        State {
            name: "ListExpanded"
            PropertyChanges {
                target: container
                width: container.expandedSize.width
                height: container.expandedSize.height
                visibleItemsCount: 4
            }
        }
    ]
}

