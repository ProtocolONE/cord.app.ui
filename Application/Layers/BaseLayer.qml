import QtQuick 1.1
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Blocks 1.0
import Application.Blocks.Header 1.0
import Application.Blocks.GameMenu 1.0

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
    property bool selectedGamePage: false

    implicitWidth: 1000
    implicitHeight: 600

    Component.onCompleted: {
        if (App.startingService() != '0') {
            App.activateGame(App.serviceItemByServiceId(App.startingService()));
            App.navigate("mygame");
            return;
        }

        App.navigate("allgame");
    }

    Image {
        anchors.fill: parent
        source: !!root.currentGame ? root.currentGame.backgroundInApp : ""
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: root.selectedGamePage
    }

    Connections {
        target: App.signalBus()
        onNavigate: {
            console.log("onNavigate: " + link);
            switch (link) {
                case 'ApplicationSettings':{
                    // INFO Приходит сигнал из mainWindow по клику в таскбар
                    Popup.show('ApplicationSettings');
                    GoogleAnalytics.trackPageView('/' + link);
                    return;
                }
                case 'GameSettings': {
                    GoogleAnalytics.trackPageView('/' + link);
                    return;
                }

                case "mygame": {
                    root.selectedGamePage = true;
                    centralBlockLoader.sourceComponent = gamePageBlock;
                } break;
                case "allgame": {
                    centralBlockLoader.sourceComponent = allGames;
                    root.selectedGamePage = false;
                } break;
                case "themes": {
                    centralBlockLoader.sourceComponent = themes;
                    root.selectedGamePage = false;
                } break;

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

            Item {
                width: root.width - 230
                height: parent.height

                Loader {
                    id: centralBlockLoader

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 770;
                    height: parent.height;
                    onSourceComponentChanged: gc()
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
                            if (!root.selectedGamePage) {
                                console.log('Fail to open game settings from ');
                                return;
                            }

                            Popup.show('GameSettings');
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
}
