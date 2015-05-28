import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0
import Application.Blocks 1.0
import Application.Blocks.Header 1.0
import Application.Blocks.GameMenu 1.0
import GameNet.Components.Widgets 1.0

import "./Private"
import "../../Application/Core/App.js" as App
import "../../Application/Core/TrayPopup.js" as TrayPopup
import "../../Application/Core/User.js" as User
import "../../Application/Core/Popup.js" as Popup
import "../../Application/Core/Styles.js" as Styles

import "../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    property variant currentGame: App.currentGame()
    property bool hasCurrentGame: !!currentGame

    implicitWidth: 1000
    implicitHeight: 600

    Component.onCompleted: {
        if (App.startingService() != '0') {
            App.activateGame(App.serviceItemByServiceId(App.startingService()));
            App.navigate("mygame");
            return;
        }

    Connections {
        target: App.signalBus()
        onNavigate: {
            console.log("onNavigate: " + link);

            switch (link) {
                case 'ApplicationSettings':
                case 'GameSettings': {
                    GoogleAnalytics.trackPageView('/' + link);
                    return;
                }
                case "mygame": {
                    root.state = "SelectedGame";

                    if (root.hasCurrentGame) {
                        GoogleAnalytics.trackPageView('/game/' + root.currentGame.gaName);

                        if (!App.isServiceInstalled(root.currentGame.serviceId)) {
                            gameMenu.pageClicked('AboutGame');
                        } else {
                            gameMenu.pageClicked('News');
                        }
                    }
                    return;
                }
                case "allgame": root.state = "AllGames"; break;
                case "mygames": root.state = "MyGames"; break;
                case "themes": root.state = "Themes"; break;
                default: {
                    console.log('Unknown link', link);
                }
            }
        }
    }

    Item {
        anchors.fill: parent

        Header {
            width: parent.width
            height: 30
            onSwitchTo: App.navigate(page);
        }

        Row {
            anchors { fill: parent;  topMargin: 30 }

            Column {
                width: 230;
                height: parent.height;

                WidgetContainer {
                    id: userProfile

                    widget: 'UserProfile'
                }

                WidgetContainer {
                    height: parent.height - userProfile.height
                    width: 230
                    widget: 'Messenger'
                    view: 'Contacts'
                }
            }

            Loader {
                id: centralBlockLoader

                width: 770;
                height: parent.height;
                onSourceComponentChanged: gc()
            }
        }
    }

    Component {
        id: allGames

        WidgetContainer {
            widget: 'AllGames'
        }
    }

    Component {
        id: mainGamePageCmp

        MainGamePage {
            width: 590
            height: 489
            currentGame: root.currentGame
        }
    }

    Component {
        id: aboutGameCmp

        AboutGame {
            width: 590
            height: 489
        }
    }

    Component {
        id: gamePageBlock

        Item {
            anchors.fill: parent

            Component.onCompleted: {
                if (!root.hasCurrentGame) {
                    return;
                }

                GoogleAnalytics.trackPageView('/game/' + root.currentGame.gaName);

                if (!App.isServiceInstalled(root.currentGame.serviceId)) {
                    gameMenu.pageClicked('AboutGame');
                } else {
                    gameMenu.pageClicked('News');
                }
            }

            SocialNet {
                anchors {right: parent.right; top: parent.top; topMargin: 8}
            }

            Loader {
                id: widgetContent

                y: 20
                anchors.horizontalCenter: parent.horizontalCenter
                onSourceComponentChanged: gc()
                clip: true
            }

            GameMenu {
                id: gameMenu

                anchors.bottom: parent.bottom
                model: root.hasCurrentGame ? root.currentGame.menu : undefined
                onUrlClicked: App.openExternalUrlWithAuth(url);
                onPageClicked: {
                    console.log('Open Page ', page);

                    switch(page) {
                        case 'GameSettings':
                            if (root.state != "SelectedGame") {
                                console.log('Fail to open game settings from ', root.state);
                                return;
                            }
                            App.navigate('GameSettings');
                            break;
                        case 'AboutGame':
                            widgetContent.sourceComponent = aboutGameCmp;
                            break;
                        case 'News':
                            widgetContent.sourceComponent = mainGamePageCmp;
                            break;
                    }
                }
            }
        }
    }

    Component {
        id: allGames

        WidgetContainer {
            widget: 'AllGames'
        }
    }

    Component {
        id: themes

        WidgetContainer {
            widget: 'Themes'
        }
    }

    states: [
        State {
            name: "AllGames"
            PropertyChanges { target: centralBlockLoader; sourceComponent: allGames}
        },
        State {
            name: "SelectedGame"
            PropertyChanges { target: centralBlockLoader; sourceComponent: gamePageBlock}
        }
        ,
        State {
            name: "MyGames"

            PropertyChanges { target: centralBlockLoader; sourceComponent: myGamesComponent}
            PropertyChanges { target: header; parent: layer1headerContair}
            PropertyChanges { target: myGamesMenu; parent: layer2Col1}
            PropertyChanges { target: centralBlockLoader; parent: layer1Col2}
            PropertyChanges { target: userProfile; parent: layer2Col2}
            PropertyChanges { target: contactList; parent: layer2Col2}
        },
        State {
            name: "Themes"

            PropertyChanges { target: centralBlockLoader; sourceComponent: themes}
            PropertyChanges { target: header; parent: layer1headerContair}
            PropertyChanges { target: centralBlockLoader; parent: layer1Col1}
            PropertyChanges { target: userProfile; parent: layer2Col2}
            PropertyChanges { target: contactList; parent: layer2Col2}
        }

    ]
}
