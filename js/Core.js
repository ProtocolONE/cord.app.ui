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

function gameMaintenanceStart(serviceId) {
   _signalBusInst.gameMaintenanceStart(serviceId);
}

function gameMaintenanceEnd(serviceId) {
   _signalBusInst.gameMaintenanceEnd(serviceId);
}

var socialNetTable = {
    "300002010000000000":[//Aika
        {
            link: "http://www.youtube.com/user/GamenetAika",
            icon: "Assets/Images/socialNet/yt.png"
        },
        {
            link: "http://vk.com/aikaonlineru",
            icon: "Assets/Images/socialNet/vk.png"
        }
    ],
    "300003010000000000":[//BS
        {
            link: "http://www.youtube.com/bloodandsoulru",
            icon: "Assets/Images/socialNet/yt.png"
        },
        {
            link: "http://www.facebook.com/pages/Blood-Soul/201464389893835",
            icon: "Assets/Images/socialNet/fb.png"
        },
        {
            link: "http://vk.com/bloodandsoul",
            icon: "Assets/Images/socialNet/vk.png"
        }

    ],
    "300012010000000000":[ // Reborn
        {
            link: "https://www.facebook.com/pages/Reborn/397344480387678",
            icon: "Assets/Images/socialNet/fb.png"
        },
        {
            link: "https://vk.com/reborngame",
            icon: "Assets/Images/socialNet/vk.png"
        }

    ],
    "300005010000000000":[//FireStorm
        {
            link: "http://www.youtube.com/channel/UC6AbThTxwl1VhaLBvnkdiJg",
            icon: "Assets/Images/socialNet/yt.png"
        },
        {
            link: "http://vk.com/warinc",
            icon: "Assets/Images/socialNet/vk.png"
        }
    ],
    "300006010000000000":[//MW2
        {
            link: "http://vk.com/magicworld2",
            icon: "Assets/Images/socialNet/vk.png"
        }
    ],
    "300007010000000000":[//Golden Age
        {
            link: "https://vk.com/golden_age_game",
            icon: "Assets/Images/socialNet/vk.png"
        }
    ],
    "300009010000000000":[//Combat Arms
        {
            link: "http://www.youtube.com/user/CombatArmsRussia",
            icon: "Assets/Images/socialNet/yt.png"
        },
        {
            link: "https://www.facebook.com/pages/Combat-Arms-RU/465773090177989",
            icon: "Assets/Images/socialNet/fb.png"
        },
        {
            link: "http://www.odnoklassniki.ru/group/52003182084281",
            icon: "Assets/Images/socialNet/ok.png"
        },
        {
            link: "http://vk.com/ca_ru",
            icon: "Assets/Images/socialNet/vk.png"
        }
    ],
    "300004010000000000":[//Rot
        {
            link: "http://vk.com/rageoftitans",
            icon: "Assets/Images/socialNet/vk.png"
        },
    ]
}

var runningService = {},
    runningSecondService = {},
    isClientLoaded = false;

function getCurrentSocialTable() {
    var current = currentGame();
    if (!current) {
        return null;
    }

    return socialNetTable[current.serviceId];
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
