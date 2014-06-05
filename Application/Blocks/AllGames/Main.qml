import QtQuick 1.1
import GameNet.Controls 1.0 as Controls
import Application.Controls 1.0

import "../../Core/App.js" as App
import "./AllGames.js" as AllGamesJs

Item {
    id: root

    width: 1000
    height: 900

//    ListView {
//        id: listView

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
        var lineWidth = 0,
            lastObj;

        for (var i = 0; i < App.gamesListModel.count; ++i) {
            model.push(App.gamesListModel.get(i));
        }

//            if (i % 2 == 0) {
//                if (lastObj) {
//                    console.log(lastObj.cWidth);
//                }

//                lastObj = undefined;
//            }

            //if (lastObj.aliasContentWidth )

            if (!lastObj) {
                lastObj = listViewComponent.createObject(rowView);
            }

//            for (var j = 0; j < lastObj.model.count; ++j) {
//                var lineItem = lastObj.model.get(j);

            var itemInstance = itemComponent.createObject(lastRow, {
                                                           source: installPath + item.imageDefault,
                                                           serviceItem: item,
                                                           pauseAnimation: (countItems++) * 100,
                                                           imageWidth: size
                                                          });


//    GridView {
//        width: 750
//        height: 750

//        //cellHeight: 200
//        //cellWidth: 200

//        anchors.centerIn: parent
//        //spacing: 9

//        model: Core.gamesListModel

//        delegate: GameItem {
//            width: index % 2 == 0 ? 180 : 495
//        }
//    }
}
