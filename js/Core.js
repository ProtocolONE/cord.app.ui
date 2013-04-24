.pragma library

var serviceIdToGameItemIdex = {},
    indexToGameItem = {},
    count = 0;

var gamesListModel = initModel();

var gamenetGameItem = {
    imageLogoSmall: "images/games/gamenet_logo_small.png",
    name: "GameNet",
    serviceId: "0"
};

function initModel() {
    var component = Qt.createComponent('../Models/GamesListModel.qml');

    if (component.status != 1) {
        console.log('FATAL: error loading model');
        return null;
    }

    var list = component.createObject(null);
    if (!list) {
        console.log('FATAL: error creating model');
        return null;
    }

    var i, item;
    count = list.count;
    for (i = 0; i < count; ++i) {
        item = list.get(i);
        indexToGameItem[i] = item;
        serviceIdToGameItemIdex[item.serviceId] = i;
    }

    return list;
}

function activateGame(item) {
    gamesListModel.currentGameItem = item;
}

function activateGameByServiceId(serviceId) {
    var item = serviceItemByServiceId(serviceId);

    if (!item)
        return;

    setCurrentGameItem(item);
}

function currentGame() {
    return gamesListModel.currentGameItem;
}

function serviceItemByIndex(index) {
    return indexToGameItem[index];
}

function serviceItemByServiceId(serviceId) {
    if (serviceId == 0) {
        return gamenetGameItem;
    }

    var index = indexByServiceId(serviceId)
    return index != undefined ? indexToGameItem[index] : undefined;
}

function indexByServiceId(serviceId) {
    return serviceIdToGameItemIdex[serviceId];
}

