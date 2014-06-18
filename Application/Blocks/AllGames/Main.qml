import QtQuick 1.1
import GameNet.Controls 1.0 as Controls
import Application.Controls 1.0

import "../../Core/App.js" as App
import "AllGames.js" as AllGamesJs

Item {
    id: root
    onVisibleChanged: {
        if (visible) {
            AllGamesJs.items.forEach(function(e){
                e.show();
            });
            return;
        }

        AllGamesJs.items.forEach(function(e){
            e.hide();
        });
    }

//        width: 750
//        height: 750

    Item {
        anchors { fill: parent }
        clip: true

//        orientation: ListView.Horizontal
//        spacing: 9

            anchors { fill: parent; margins: 10 }
            contentWidth: width
            boundsBehavior: Flickable.StopAtBounds

//            model: ListModel {}
//            orientation: ListView.Vertical

//            delegate: GameItem {

//            }
//        }
//    }

    ScrollBar {
        flickable: flickable
        anchors {
            right: parent.right
            rightMargin: 2
        }
        height: parent.height
        scrollbarWidth: 5
    }

    Component {
        id: rowComponent

        anchors.centerIn: parent

        width: 750
        height: 750

        spacing: 9
    }

    Component {
        id: listViewComponent

        ListView {
            id: listView

            property int aliasContentWidth: contentWidth

            width: 750
            height: 180

            orientation: ListView.Horizontal
            spacing: 9

            onContentWidthChanged: {
                console.log('onContentWidthChanged', contentWidth)
            }

            model: ListModel {}
            delegate: GameItem {
                width: index % 2 == 0 ? 180 : 495

            }
        }
    }

    Component.onCompleted: {
        var countItems = 0,
            lineWidth = 0,
            currentRowIndex = 0,
            lastObj,
            lastRow = rowComponent.createObject(rowView),
            model = [],
            i = 0;

        for (i = 0; i < App.gamesListModel.count; ++i) {
            model.push(App.gamesListModel.get(i));
        }

        AllGamesJs.items = [];

        model.filter(function(item) {
            return item.enabled;
        }).sort(function(a, b){
            if (a.priority == b.priority) {
                return 0;
            }

            return a.priority < b.priority ? -1 : 1;
        }).forEach(function(item){
            var size = (item.formFactor == 2) ? 245 : 495
                , animationPause
                , itemProperties;

            if ((lineWidth + size) > rowView.width) {
                lastRow = rowComponent.createObject(rowView);
                lineWidth = 0;
                currentRowIndex++;
            }

//            for (var j = 0; j < lastObj.model.count; ++j) {
//                var lineItem = lastObj.model.get(j);

            animationPause = currentRowIndex * 75 + 100 * countItems++;
            itemProperties = {
                source: installPath + item.imageDefault,
                serviceItem: item,
                pauseAnimation: animationPause
            };

            AllGamesJs.items.push(itemComponent.createObject(lastRow, itemProperties));
        });
    }
}
