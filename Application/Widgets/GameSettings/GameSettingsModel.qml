import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import "../../Core/App.js" as App

WidgetModel {
    id: root

    property variant currentGame

    Component.onCompleted: {
        root.currentGame = App.currentGame();
        App.gameSettingsModelInstance().switchGame(currentGame.serviceId);
    }
}
