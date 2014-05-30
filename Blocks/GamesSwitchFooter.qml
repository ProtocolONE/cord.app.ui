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
import "../Blocks/GamesSwitchFooter" as FooterBlocks
import "../Elements/Tooltip/Tooltip.js" as Tooltip

Rectangle {
    id: footer

    property bool buttonVisible: d.additionalArea || footerArea.containsMouse
    property variant currentGameItem

    signal itemClicked(variant item);

    width: 114
    color: "#292937"

    QtObject {
        id: d

        property bool additionalArea: false
    }

    Elements.CursorMouseArea {
        id: footerArea

        anchors.fill: parent;
        hoverEnabled: true
    }

    Image {
        anchors.fill: parent;
        fillMode: Image.Tile
        source: installPath + "Assets/Images/backClone.png"
    }

    ListView {
        id: listViewId

        Elements.WheelArea {
            property date lastTime

            anchors.fill: parent

            onVerticalWheel: {
                var currentTime = new Date();
                if (currentTime - lastTime < 250) {
                    return;
                }

                lastTime = new Date();
                if (delta > 0) {
                    listViewId.moveUp();
                }
                if (delta < 0) {
                    listViewId.moveDown();
                }
            }
        }

        function moveUp() {
            listViewId.moveInternal(-123 * 4 - listViewId.contentY % 123);
        }

        function moveDown() {
            listViewId.moveInternal(123 * 4);
        }

        function moveInternal(step) {
            internal._tempContentY = step > 0
                    ? Math.min(listViewId.contentHeight - listViewId.height, internal._tempContentY + step)
                    : Math.max(0, internal._tempContentY + step);
            if (internal._moving) {
                Tooltip.releaseAll();
            }
        }

        currentIndex: (!!footer.currentGameItem) ? Core.indexByServiceId(footer.currentGameItem.serviceId) : -1
        clip: true
        focus: visible
        interactive: false
        anchors { fill: parent; verticalCenter: parent.verticalCenter }

        delegate: Item {
            property bool isSelectedItem : footer.currentGameItem != undefined &&
                                           footer.currentGameItem.serviceId == serviceId

            width: 114
            height: 107

            Item {
                anchors { fill: parent; leftMargin: 7 }
                visible: parent.isSelectedItem

                Image {
                    anchors.fill: parent;
                    fillMode: Image.Tile
                    source: installPath + "Assets/Images/backHoverClone.png"
                }
            }

            Item {
                anchors { fill: parent; margins: 7 }

                Elements.CursorMouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        var game = Core.serviceItemByIndex(index);
                        footer.itemClicked(game);
                    }
                    onEntered: d.additionalArea = true
                    onExited: d.additionalArea = false
                }

                Item {
                    height: imageGame.height
                    anchors { left: parent.left; right: parent.right }

                    Rectangle {
                        width: imageGame.width + 2
                        height: imageGame.height + 2
                        anchors { left: parent.left; leftMargin: 6; top: parent.top; topMargin: -1 }
                        color: "#ffffff"
                        opacity: 0.15
                    }

                    Image {
                        id: imageGame

                        anchors { left: parent.left; margins: 7 }
                        source: installPath + imageFooter

                        Elements.CursorMouseArea {
                            id: mouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                            toolTip: Core.serviceItemByIndex(index) ? Core.serviceItemByIndex(index).miniToolTip : ""
                            tooltipPosition: 'E'
                            onClicked: {
                                var game = Core.serviceItemByIndex(index);
                                footer.itemClicked(game);
                            }
                            onEntered: d.additionalArea = true
                            onExited: d.additionalArea = false
                        }

                        Item {
                            height: (textGame.lineCount + 1) * 12
                            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }

                            Rectangle {
                                anchors.fill: parent
                                color: '#000000'
                                opacity: 0.5
                            }

                            Text {
                                id: textGame

                                anchors.fill: parent
                                hoverEnabled: true
                                toolTip: Core.serviceItemByIndex(index) ? Core.serviceItemByIndex(index).miniToolTip : ""
                                tooltipPosition: 'E'
                                onClicked: {
                                    var game = Core.serviceItemByIndex(index);
                                    footer.itemClicked(game);
                                }
                                onEntered: d.additionalArea = true
                                onExited: d.additionalArea = false
                            }
                        }
                    }
                }
            }
        }

        model: Core.gamesListModel

        onContentYChanged: {
            if (internal._interpolation === true) {
                internal._interpolation = false;
                return;
            }

            internal._tempContentY = contentY;
        }
    }

    QtObject {
        id: internal

        property real _tempContentY;
        property bool _moving: listViewId.contentY !== _tempContentY;
        property bool _interpolation: false
    }

    Timer {
        interval: 33 //30 fps
        running: internal._moving
        repeat: true
        onTriggered: {
            var dist = internal._tempContentY - listViewId.contentY,
                    step = dist / 4;

            internal._interpolation = true;
            listViewId.contentY += dist > 0 ? Math.max(1, step) : Math.min(-1 , step)
        }
    }

    FooterBlocks.FooterButton {
        isTopButton: false

        anchors.bottom: parent.bottom
        width: listViewId.width
        height: 18
        visible: listViewId.contentY < (listViewId.contentHeight - listViewId.height)
        opacity: buttonVisible? 1 : 0

        onEnter: d.additionalArea = true
        onExit: d.additionalArea = false
        onClick: listViewId.moveDown()
    }
    FooterBlocks.FooterButton {
        isTopButton: true

        anchors.top: parent.top
        width: listViewId.width
        height: 18
        visible: listViewId.contentY > 0
        opacity: buttonVisible? 1 : 0

        onEnter: d.additionalArea = true
        onExit: d.additionalArea = false
        onClick: listViewId.moveUp()
    }
}
