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
import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../../Core/App.js" as App

WidgetView {
    id: root

    implicitWidth: 770
    implicitHeight: 560

    Rectangle {
        anchors.fill: parent
        color: '#000c13'
    }

    Component.onCompleted: {
        var data = App.servicesUI,
                grid = data.grid,
                services,
                gridServices = {};

        Object.keys(grid).forEach(function(e){
            var item = grid[e];

            var itemProperties = {
                source: App.host() + item.image,
                serviceItem: App.serviceItemByServiceId(item.serviceId),
                serviceItemGrid: item,
                serviceId: item.serviceId,
                x: (item.col - 1) * 256,
                y: (item.row - 1) * 100
            };

            var comp = itemComponent.createObject(baseArea, itemProperties);
            gridServices[item.serviceId] = 1;
        });

        services = data.services.filter(function(e){
            if (gridServices.hasOwnProperty(e.serviceId)) {
                return false;
            }

            if (App.isPrivateTestVersion()) {
                return true;
            }

            return e.isPublishedInApp == true;
        }).sort(function(a,b) {
            var isAinstalled = App.isServiceInstalled(a.serviceId),
                isBinstalled = App.isServiceInstalled(b.serviceId);

            if (isAinstalled == isBinstalled) {
                return (a.sortPositionInApp < b.sortPositionInApp) ? -1 :
                       (a.sortPositionInApp > b.sortPositionInApp) ? 1 : 0;
            }

            return (isAinstalled < isBinstalled) ? -1 : 1;


        }).slice(0, 7);

        gameList.model = services;
        gameListPage.services = data.services.filter(function(e){
            if (App.isPrivateTestVersion()) {
                return true;
            }

            return e.isPublishedInApp == true;
        });

    }

    Component {
        id: itemComponent

        GameItem { }
    }

    Column {
        id: gridPage

        anchors {
            fill: parent
            leftMargin: 1
            topMargin: 1
        }
        spacing: 3

        Item {
            id: baseArea

            width: parent.width
            height: 398
            visible: height > 0
            clip: true

            Behavior on height {
                PropertyAnimation {
                    easing.type: Easing.InQuad
                    duration: 250
                }
            }
        }

        AllButton {
            id: allGamesButon

            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: 8
            }
            onClicked: stateGroup.state === 'Normal' ? stateGroup.state = 'AllGames' : stateGroup.state = 'Normal'

            Behavior on iconRotation {
                NumberAnimation { duration: 250 }
            }

        }

        GameList {
            id: gameList

            width: parent.width
        }

        GameListPage {
            id: gameListPage

            width: parent.width
            height: 560
        }
    }



    StateGroup {
        id: stateGroup

        state: "Normal"
        states: [
            State {
                name: "Normal"
                PropertyChanges { target: baseArea; height: 398 }
                PropertyChanges { target: allGamesButon; iconRotation: 0 }
                PropertyChanges { target: gameListPage; visible: false }
                PropertyChanges { target: gameList; visible: true }
            },
            State {
                name: "AllGames"
                PropertyChanges { target: baseArea; height: 0 }
                PropertyChanges { target: allGamesButon; iconRotation: 190 }
                PropertyChanges { target: gameListPage; visible: true }
                PropertyChanges { target: gameList; visible: false }
            }
        ]
    }
}
