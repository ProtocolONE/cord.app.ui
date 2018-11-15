import QtQuick 2.4
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

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
        if (App.isSingleGameMode()) {
            App.activateFirstGame();
            SignalBus.navigate("mygame", "");
            return;
        }

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
                case 'GameSettings': {
                    return;
                }
                case "mygame": {
                    root.selectedGamePage = true;
                    centralBlockLoader.sourceComponent = gamePageBlock;
                    centralBlockLoader.item.updateState();

                } break;
                case "allgame": {
                    if (App.isSingleGameMode()) {
                        break;
                    }

                    centralBlockLoader.sourceComponent = allGames;
                    root.selectedGamePage = false;
                    App.resetGame();
                } break;
                case "themes": {
                    centralBlockLoader.sourceComponent = themes;
                    if (App.isSingleGameMode()) {
                        break;
                    }

                    root.selectedGamePage = false;
                    App.resetGame();
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

                visible: !App.isSingleGameMode()

                WidgetContainer {
                    height: parent.height
                    width: 230

                    widget: 'AllGames'
                    view: 'VerticalListView'
                }

//                WidgetContainer {
//                    id: userProfile

//                    widget: 'UserProfile'
//                }

//                WidgetContainer {
//                    height: parent.height - userProfile.height
//                    width: 230
//                    widget: 'Messenger'
//                    view: 'Contacts'
//                }
            }

            Item {
                width: root.width - (App.isSingleGameMode() ? 0 : 230)
                height: parent.height

                Loader {
                    id: centralBlockLoader

                    anchors.fill: parent
                    onSourceComponentChanged: gc()
                }
            }
        }

        ContentStroke {
            anchors.bottom: parent.bottom
            width: parent.width
        }

        ContentStroke {
            anchors {
                top: parent.top
                topMargin: 30
                right: parent.right
                bottom: parent.bottom
            }
        }
    }

    // INFO из-за перекрытия нескольких слоев/виджетов пришлось вытащить наружу.
//    WidgetContainer {
//        visible: User.isPromoActionActive()

//        widget: visible ? 'UserProfile' : ''
//        view: visible ? 'PromoActionIconView' : ''
//        x: 230
//        y: 31
//    }

    Component {
        id: allGames

        WidgetContainer {
            widget: 'AllGames'
        }
    }

    Component {
        id: mainGamePageCmp

        MainGamePage {
            currentGame: root.currentGame
        }
    }

    Component {
        id: aboutGameCmp

        AboutGame { }
    }

    Component {
        id: gamePageBlock

        Item {
            anchors.fill: parent

            function updateState() {
                if (!root.hasCurrentGame) {
                    return;
                }

                var showMaintainance = root.currentGame.allreadyDownloaded && root.currentGame.maintenance;

                if (!ApplicationStatistic.isServiceInstalled(root.currentGame.serviceId) && !showMaintainance) {
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
                visible: !!root.currentGame && !!root.currentGame.supportId
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

                width: parent.width

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
        id: themes

        WidgetContainer {
            widget: 'Themes'
        }
    }
}
