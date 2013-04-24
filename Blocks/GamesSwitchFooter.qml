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

import "../Elements" as Elements
import "../js/Core.js" as Core

Rectangle
{
    id: footer

    property variant currentGameItem

    signal itemClicked(variant item);

    height: 150
    color: "#292937"

    ListView {
        id : listViewId
        currentIndex: -1
        clip: true
        keyNavigationWraps : true
        focus: true
        orientation: ListView.Horizontal
        interactive: true
        anchors { fill: parent; verticalCenter: parent.verticalCenter }
        highlightFollowsCurrentItem: true

        delegate: Rectangle {
            property bool isSelectedItem : footer.currentGameItem != undefined &&
                                           footer.currentGameItem.serviceId == serviceId

            color: isSelectedItem ? "#fcb825" : "#00ffffff"
            width: imageGame.width + 14
            height: imageGame.height + nameGame.height + 17

            Elements.CursorMouseArea {
                anchors.fill: parent;
                hoverEnabled: true
                toolTip: Core.gamesListModel.miniToolTip(gameId)
                onClicked: {
                    var game = Core.serviceItemByIndex(index);
                    footer.currentGameItem = game;
                    footer.itemClicked(game);
                    listViewId.currentIndex = index;
                }
            }

            Column{
                anchors{ fill: parent; topMargin: 5 }
                spacing: 5

                Text{
                    id: nameGame

                    color: isSelectedItem ? "#000000" : "#ffffff"
                    text: name
                    anchors { horizontalCenter: parent.horizontalCenter }
                    font { capitalization: Font.AllUppercase; family : "Arial"; pixelSize : 12 }
                }

                Image {
                    id: imageGame

                    anchors { horizontalCenter: parent.horizontalCenter }
                    source: installPath + imageFooter
                }
            }
        }

        model: Core.gamesListModel
    }
}
