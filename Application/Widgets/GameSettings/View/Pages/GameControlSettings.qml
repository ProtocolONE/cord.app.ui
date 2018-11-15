import QtQuick 2.4
import Tulip 1.0

Item {
    id: settingsPageRoot

    property variant currentItem

    onCurrentItemChanged: {
        var map = { };

        var showForNotInstalled = { }

        if (currentItem && map[currentItem.serviceId]) {
            if (!currentItem.isInstalled && !!!showForNotInstalled[currentItem.serviceId]) {
                loader.source = "./GameControls/NotAvailableSettings.qml";
                return;
            }

            loader.source = map[currentItem.serviceId];
        }
    }

    function save() {
        if (loader.item) {
            loader.item.save();
        }
    }

    function load() {
        if (loader.item) {
            loader.item.load();
        }
    }

    Loader {
        id: loader

        anchors.fill: parent
        onLoaded: item.load();
    }
}
