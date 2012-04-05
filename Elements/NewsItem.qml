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
import "." as Elements
import "../js/GoogleAnalytics.js" as GoogleAnalytics

Item {

    property string newsTextDate
    property string newsTextBody
    property string newsUrl
    property int newsCommentCount
    property int newsLikeCount

    clip: true

    Elements.CursorMouseArea {
        id: mouser

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (qGNA_main.currentGameItem) {
                GoogleAnalytics.trackEvent('/newsBlock/' + qGNA_main.currentGameItem.gaName, 'Navigation', 'Open News');
            }

            mainAuthModule.openWebPage(newsUrl);
        }
    }

    Text {
        text: newsTextDate
        anchors.fill: parent
        anchors { bottomMargin: 15; rightMargin: 5; leftMargin: 5; topMargin: 2 }
        color: "#ffffff"
        wrapMode: Text.WordWrap
        font.pixelSize: 10
        opacity: 0.7
    }

    Text {
        id: textBodyId
        text: newsTextBody
        anchors { right: parent.right; left: parent.left; top: parent.top }
        anchors { rightMargin: 5; leftMargin: 5; topMargin: 15 }
        color: "#ffffff"
        wrapMode: Text.WordWrap
        font { family: "Tahoma"; pixelSize: 13; }
        smooth: true
   }

//    Item {
//        id: commentsRectangle

//        y: 15 + textBodyId.height + 3
//        height: textCommentCount.height + 3
//        width: textCommentCount.width + 5

//        anchors { left: parent.left; leftMargin: 5 }

//        Rectangle {
//            anchors { fill: parent; bottomMargin: 2 }
//            opacity: 0.5
//            color: "#ffffff"
//        }

//        Rectangle {
//            width: 1
//            height: 1
//            anchors { left: parent.left; leftMargin: 5; bottom: parent.bottom; bottomMargin: 0 }
//            opacity: 0.5
//            color: "#ffffff"
//        }

//        Rectangle {
//            width: 3
//            height: 1
//            anchors { left: parent.left; leftMargin: 4; bottom: parent.bottom; bottomMargin: 1 }
//            opacity: 0.5
//            color: "#ffffff"
//        }
//    }

//    Item {
//        id: likeRectangle

//        y: 15 + textBodyId.height + 3
//        height: textLikeCount.height + 1
//        width: textLikeCount.width + 6

//        anchors.left: parent.left
//        anchors.leftMargin: commentsRectangle.width + 11 + plusOneText.width

//        Rectangle {
//            anchors { fill: parent; leftMargin: 2 }
//            opacity: 0.5
//            color: "#ffffff"
//        }

//        Rectangle {
//            width: 1
//            height: 1
//            anchors { left: parent.left; bottom: parent.bottom; }
//            anchors { bottomMargin: likeRectangle.height / 2 }
//            opacity: 0.5
//            color: "#ffffff"
//        }

//        Rectangle {
//            width: 1
//            height: 3
//            anchors { left: parent.left; bottom: parent.bottom;}
//            anchors { leftMargin: 1; bottomMargin: likeRectangle.height / 2 - 1 }
//            opacity: 0.5
//            color: "#ffffff"
//        }
//    }

//    Text {
//        id: textCommentCount

//        y: 15 + textBodyId.height + 4
//        anchors { left: parent.left; leftMargin: 7 }
//        text: newsCommentCount
//        font { pixelSize: 10; family: "Arial" }
//        color: "#0157ae"
//        smooth: true
//    }

//    Text {
//        id: textLikeCount

//        y: 15 + textBodyId.height + 4
//        anchors.left: parent.left
//        anchors.leftMargin: commentsRectangle.width + 10 + plusOneText.width + 5

//        text: newsLikeCount
//        font { pixelSize: 10; family: "Arial" }
//        color: "#0157ae"
//        smooth: true
//    }

//    Text {
//        id: plusOneText

//        anchors.left: parent.left
//        anchors.leftMargin: 3 + commentsRectangle.width + 5
//        y: 15 + textBodyId.height + 3

//        text: "+1"
//        font { pixelSize: 10; family: "Arial" }
//        color: "#c1d4ff"
//        opacity: 0.75
//        smooth: true
//    }
}
