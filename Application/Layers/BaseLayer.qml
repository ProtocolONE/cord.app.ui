import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0
import Application.Blocks 1.0
import Application.Blocks.Header 1.0
import Application.Blocks.GameMenu 1.0
import GameNet.Components.Widgets 1.0

import "../../Application/Blocks/AllGames" as AllGames

import "../../Application/Core/App.js" as App
import "../../Application/Core/TrayPopup.js" as TrayPopup
import "../../Application/Core/User.js" as User

import "../../Application/Core/Popup.js" as Popup

Rectangle {
    id: root

    implicitWidth: 1000
    implicitHeight: 600

    color: "#092135"

    // HACK
    //    Component.onCompleted: {
    //        App.activateGame(App.serviceItemByGameId("92"))
    //    }

    Connections {
        target: App.signalBus()

        onNavigate: {
            console.log("onNavigate: " + link);

            if (link == "mygame") {
                root.state = "SelectedGame";

                if (!App.isServiceInstalled(App.currentGame().serviceId)) {
                    gameMenu.pageClicked('AboutGame');
                } else {
                    gameMenu.pageClicked('News');
                }
            }

            if (page == "allgame") {
                root.state = "AllGames";
            }
        }
    }

    Item {
        id: cont

        anchors.fill: parent

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
            onSwitchTo: App.navigate(page);
        }

        Item {
            id: gameBlock

            width: 180
            height: root.implicitHeight - header.implicitHeight

            Column {
                width: 180
                height: parent.height
                spacing: 1

                Rectangle {
                    color: '#082135'
                    width: parent.width
                    height: gameControlBlock.height + 1

                    Column {
                        id: gameControlBlock

                        width: parent.width
                        height: gameInstallBlock.height + (secondAuthView.visible ? secondAuthView.height : 0)

                        GameInstallBlock {
                            id: gameInstallBlock
                        }

                        WidgetContainer {
                            id: secondAuthView

                            widget: "SecondAccountAuth"
                            view: "SecondAccountView"

                            width: parent.width
                            height: User.isAuthorized() && User.isPremium()
                                    ? ((!User.isSecondAuthorized() ? 34 : 0) + (User.isSecondAuthorized() ? 88 : 0))
                                    : 0

                            opacity: User.isAuthorized() && User.isPremium() ? 1 : 0
                            visible: opacity > 0

                            Behavior on opacity {
                                NumberAnimation { duration: 250 }
                            }

                            Behavior on height {
                                NumberAnimation { duration: 250 }
                            }

                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: '#242537'
                    }
                }

                Item {
                    id: gameMenuItem

                    width: 180
                    height: 400
                    clip: true

                    GameMenu {
                        id: gameMenu

                        anchors.fill: parent
                        model: App.currentGame().menu

                        onUrlClicked: App.openExternalUrlWithAuth(url);
                        onPageClicked: {
                            console.log('Open Page ', page);
                            if (page == 'GameSettings') {
                                if(root.state != "SelectedGame") {
                                    return;
                                }

                                App.openGameSettings();
                            }

                            if (page == 'AboutGame') {
                                root.state = 'AboutGame';
                            }

                            if (page == 'News') {
                                root.state = 'SelectedGame';
                            }
                        }
                    }
                }
            }

            Rectangle {
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                }

                width: 1
                color: '#133042'
            }

            Rectangle {
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    rightMargin: 1
                }

                width: 1
                color: '#191a2f'
            }

            SocialNet {
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    margins: 10
                }
            }
        }

        Item {
            id: aboutGame

            width: 590
            height: 600 - header.implicitHeight

            Item {
                anchors { fill: parent }
                clip: true

                Flickable {
                    id: aboutGameFlickable

                    anchors { fill: parent }
                    contentWidth: width
                    boundsBehavior: Flickable.StopAtBounds

                    Column {
                        width: parent.width

                        onHeightChanged: aboutGameFlickable.contentHeight = height;

                        WidgetContainer {
                            width: viewInstance.width
                            height: viewInstance.height

                            widget: 'GameInfo'
                        }

                        Rectangle {
                            height: 1
                            width: parent.width
                            color: '#e1e5e8'
                        }

                        WidgetContainer {
                            width: parent.width
                            height: viewInstance.height

                            widget: 'GameNews'
                        }
                    }
                }
            }

            ScrollBar {
                flickable: aboutGameFlickable
                anchors {
                    right: parent.right
                    rightMargin: 2
                }
                height: parent.height
                scrollbarWidth: 5
            }
        }

        // TODO ниже верстку вынести куда то?
        Item {
            id: centerBlock

            width: 590
            height: 600 - header.implicitHeight

            Item {
                anchors { fill: parent }
                clip: true

                Flickable {
                    id: flickable

                    anchors { fill: parent }
                    contentWidth: width
                    boundsBehavior: Flickable.StopAtBounds

                    Column {
                        width: parent.width

                        onHeightChanged: flickable.contentHeight = height;

                        Rectangle {
                            id: maintenanceRect

                            width: parent.width
                            height: 112
                            color: '#082135'
                            visible: App.currentGame().maintenance && App.currentGame().allreadyDownloaded

                            WidgetContainer {
                                anchors.centerIn: parent

                                width: viewInstance.width
                                height: viewInstance.height

                                widget: 'Maintenance'
                                view: 'MaintenanceLightView'
                            }
                        }

                        WidgetContainer {
                            width: parent.width
                            height: 194

                            widget: 'GameAdBanner'
                        }

                        WidgetContainer {
                            width: parent.width
                            height: 40

                            widget: 'Facts'
                        }

                        WidgetContainer {
                            width: parent.width
                            height: viewInstance.height

                            widget: 'GameNews'
                        }
                    }
                }
            }

            ScrollBar {
                flickable: flickable
                anchors {
                    right: parent.right
                    rightMargin: 2
                }
                height: parent.height
                scrollbarWidth: 5
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

    states: [

        State {
            name: "SelectedGame"

            PropertyChanges { target: header; parent: layer1headerContair}

            PropertyChanges { target: gameBlock; parent: layer1Col1}

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
        ,
        State {
            name: "AboutGame"

            PropertyChanges { target: header; parent: layer1headerContair}

            PropertyChanges { target: gameBlock; parent: layer1Col1}
            PropertyChanges { target: aboutGame; parent: layer1Col2}

            PropertyChanges { target: userProfile; parent: layer2Col2}
            PropertyChanges { target: contactList; parent: layer2Col2}
        }
    ]
}
