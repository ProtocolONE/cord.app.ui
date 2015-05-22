import QtQuick 1.1

import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../../../Core/App.js" as App
import "../../../../../../Core/EmojiOne.js" as EmojiOne
import "../../../../../../Core/Styles.js" as Styles

import "../../../../Plugins/Smiles/Smiles.js" as Smiles

import "./SmilesPack.js" as SmilesPack

Rectangle {
    id: smilePanel

    signal insertSmile(string tag)
    signal closeRequest()

    width: 248
    height: 275
    color: Styles.style.messengerSmilePanelBackground

    border.color: Styles.style.messengerSmilePanelBorder

    Component.onCompleted: d.init();

    QtObject {
        id: d

        function init() {
            d.loadModel();
            d.fillData();
        }

        function loadModel() {
            var recentArray = Smiles.recentSmilesList(),
                mostArray = Smiles.sortedRecentSmiles();

            recentGridView.grid.model = Object.keys(recentArray).map(function(e){
                var shortName = ':' + recentArray[e] + ':';
                return d.shortNameToModelItem(shortName);
            });

            mostUsedGridView.grid.model = Object.keys(mostArray).map(function(e){
                var shortName = ':' + mostArray[e] + ':';
                return d.shortNameToModelItem(shortName);
            });
        }

        function shortNameToModelItem(shortName) {
            var  item = {}
                , shortSmile = EmojiOne.ns.shortnameToImage(shortName)
                , src = /<img.*?src="(.*?)"/.exec(shortSmile)[1];

            item.tag = shortName;
            if (App.isQmlViewer()) {
                item.imageSource = 'file:///' + src; // For Debug QmlViewer
            } else {
                item.imageSource = src.replace(':/', 'qrc:///');
            }

            return item;
        }

        function fillData() {
            var tabs = SmilesPack.tabs,
                restArray = [],
                hash = {},
                smileSmallTabArray = [];

            Object.keys(tabs).forEach(function(tabIndex){
                var tab = tabs[tabIndex];

                Object.keys(tab).forEach(function(smileElement){
                    hash[tab[smileElement]] = '1';
                })
            });

            Object.keys(EmojiOne.ns.emojioneList).forEach(function(e) {
                if (!hash.hasOwnProperty(e)) {
                    restArray.push(e);
                }
            });

            tabs.splice(7, 0, restArray);

            Object.keys(tabs).forEach(function(tabIndex){
                var tab = tabs[tabIndex];

                smileSmallTabArray.push({
                                            "imageSource": "Assets/Images/Application/Widgets/Messenger/Smile/" + tabIndex + ".png",
                                            "scrollPos": baseGridView.grid.count
                                         });

                Object.keys(tab).forEach(function(smileElement){
                    var item = d.shortNameToModelItem(tab[smileElement])
                    baseGridView.grid.model.append(item);
                });
            });

            smallTabPanel.model = smileSmallTabArray;
        }
    }

    CursorMouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }

    Rectangle {
        anchors {
            top: parent.bottom
            topMargin: -height / 2
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: 10
        }

        width: 12
        height: 12
        rotation: 45
        color: Styles.style.messengerSmilePanelSubstrate
        border.color: parent.border.color
    }

    Rectangle {
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }
        height: 22
        color: Styles.style.messengerSmilePanelSubstrate

        ListView {
            id: smallTabPanel

            width: parent.width + 1
            height: parent.height

            orientation: ListView.Horizontal
            interactive: false
            spacing: 1
            clip: true

            function tultip(index) {
                var tultips = [
                            qsTr("SMALL_TAB_1_TULTIP"),
                            qsTr("SMALL_TAB_2_TULTIP"),
                            qsTr("SMALL_TAB_3_TULTIP"),
                            qsTr("SMALL_TAB_4_TULTIP"),
                            qsTr("SMALL_TAB_5_TULTIP"),
                            qsTr("SMALL_TAB_6_TULTIP"),
                            qsTr("SMALL_TAB_7_TULTIP"),
                            qsTr("SMALL_TAB_8_TULTIP"),
                            qsTr("SMALL_TAB_9_TULTIP"),
                            qsTr("SMALL_TAB_10_TULTIP"),
                    ]
                return tultips[index]
            }

            delegate: SmileTab {
                width: 24
                height: 22

                imageSource: smallTabPanel.model[index].imageSource
                tultip: smallTabPanel.tultip(index)

                function isActiveFunc() {
                    if (bigSmilePanel.currentIndex > 0) {
                        return false;
                    }

                    var startIndex = smallTabPanel.model[index].scrollPos,
                        endIndex = baseGridView.grid.count;

                    if (index < smallTabPanel.count - 1) {
                        endIndex = smallTabPanel.model[index + 1].scrollPos;
                    }

                    return (baseGridView.cursorPosition >= startIndex) && (baseGridView.cursorPosition < endIndex);
                }

                isActive: isActiveFunc()

                onClicked: {
                    var scrollPos = smallTabPanel.model[index].scrollPos;
                    baseGridView.positionViewAtIndex(scrollPos);

                    bigSmilePanel.currentIndex = 0;
                }
            }
        }

        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: Styles.style.messengerSmilePanelBorder
        }

        Rectangle {
            anchors.top: parent.top
            width: 1
            height: parent.height
            color: Styles.style.messengerSmilePanelBorder
        }
    }

    Rectangle {
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
        height: 35
        color: Styles.style.messengerSmilePanelSubstrate
        border.color: Styles.style.messengerSmilePanelBorder

        ListView {
            id: bigSmilePanel

            anchors {
                fill: parent
                topMargin: 1
            }

            orientation: ListView.Horizontal
            interactive: false

            onCurrentIndexChanged: {
                if (currentIndex > 0) {
                    smallTabPanel.currentIndex = smallTabPanel.count;
                }
            }

            model: ListModel {
                ListElement {
                    imageSource: "Assets/Images/Application/Widgets/Messenger/Smile/faceTab.png"
                }
                ListElement {
                    imageSource: "Assets/Images/Application/Widgets/Messenger/Smile/lastTab.png"
                }
                ListElement {
                    imageSource: "Assets/Images/Application/Widgets/Messenger/Smile/lovelyTab.png"
                }

                function tultip(index) {
                    var tultips = [
                            qsTr("FACE_TAB_TULTIP"),
                            qsTr("LAST_TAB_TULTIP"),
                            qsTr("RECENT_TAB_TULTIP"),
                        ]
                    return tultips[index]
                }
            }

            delegate: SmileTab {
                width: 35
                height: 34

                imageSource: model.imageSource
                tultip: bigSmilePanel.model.tultip(index)

                isActive: bigSmilePanel.currentIndex === index;
                onClicked: bigSmilePanel.currentIndex = index;
            }
        }
    }

    Item {
        anchors {
            fill: parent
            topMargin: 35
            bottomMargin: 22
        }

        BaseGrid {
            id: baseGridView

            anchors.fill: parent

            visible: bigSmilePanel.currentIndex === 0

            grid.delegate: SmileChatButton {
                imageSource: model.imageSource
                shortname: model.tag

                onClicked: smilePanel.insertSmile(model.tag);
            }

            grid.model: ListModel {
                id: gridMap
            }
        }

        BaseGrid {
            id: recentGridView

            anchors.fill: parent

            visible: bigSmilePanel.currentIndex === 1

            grid.delegate: SmileChatButton {
                imageSource: recentGridView.grid.model[index].imageSource
                shortname: recentGridView.grid.model[index].tag

                onClicked: smilePanel.insertSmile(recentGridView.grid.model[index].tag);
            }
        }

        BaseGrid {
            id: mostUsedGridView

            anchors.fill: parent

            visible: bigSmilePanel.currentIndex === 2

            grid.delegate: SmileChatButton {
                imageSource: mostUsedGridView.grid.model[index].imageSource
                shortname: mostUsedGridView.grid.model[index].tag

                onClicked: smilePanel.insertSmile(mostUsedGridView.grid.model[index].tag);
            }
        }
    }

    Item {
        height: 34
        width: height
        anchors.right: parent.right

        Image {
            id: closeImage

            anchors.centerIn: parent

            source: installPath + "Assets/Images/Application/Widgets/Messenger/Smile/cross.png"
            opacity: closeMouseArea.containsMouse ? 1 : 0.7

        }

        Rectangle {
            width: 1
            height: parent.height
            anchors.left: parent.left
            color: Styles.style.messengerSmilePanelBorder
        }

        CursorMouseArea {
            id: closeMouseArea

            anchors.fill: parent
            hoverEnabled: true
            onClicked: smilePanel.closeRequest();
        }
    }
}
