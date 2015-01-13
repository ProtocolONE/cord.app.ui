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
import "../../../Core/Styles.js" as Styles

import "Private" as Private

WidgetView {
    id: root

    implicitWidth: 770
    implicitHeight: 560

    Rectangle {
        anchors.fill: parent
        color: Styles.style.messangerGridBackground
    }

    Component.onCompleted: d.fillGrid();

    QtObject {
        id: d

        function fillGrid() {
            var grid = App.servicesGrid,
                    services,
                    index = 0,
                    gameListServices,
                    gridServices = {};

            Object.keys(grid).forEach(function(e){
                var item = grid[e];

                if (!App.serviceItemByServiceId(item.serviceId)) {
                    return;
                }

                var itemProperties = {
                    source: item.image,
                    serviceItem: App.serviceItemByServiceId(item.serviceId),
                    serviceItemGrid: item,
                    serviceId: item.serviceId,
                    x: (item.col - 1) * 257,
                    y: (item.row - 1) * 101
                };

                var comp = itemComponent.createObject(baseArea, itemProperties);
                gridServices[item.serviceId] = 1;
            });

            services = App.servicesList.filter(function(e){
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

            gameListServices = services;

            while (gameListServices.length < 7) {
                gameListServices.push(App.serviceItemByServiceId(grid[index++].serviceId));
            }

            gameList.model = services;

            gameListPage.services = App.servicesList.filter(function(e){
                if (App.isPrivateTestVersion()) {
                    return true;
                }

                return e.isPublishedInApp == true;
            });
        }
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
            height: 398
            visible: height > 0
            clip: height < 398 ? true : false

            Behavior on height {
                PropertyAnimation {
                    easing.type: Easing.InQuad
                    duration: 200
                }
            }
        }

        Private.AllButton {
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

        Private.GameList {
            id: gameList

            width: parent.width

            Behavior on opacity {
                PropertyAnimation {
                    duration: 100
                }
            }
        }

        Private.GameListPage {
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
                PropertyChanges { target: gameList; opacity: 1 }
            },
            State {
                name: "AllGames"
                PropertyChanges { target: baseArea; height: 0 }
                PropertyChanges { target: allGamesButon; iconRotation: 190 }
                PropertyChanges { target: gameListPage; visible: true }
                PropertyChanges { target: gameList; opacity: 0 }
            }
        ]
    }
}
