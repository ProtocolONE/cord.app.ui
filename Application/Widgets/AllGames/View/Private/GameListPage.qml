import QtQuick 2.4

import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property bool opened: false

    signal clicked(variant serviceItem)

    function update() {
        var services = App.getRegisteredServices(),
            sortModel = {};

        Object.keys(services).forEach(function(e){
            var item = App.serviceItemByServiceId(services[e]);
            if (!item.genre || item.serviceId == "0") {
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

    onOpenedChanged: {
        if (!opened) {
            content.visible = false;
        } else {
            deleayShow.restart()
        }
    }

    Timer {
        id: deleayShow

        repeat: false
        interval: 100
        running: false
        onTriggered: content.visible = root.opened;
    }

    Item {
        id: content

        visible: false
        anchors { fill: parent; margins: 16; topMargin: 0; bottomMargin: 50 }
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
                spacing: 16
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

            spacing: 10
            width: parent.width

            Item {
                width: parent.width
                height: genreText.height

                Text {
                    id: genreText

                    text: genre
                    font.pixelSize: 16
                    color: Styles.textBase
                }

                ContentStroke {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    width: parent.width - genreText.width - 20
                    opacity: 0.2
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
