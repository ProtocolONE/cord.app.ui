/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "../Models" as Models
import "../Elements" as Elements
import "../Delegates" as Delegates
import "../js/GameListModelHelper.js" as GameListModelHelper
import "../js/GoogleAnalytics.js" as GoogleAnalytics

Item {

//    width: 800
//    height: 400
//    Item {
//        id: mainWindow
//        property string emptyString: ""
//        signal torrentListenPortChanged();
//        signal downloadButtonStartSignal();
//    }

//    Models.GamesListModel {
//        id: gamesListModel
//        Component.onCompleted: GameListModelHelper.initGameItemList(gamesListModel);
//    }

//    property string installPath: "../"

    id: cHome
    focus: true

    signal finishAnimation()
    signal mouseItemClicked(variant item)

    function closeAnimationStart() {
        closeHomeAnimation.start();
    }

    NumberAnimation { id: closeHomeAnimation; easing.type: Easing.OutQuad; target: cHome; property: "opacity"; from: 1; to: 0; duration: 150 }

    Connections {
        target: mainWindow
        onDownloadButtonStartSignal: {
            var item = GameListModelHelper.serviceItemByServiceId(serviceId);
            mouseItemClicked(item);
        }
    }

    Elements.FlowView {
        anchors { fill: parent; leftMargin: 46; topMargin: 109 }
        width: 700
        height: 400
        delegate: Delegates.GameIconDelegate {
            model: model
            onMouseClicked: {
                GoogleAnalytics.trackEvent('/Home', 'Navigation', 'Switch To Game ' + item.gaName, 'Flow Image');
                mouseItemClicked(item)
            }
        }

        model: gamesListModel
    }
}
