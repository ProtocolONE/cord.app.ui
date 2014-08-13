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
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as AppJs
import "../../../Core/User.js" as UserJs
import "../../../Core/restapi.js" as RestApiJs
import "./Money.js" as MoneyJs

WidgetView {
    id: root

    default property alias content: rootRect.data

    property alias webViewItem: webViewItem
    property alias rootRect: rootRect
    property int lastIndex: 0

    property int saveX
    property int saveY

    signal positionPressed(int x, int y);
    signal positionChanged(int x, int y);

    function addPage(html) {
        var page = webViewItem.createObject(rootRect, {html: html});
    }

    function show() {
        root.addPage(d.urlEncondingHack(d.getMoneyUrl()));
        root.visible = true;
    }

    function closeWidget() {
        root.visible = false;

        Object.keys(MoneyJs.pages).forEach(function(i){
            MoneyJs.pages[i].destroy();
        });

        MoneyJs.pages = {};
        rootRect.pageCount = 0;
    }

    Connections {
        target: model
        onOpenMoneyOverlay: {
            if (root.visible) {
                root.closeWidget();
            }

            root.show();
        }
    }

    width: 1000
    height: 600

    visible: false

    Rectangle {
        width: root.width
        height: root.height

        border { color: '#1a466a'; width: 1 }
        radius: 3
        color: '#00000000'

        QtObject {
            id: d

            function removeTab(index) {
                MoneyJs.pages[index].destroy();
                delete MoneyJs.pages[index];
                rootRect.pageCount--;
            }

            function getMoneyUrl() {
                return UserJs.getUrlWithCookieAuth("http://www.gamenet.ru/money");
            }

            function urlEncondingHack(url) {
                return "<html><head><script type='text/javascript'>window.location='" + url + "';</script></head><body></body></html>";
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
                        source: browserCloseMa.containsMouse ? installPath + 'Assets/Images/Application/Widgets/Money/closeapp_hover.png' :
                                                               installPath + 'Assets/Images/Application/Widgets/Money/closeapp.png'

                        MouseArea {
                            id: browserCloseMa

                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.closeWidget();
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

                    source: refreshMa.containsMouse ? installPath + 'Assets/Images/Application/Widgets/Money/refresh.png' :
                                                      installPath + 'Assets/Images/Application/Widgets/Money/refresh_hover.png'

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
                        source: isHttps(rootRect.children[rootRect.currentItem]) ? installPath + 'Assets/Images/Application/Widgets/Money/https.png' : ''
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

                width: parent.width
                height: parent.height

                onPageCountChanged: {
                    if (pageCount < 1) {
                        root.closeWidget();
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
                    MoneyJs.pages[currentItem] = tabInstance;

                    MoneyJs.updatePagesWidth(rootRect.width);
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
                        UserJs.refreshBalance();
                        root.closeWidget();
                    }
                }
            }
        }
    }
}
