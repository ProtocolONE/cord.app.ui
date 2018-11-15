import QtQuick 2.4

import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0

import "Private" as Private

WidgetView {
    id: root

    implicitWidth: 770
    implicitHeight: 600//570

    Component.onCompleted: d.fillGrid();

    QtObject {
        id: d

        function fillGrid() {
            var grid = App.serviceGrid(),
                suggestedUserGames,
                otherSuggestedGames,

                gridServices = {};

            Object.keys(grid).forEach(function(e){
                var item = grid[e];

                if (!App.serviceItemByServiceId(item.serviceId)) {
                    console.log('game not found', item.serviceId);
                    return;
                }
                itemComponent.createObject(baseArea,
                                           {
                                               source: item.image,
                                               serviceItem: App.serviceItemByServiceId(item.serviceId),
                                               serviceItemGrid: item,
                                               serviceId: item.serviceId,
                                               x: (item.col - 1) * 257,
                                               y: (item.row - 1) * 100,
                                               width: (item.width * 255) + (item.width - 1) * 2,
                                               height: (item.height * 98) + (item.height - 1) * 2
                                           });
                gridServices[item.serviceId] = 1;
            });
        }
    }

    ContentBackground {
    }

    Component {
        id: itemComponent

        Private.GameItem { }
    }

    Column {
        id: gridPage

        anchors {
            fill: parent
            leftMargin: 1
        }
        spacing: 1

        Item {
            id: baseArea

            width: parent.width
            height: 600
            visible: height > 0
            clip: height < 400 ? true : false

            Rectangle {
                anchors.fill: parent
                opacity: 0.75
                color: Styles.contentBackgroundDark
            }

            Behavior on height {
                PropertyAnimation {
                    easing.type: Easing.InQuad
                    duration: 200
                }
            }
        }
    }
}
