.pragma library
Qt.include("../Proxy/Settings.js")

var socialNetTable = {
    "300002010000000000":[//Aika
        {
            link: "http://www.youtube.com/user/GamenetAika",
            icon: "images/socialNet/yt.png"
        },
        {
            link: "http://vk.com/aikaonlineru",
            icon: "images/socialNet/vk.png"
        }
    ],
    "300003010000000000":[//BS
        {
            link: "http://www.youtube.com/bloodandsoulru",
            icon: "images/socialNet/yt.png"
        },
        {
            link: "http://www.facebook.com/pages/Blood-Soul/201464389893835",
            icon: "images/socialNet/fb.png"
        },
        {
            link: "http://vk.com/bloodandsoul",
            icon: "images/socialNet/vk.png"
        }

    ],
    "300012010000000000":[ // Reborn
        {
            link: "https://www.facebook.com/pages/Reborn/397344480387678",
            icon: "images/socialNet/fb.png"
        },
        {
            link: "https://vk.com/reborngame",
            icon: "images/socialNet/vk.png"
        }

    ],
    "300005010000000000":[//FireStorm
        {
            link: "http://vk.com/warinc",
            icon: "images/socialNet/vk.png"
        }
    ],
    "300006010000000000":[//MW2
        {
            link: "http://vk.com/magicworld2",
            icon: "images/socialNet/vk.png"
        }
    ],
    "300007010000000000":[//Golden Age
        {
            link: "https://vk.com/golden_age_game",
            icon: "images/socialNet/vk.png"
        }
    ],
    "300009010000000000":[//Combat Arms
        {
            link: "http://www.youtube.com/user/CombatArmsRussia",
            icon: "images/socialNet/yt.png"
        },
        {
            link: "https://www.facebook.com/pages/Combat-Arms-RU/465773090177989",
            icon: "images/socialNet/fb.png"
        },
        {
            link: "http://www.odnoklassniki.ru/group/52003182084281",
            icon: "images/socialNet/ok.png"
        },
        {
            link: "http://vk.com/ca_ru",
            icon: "images/socialNet/vk.png"
        }
    ]
}
var runningService = {},
    serviceIdToGameItemIdex = {},
    indexToGameItem = {},
    gameIdToGameItem = {},
    count = 0,
    clientWidth = 930,
    clientHeight = 550,
    isClientLoaded = false;


var gamesListModel = initModel();
var _previousGame = gamesListModel.currentGameItem

var gamenetGameItem = {
    imageLogoSmall: "images/games/gamenet_logo_small.png",
    name: "GameNet",
    serviceId: "0"
};
function getCurrentSocialTable() {
    var current = currentGame();
    if (!current) {
        return null;
    }

    return socialNetTable[current.serviceId];
}

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
        gameIdToGameItem[item.gameId] = item;
        serviceIdToGameItemIdex[item.serviceId] = i;
    }

    return list;
}

function activateGame(item) {
    _previousGame = gamesListModel.currentGameItem;
    gamesListModel.currentGameItem = item;
}

function previousGame(item) {
    return _previousGame;
}

function activateGameByServiceId(serviceId) {
    var item = serviceItemByServiceId(serviceId);

    if (!item)
        return;

    activateGame(item);
}

function currentGame() {
    return gamesListModel.currentGameItem;
}

function serviceItemByIndex(index) {
    return indexToGameItem[index];
}

function serviceItemByGameId(gameId) {
    return gameIdToGameItem[gameId];
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

function isServiceInstalled(serviceId) {
    return isSettingsEnabled("GameDownloader/" + serviceId + "/", "isInstalled", false);
}

