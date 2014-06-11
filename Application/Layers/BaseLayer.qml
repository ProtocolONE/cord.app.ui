import QtQuick 1.1
import GameNet.Controls 1.0 as Controls
import Application.Blocks.Header 1.0
import Application.Blocks.GameMenu 1.0
import GameNet.Components.Widgets 1.0

import "../../Application/Blocks/AllGames" as AllGames

import "../../Application/Core/App.js" as AppJs

Rectangle {
    id: root

    implicitWidth: 1000
    implicitHeight: 600

    // HACK
    color: "#092135"
    Component.onCompleted: {
        AppJs.activateGame(AppJs.serviceItemByGameId("92"))
    }

    Rectangle {
        id: cont

        anchors.fill: parent
        color: "brown"

        Item {
            id: layer1headerContair

            width: parent.width
            height: 42
        }

        //3 column set
        Row {
            id: cs3
            z: 0

            anchors { fill: parent;  topMargin: 42}

            Column {id: layer1Col1; width: 180; height: parent.height;}
            Column {id: layer1Col2; width: 590; height: parent.height;}
            Column {id: layer1Col3; width: 230; height: parent.height;}
        }

        //2 column set
        Row {
            id: cs2
            z: 0

            anchors { fill: parent;  topMargin: 42}

            Column {id: layer2Col1 ; width: 770; height: parent.height;}
            Column {id: layer2Col2; width: 230; height: parent.height;}
        }

        //1 column set
        Row {
            id: cs1

            anchors { fill: parent;  topMargin: 42}

            Column {id: layer3Col1 ; width: 1000; height: parent.height}
        }
    }


    Item {
        id: stash

        objectName: "Stash"

        width: 0
        height: 0
        clip: true
        visible: false

        Header {
            id: header

            anchors.fill: parent

            onSwitchTo:  {
                console.log('!!!', page)
                if (page == "mygame") {
                    root.state = "SelectedGame";
                }

                if (page == "allgame") {
                    root.state = "AllGames";
                }
            }
        }


        Rectangle {
            id: gameBlock

            objectName: "gameBlock"

            width: parent.width
            height: 136
            color : "green"

            onParentChanged: console.log(gameBlock, parent)

            WidgetContainer {
                width: 590
                height: 100
                widget: 'GameInstall'
            }

//            Text {
//                color: "#FFFFFF"
//                font.pixelSize: 40
//                text: "GameInfo"
//            }

        }

        Item {
            id: gameMenuItem

            //width: parent.width
            //height: parent.height - gameBlock.height
            width: 180
            height: 400
            clip: true

            GameMenu {
                id: gameMenu

                anchors.fill: parent
                model: AppJs.currentGame().menu

                onUrlClicked: {
                    console.log('Open Url', url)
                    //AppProxy.openExternalUrl(url)
                }

                onPageClicked: {
                    //Core.currentGame().currentMenuIndex = gameMenu.currentIndex;
                    console.log('Open Page ', page)
                }
            }

        }

        Rectangle {
            id: centerBlock

            width: 590
            height: 600-42
            color: "pink"

            Text {
                color: "#FFFFFF"
                font.pixelSize: 40
                text: "Central Block"
            }
        }


        WidgetContainer {
            id: userProfile

            width: parent.width
            height: 92
            widget: 'UserProfile'
        }


        Rectangle {
            id: fakeChat

            color: "cyan"
            width: 230
            height: parent.height - userProfile.height

            Text {
                color: "#FFFFFF"
                font.pixelSize: 40
                text: "Contats list"
            }
        }

        Rectangle {
            id: fakeAllGames

            color: "blue"
            width: 180+590
            height: parent.height;

            Text {
                color: "#FFFFFF"
                font.pixelSize: 40
                text: "All games "
            }
        }

        WidgetContainer {
            id: contactList

            anchors {
                right: parent.right
                bottom: parent.bottom
            }

            height: 467
            width: 230
            widget: 'Messenger'
            view: 'Contacts'
        }
    }


    state: "SelectedGame"

    states: [

        State {
            name: "SelectedGame"

            PropertyChanges { target: header; parent: layer1headerContair}

            PropertyChanges { target: gameBlock; parent: layer1Col1}
            PropertyChanges { target: gameMenuItem; parent: layer1Col1}

            PropertyChanges { target: centerBlock; parent: layer1Col2}

            PropertyChanges { target: userProfile; parent: layer1Col3}
            PropertyChanges { target: contactList; parent: layer1Col3}
        }

        ,
        State {
            name: "AllGames"

            PropertyChanges { target: header; parent: layer1headerContair}

            PropertyChanges { target: fakeAllGames; parent: layer2Col1}

            PropertyChanges { target: userProfile; parent: layer2Col2}
            PropertyChanges { target: contactList; parent: layer2Col2}
        }
    ]
}
