.pragma library
Qt.include("../Proxy/Settings.js")

var _signalBusComponent,
    _signalBusInst,
    _progressComponent,
    _progress;

if (!_signalBusComponent) {
    _signalBusComponent = Qt.createComponent('./Core.qml');
    if (_signalBusComponent.status == 1) {
        _signalBusInst = _signalBusComponent.createObject(null);
    } else {
        console.log('Can\'t create Core.qml');
    }
}

if (!_progressComponent) {
    _progressComponent = Qt.createComponent('./../Controls/GlobalProgress.qml');
    if (_progressComponent.status == 1) {
        _progress = _progressComponent.createObject(null);
    } else {
        console.log('Can\'t create GlobalProgress.qml');
    }
}

function setProgressParent(item) {
    _progress.parent = item;
    _progress.width = item.width;
    _progress.height = item.height;
}

function setGlobalProgressVisible(value, timeout) {
    if (!_progress) {
        return;
    }

    if (timeout && value) {
        _progress.interval = timeout;
    } else {
        _progress.interval = 500;
    }

    _progress.visible = value;
}

function signalBus() {
    return _signalBusInst;
}

function needAuth() {
    _signalBusInst.needAuth();
}

function showPurchaseOptions(itemOptions) {
    _signalBusInst.openPurchaseOptions(itemOptions);
}

function openBuyGamenetPremiumPage() {
    _signalBusInst.openBuyGamenetPremiumPage();
}

function premiumExpired() {
    _signalBusInst.premiumExpired();
}

function hideMainWindow() {
    _signalBusInst.hideMainWindow();
}

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
            link: "http://www.youtube.com/channel/UC6AbThTxwl1VhaLBvnkdiJg",
            icon: "images/socialNet/yt.png"
        },
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
    ],
    "300004010000000000":[//Rot
        {
            link: "http://vk.com/rageoftitans",
            icon: "images/socialNet/vk.png"
        },
    ]
}

var runningService = {},
runningSecondService = {},
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

function currentRunningMainService() {
    var serviceItem;
    for (var i = 0; i < gamesListModel.count; i++) {
        serviceItem = gamesListModel.get(i);

        if (serviceItem.status === "Started" || serviceItem.status === "Starting") {
            return serviceItem.serviceId;
        }
    }
}

function currentRunningSecondService() {
    var serviceItem;
    for (var i = 0; i < gamesListModel.count; i++) {
        serviceItem = gamesListModel.get(i);

        if (serviceItem.secondStatus === "Started" || serviceItem.secondStatus === "Starting") {
            return serviceItem.serviceId;
        }
    }
}

function isAnySecondServiceRunning() {
    return _signalBusInst.isAnySecondServiceRunning;
}

function secondServiceStarted(service) {
    runningSecondService[service] = 1;
    _signalBusInst.isAnySecondServiceRunning = true;
}

function secondServiceFinished(service) {
    delete runningSecondService[service];
    _signalBusInst.isAnySecondServiceRunning = Object.keys(runningSecondService) > 0;
}

function installDate() {
    return settingsValue('qGNA', 'installDate', 0);
}

function setInstallDate() {
    setSettingsValue('qGNA', 'installDate', Math.floor((+ new Date()) / 1000));
}

function gameInstallDate(serviceId) {
    return settingsValue("GameDownloader/" + serviceId + "/", "installDate", "");
}

function gameLastExecutionTime(serviceId) {
    return settingsValue("gameExecutor/serviceInfo/" + serviceId + "/", "lastExecutionTime", "");
}
