import QtQuick 1.1
import "../../../js/Core.js" as Core

Item {
    id: root

    width: 1000
    height: 900

//    ListView {
//        id: listView

//        width: 750
//        height: 750

//        //cellWidth: 190
//        //cellHeight: 190

//        orientation: ListView.Horizontal
//        spacing: 9

//        model: ListModel {}
//        delegate: ListView {
//            width: 750
//            height: 180

//            model: ListModel {}
//            orientation: ListView.Vertical

//            delegate: GameItem {

//            }
//        }
//    }

    Column {
        id: rowView

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

        for (var i = 0; i < Core.gamesListModel.count; ++i) {
            var item = Core.gamesListModel.get(i);

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

//                //console.log('lineItem', lastObj.contentWidth);
//            }

            lastObj.model.append(item);





            //if (lineWidth < rowView.width - item.width) {


/*
            if (i % 2 == 0) {
                var obj = listViewComponent.createObject(rowView);
                obj.model.append(item);

                root.lastObj = obj;
            } else {
                root.lastObj.model.append(item);
            }
            */
        }
    }



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
