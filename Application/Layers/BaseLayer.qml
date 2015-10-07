import QtQuick 2.4
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0
import Application.Controls 1.0
import Application.Blocks 1.0
import Application.Blocks.Header 1.0
import Application.Blocks.GameMenu 1.0

import "./Private"

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
            SignalBus.navigate("mygame", "");
            return;
        }

        SignalBus.navigate("allgame", "");
    }

    Image {
        anchors.fill: parent
        source: !!root.currentGame ? root.currentGame.backgroundInApp : ""
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: opacity > 0
        opacity: root.selectedGamePage ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 500
            }
        }
    }

    Connections {
        target: SignalBus
        onNavigate: {
            switch (link) {
                case 'ApplicationSettings':{
                    // INFO Приходит сигнал из mainWindow по клику в таскбар
                    Popup.show('ApplicationSettings');
                    return;
                }
                case 'PremiumServer':
                case 'GameSettings': {
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
            onSwitchTo: SignalBus.navigate(page, "");
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

                if (!ApplicationStatistic.isServiceInstalled(root.currentGame.serviceId)) {
                    gameMenu.pageClicked('AboutGame');
                } else {
                    gameMenu.pageClicked('News');
                }
            }

            SocialNet {
                anchors {right: parent.right; top: parent.top; topMargin: 8}
            }

            SupportIcon {
                anchors {right: parent.right; top: parent.top; topMargin: 420}
                visible: !!root.currentGame && root.currentGame.supportId
                onClicked: App.openSupportUrl('/new-ticket?set_dep_id=' + root.currentGame.supportId)
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
                        case 'PremiumServer':
                            if (!root.selectedGamePage) {
                                console.log('Fail to open PremiumServer popup');
                                return;
                            }

                            if (User.hasUnlimitedSubscription(root.currentGame.serviceId)) {
                                MessageBox.show(
                                            qsTr("Доступ к премиум-серверу"),
                                            qsTr("Доступ на премиум-сервер открыт Вам навсегда"),
                                            MessageBox.button.ok);
                            } else {
                                Popup.show('PremiumServer');
                            }
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
