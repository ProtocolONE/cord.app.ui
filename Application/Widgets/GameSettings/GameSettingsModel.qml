import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import Application.Core 1.0

WidgetModel {
    id: root

    property variant currentGame

    Component.onCompleted: {
        root.currentGame = App.currentGame();
        App.gameSettingsModelInstance().switchGame(currentGame.serviceId);
    }
}
