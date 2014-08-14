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
import "../../Application/Core/Styles.js" as Styles

import "../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics


Rectangle {
    id: root

    property variant currentGame: App.currentGame()
    property bool hasCurrentGame: !!currentGame

    implicitWidth: 1000
    implicitHeight: 600

    color: Styles.style.base

    // HACK
    //    Component.onCompleted: {
    //        App.activateGame(App.serviceItemByGameId("92"))
    //    }

    Connections {
        target: App.signalBus()

        onNavigate: {
            console.log("onNavigate: " + link);

            if (link == 'ApplicationSettings' || link == 'GameSettings') {
                GoogleAnalytics.trackPageView('/' + link);
                return;
            }

            if (link == "mygame") {
                root.state = "SelectedGame";

                if (root.hasCurrentGame) {
                    GoogleAnalytics.trackPageView('/game/' + root.currentGame.gaName);

                    if (!App.isServiceInstalled(root.currentGame.serviceId)) {
                        gameMenu.pageClicked('AboutGame');
                    } else {
                        gameMenu.pageClicked('News');
                    }
                }
            }

            if (page == "allgame") {
                root.state = "AllGames";
            }

            if (link == "mygames") {
                root.state = "MyGames";
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
            myGamesMenuEnable: App.isMyGamesEnabled();

            Connections {
                target: App.signalBus()
                onServiceUpdated: header.myGamesMenuEnable = App.isMyGamesEnabled();
            }
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
                    color: Styles.style.gameMenuBackground
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

                            property bool secondAuthEnabled: User.isAuthorized()
                                    && User.isPremium()
                                    && root.hasCurrentGame
                                    && root.currentGame.secondAllowed

                            widget: "SecondAccountAuth"
                            view: "SecondAccountView"

                            width: parent.width
                            height: secondAuthEnabled
                                    ? ((!User.isSecondAuthorized() ? 34 : 0) + (User.isSecondAuthorized() ? 88 : 0))
                                    : 0

                            opacity: secondAuthEnabled ? 1 : 0
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
                        color: Qt.darker(parent.color, Styles.style.darkerFactor)
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
                        model: root.hasCurrentGame ? root.currentGame.menu : undefined

                        onUrlClicked: App.openExternalUrlWithAuth(url);
                        onPageClicked: {
                            console.log('Open Page ', page);
                            if (page == 'GameSettings') {
                                if ( !(root.state == "SelectedGame" || root.state == "AboutGame") ) {
                                    console.log('Fail to open game settings from ', root.state);
                                    return;
                                }

                                App.navigate('GameSettings');
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
                color: Qt.lighter(Styles.style.gameMenuBackground, Styles.style.lighterFactor)
            }

            Rectangle {
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    rightMargin: 1
                }

                width: 1
                color: Qt.darker(Styles.style.gameMenuBackground, Styles.style.darkerFactor)
            }

            SocialNet {
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    margins: 10
                }
            }
        }

        ScrollArea {
            id: aboutGame

            width: 590
            height: 600 - header.implicitHeight

            WidgetContainer {
                widget: 'GameInfo'
            }

            WidgetContainer {
                widget: 'GameNews'
            }
        }

        ScrollArea {
            id: centerBlock

            width: 590
            height: 600 - header.implicitHeight

            Connections {
                target: gameMenu
                onPageClicked: centerBlock.scrollToBegin();
            }

            Connections {
                target: App.signalBus()
                onNavigate: centerBlock.scrollToBegin();
            }


            WidgetContainer {
                visible: root.hasCurrentGame
                         && root.currentGame.maintenance
                         && root.currentGame.allreadyDownloaded

                widget: 'Maintenance'
                view: 'MaintenanceLightView'
            }


            WidgetContainer {
                widget: 'GameAdBanner'
            }

            WidgetContainer {
                widget: 'Facts'
            }

            WidgetContainer {
                width: parent.width
                widget: 'GameNews'
            }
        }

        ScrollArea {
            id: myGamesMenuCenterBlock

            width: 590
            height: 600 - header.implicitHeight

            WidgetContainer {
                width: parent.width

                widget: 'GameNews'
                view: 'NewsMyGames'
            }
        }

        Item {
            id: myGamesMenu

            width: 180
            height: 600 - header.implicitHeight

            Column {
                anchors.fill: parent

                Item {
                    height: 56
                    width: parent.width - 1

                    Rectangle {
                        anchors.fill: parent
                        color: Styles.style.gameMenuBackground
                    }

                    Rectangle {
                        width: 3
                        height: parent.height
                        anchors.right: parent.right
                        color: Styles.style.gameMenuSelectedIndicator
                    }

                    Text {
                        font { family: 'Arial'; pixelSize: 16 }
                        text: qsTr("MY_GAMES_CAPTION_MENU")
                        anchors {
                            left: parent.left
                            top: parent.top
                            margins: 10
                        }
                        color: Styles.style.gameMenuText
                    }

                    Text {
                        font { family: 'Arial'; pixelSize: 12 }
                        text: qsTr("MY_GAMES_MENU_NEWS")
                        anchors {
                            left: parent.left
                            top: parent.top
                            leftMargin: 10
                            topMargin: 32
                        }
                        color: Styles.style.gameMenuText
                    }

                }

                WidgetContainer {
                    width: 180
                    height: myGamesMenu.height - 56
                    widget: 'MyGamesMenu'
                }
            }
        }

        WidgetContainer {
            id: userProfile

            widget: 'UserProfile'
        }

        AllGames.Main {
            id: allGames

            width: 180 + 590
            height: parent.height
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
            PropertyChanges { target: allGames; parent: layer2Col1}
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
        ,
        State {
            name: "MyGames"
            PropertyChanges { target: header; parent: layer1headerContair}
            PropertyChanges { target: myGamesMenu; parent: layer2Col1}
            PropertyChanges { target: myGamesMenuCenterBlock; parent: layer1Col2}
            PropertyChanges { target: userProfile; parent: layer2Col2}
            PropertyChanges { target: contactList; parent: layer2Col2}
        }
    ]
}
