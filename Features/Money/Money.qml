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
import Tulip 1.0
import QtWebKit 1.1
import "../../Elements" as Elements
import "../../Proxy/App.js" as App
import "../../js/UserInfo.js" as UserInfo
import "../../js/restapi.js" as RestApi
import "Money.js" as Money

Rectangle {
    id: root

    default property alias content: rootRect.data

    property alias webViewItem: webViewItem
    property alias rootRect: rootRect

    property int lastIndex: 0

    signal positionPressed(int x, int y);
    signal positionChanged(int x, int y);
    signal close();
    signal updateBalance(int balance);

    function addPage(html) {
        var page = webViewItem.createObject(rootRect, {html: html});
    }

    width: 1000
    height: 600

    border { color: '#1a466a'; width: 1 }
    radius: 3
    color: '#00000000'

    onClose: {
        Object.keys(Money.pages).forEach(function(i){
            d.removeTab(i);
        });
    }

    Connections {
        target: mainWindow

        onNavigate: {
            if (page == 'gogamenetmoney' && Money.isOverlayEnable) {
                if (root.visible) {
                    root.close();
                }

                RestApi.Billing.isInGameRefillAvailable(function(response) {
                    if (!!response.enabled) {
                        root.show();
                    }
                });
            }
        }
    }

    QtObject {
        id: d

        function removeTab(index) {
            Money.pages[index].destroy();
            delete Money.pages[index];
            rootRect.pageCount--;
        }
    }

    Item {
        anchors { fill: parent; leftMargin: 1; topMargin: 1 }

        MouseArea {
            anchors.fill: parent

            acceptedButtons: Qt.LeftButton

            onPressed: root.positionPressed(mouse.x, mouse.y);
            onPositionChanged: root.positionChanged(mouse.x, mouse.y);
        }

        Rectangle {
            height: 40
            width: parent.width
            color: '#082135'

            Row {
                id: tabRow

                x: 10
                y: 10
            }

            Item {
                anchors {
                    right: parent.right
                    top: parent.top
                    topMargin: 20
                    rightMargin: 20
                }

                Image {
                    anchors.centerIn: parent
                    source: browserCloseMa.containsMouse ? installPath + 'images/Features/Money/closeapp_hover.png' :
                                                           installPath + 'images/Features/Money/closeapp.png'

                    MouseArea {
                        id: browserCloseMa

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.close();
                    }
                }
            }
        }

        Rectangle {
            id: urlRect

            anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 40 }
            height: 45
            color: '#fafafa'
            visible: rootRect.pageCount > 0

            Image {
                anchors {
                    left: parent.left
                    top: parent.top
                    leftMargin: 10
                    topMargin: 14
                }

                source: refreshMa.containsMouse ? installPath + '/images/Features/Money/refresh.png' :
                                                  installPath + '/images/Features/Money/refresh_hover.png'

                MouseArea {
                    id: refreshMa

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: rootRect.children[rootRect.currentItem].refresh();
                }
            }

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 38
                    rightMargin: 10
                    top: parent.top;
                    topMargin: 6

                }
                color: '#fafafa'
                border { color: '#ededed'; width: 2 }
                height: 31

                Text {
                    anchors { fill: parent; leftMargin: 27; topMargin: 7 }
                    text: rootRect.children[rootRect.currentItem] ? rootRect.children[rootRect.currentItem].url : ""
                    color: '#8d9092'
                    width: parent.width
                    elide: Text.ElideRight

                    font { family: "Arial"; pixelSize: 16 }
                }

                Image {

                    function isHttps(item) {
                        if (item) {
                            var url = item.url || '';
                            return url.toString().indexOf('https') == 0;
                        }

                        return false;
                    }

                    anchors { left: parent.left; top: parent.top; margins: 7 }
                    source: isHttps(rootRect.children[rootRect.currentItem]) ? installPath + 'images/Features/Money/https.png' : ''
                }
            }

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                height: 1
                color: '#ededed'
            }
        }

        Item {
            id: rootRect

            property int currentItem: -1
            property int pageCount: 0

            onPageCountChanged: {
                if (pageCount < 1) {
                    root.close();
                }
            }

            anchors { fill: parent; topMargin: 85 }

            onCurrentItemChanged: {
                for (var i = 0; i < rootRect.children.length; ++i) {
                    rootRect.children[i].visible = (i == currentItem);
                }
            }

            onChildrenChanged: {
                currentItem = rootRect.children.length - 1;
                pageCount++;
                var child = rootRect.children[currentItem],
                        tabInstance = tabItem.createObject(tabRow, {tabIndex: lastIndex++});

                child.tabInstance = tabInstance;
                Money.pages[currentItem] = tabInstance;

                Money.updatePagesWidth(rootRect.width);
            }
        }

        Component {
            id: tabItem

            TabItem {
                width: 250
                height: 30
                z: rootRect.currentItem == tabIndex ? 1 : 0

                currentItem: rootRect.currentItem
                rootWidth: rootRect.width
                pageCount: rootRect.pageCount

                onIndexChanged: rootRect.currentItem = index;
                onRemoveTab: d.removeTab(index);
            }
        }

        Component {
            id: webViewItem

            WebViewItem {
                width: root.width - 2
                height: root.height - rootRect.anchors.topMargin - 2

                newWindowParent: rootRect

                onPaymentResponse: {
                    UserInfo.refreshBalance();
                    root.updateBalance(amount);
                    root.close();
                }

            }
        }
    }
}
