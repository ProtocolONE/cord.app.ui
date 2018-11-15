import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Core 1.0

import Application.Controls 1.0
import Application.Blocks 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property alias model: view.model
    property alias currentIndex: view.currentIndex

    property variant currentGame: App.currentGame()

    signal urlClicked(string url);
    signal pageClicked(string page);

    implicitWidth: 770
    implicitHeight: 61

    onPageClicked: {
        for (var i = 0; i < view.count; ++i) {
            var item = view.model.get(i);
            console.log(item.page, page,  item.selectable)
            if (item.page == page && item.selectable == true) {
                view.currentIndex = i;
                break;
            }
        }
    }

    ContentBackground {
        anchors.fill: parent
    }

    Item {
        id: menuContainer

        property int tmpCount: view.count
        property int expectedTotalMenuWidth: App.isSingleGameMode() ? 795 : 565
        property real menuItemWidth: (expectedTotalMenuWidth - (1 * menuContainer.tmpCount - 1)) / menuContainer.tmpCount

        anchors.fill: parent

        Row {
            spacing: 0

            ListView {
                id: view

                height: 61
                width: view.count == 0  //INFO Решением для бага с разъезжающимся list view
                       ? 10
                       : Math.round(view.count * menuContainer.menuItemWidth) + view.count - 1

                interactive: false
                orientation: ListView.Horizontal
                spacing: 1

                delegate: GameMenuItem {
                    y: 1
                    width: menuContainer.menuItemWidth
                    current: ListView.isCurrentItem
                    icon: installPath + Styles[model.icon]
                    linkIcon: !!Styles[model.linkIcon] ? installPath + Styles[model.linkIcon] : ''
                    text: model.text

                    onClicked: {
                        var action;

                        if (model.link) {
                            root.urlClicked(model.url)
                            Ga.trackEvent('GameMenu', 'outer link', model.url);
                        } else {
                            root.pageClicked(model.page);
                            Ga.trackEvent('GameMenu', 'switch page', model.page);
                        }
                    }
                }

                ContentStroke {
                    id: stroke
                    width: parent.width
                }
            }
        }

        GameInstallBlock {
            anchors {top: parent.top; right: parent.right}
            width: 205
            height: 60

            ContentStroke {
                width: parent.width
            }
        }
    }
}
