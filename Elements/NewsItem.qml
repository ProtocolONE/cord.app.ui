/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import "." as Elements
import "../js/GoogleAnalytics.js" as GoogleAnalytics
import "../js/Core.js" as Core

Item {

    property string newsTextDate
    property string newsTextBody
    property string newsUrl
    property int newsCommentCount
    property int newsLikeCount

    Elements.CursorMouseArea {
        id: mouser

        anchors { top: parent.top; left: parent.left; bottom: parent.bottom}
        width: textBodyId.paintedWidth + 10
        hoverEnabled: true
        onClicked: {
            var currentitem = Core.currentGame();
            if (currentitem) {
                GoogleAnalytics.trackEvent('/newsBlock/' + currentitem.gaName, 'Navigation', 'Open News');
            }

            mainAuthModule.openWebPage(newsUrl);
        }
    }

    Text {
        text: newsTextDate

        anchors.fill: parent
        anchors { rightMargin: 5; topMargin: 19 }
        color: "#ffffff"
        wrapMode: Text.WordWrap
        font.pixelSize: 14
        opacity: 0.7
    }

    Text {
        id: textBodyId

        text: newsTextBody
        anchors { right: parent.right; left: parent.left; top: parent.top }
        anchors { rightMargin: 5; topMargin: 36 }
        color: "#ffffff"
        wrapMode: Text.WordWrap
        font { family: "Tahoma"; pixelSize: 16; underline: mouser.containsMouse }
        smooth: true
        elide: Text.ElideRight
   }
}
