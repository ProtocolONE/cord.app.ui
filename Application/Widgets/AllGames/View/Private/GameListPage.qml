import QtQuick 1.1

import Application.Controls 1.0

import "../../../../Core/App.js" as App
import "../../../../Core/Styles.js" as Styles

Item {
    id: root

    signal clicked(variant serviceItem)

    function update() {
        var services = App.getRegisteredServices(),
            sortModel = {};

        Object.keys(services).forEach(function(e){
            var item = App.serviceItemByServiceId(services[e]);
            if (!item.genre) {
                return;
            }
            if (!sortModel.hasOwnProperty(item.genre)) {
                sortModel[item.genre] = [];
            }

            sortModel[item.genre].push({
              serviceId: item.serviceId,
              sortPositionInApp: item.sortPositionInApp,
              genrePosition: item.genrePosition});
        });

        Object.keys(sortModel).sort(function(_a, _b) {
            var lista = sortModel[_a],
                listb = sortModel[_b];

            return lista[0].genrePosition - listb[0].genrePosition;

        }).forEach(function(e) {
            var actualGrid = gridComponent.createObject(baseColumn, {genre: e}),
                    genreGames = sortModel[e];

            genreGames.sort(function(a, b) {
                return a.sortPositionInApp - b.sortPositionInApp;
            });

            genreGames.forEach(function(item) {
                itemComponent.createObject(actualGrid.content, {serviceId: item.serviceId});
            });
        });
    }

    Item {
        anchors { fill: parent; margins: 16; bottomMargin: 50 }
        clip: true

        Flickable {
            id: flickable

            anchors { fill: parent; margins: 2 }
            contentWidth: width
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: baseColumn

                width: parent.width

                onHeightChanged: flickable.contentHeight = height;

                spacing: 26
            }
        }
    }

    ScrollBar {
        flickable: flickable
        anchors {
            right: parent.right
            rightMargin: 2
        }
        height: parent.height - 50
        scrollbarWidth: 5
        allwaysShown: true
    }

    Component {
        id: gridComponent

        Column {
            default property alias content: baseGrid

            property string genre

            spacing: 14
            width: parent.width

            Item {
                width: parent.width
                height: genreText.height

                Text {
                    id: genreText

                    text: genre
                    font.pixelSize: 16
                    color: Styles.style.messengerGridGenreText
                }

                Rectangle {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    width: parent.width - genreText.width - 20

                    height: 1
                    color: '#26383f'
                }
            }

            Grid {
                id: baseGrid

                width: parent.width
                columns: 7
                spacing: 20
            }
        }
    }

    Component {
        id: itemComponent

        GameItemSmall {
            onClicked: root.clicked(serviceItem);
        }
    }
}
