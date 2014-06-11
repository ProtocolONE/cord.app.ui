.pragma library
Qt.include("../Proxy/Settings.js")

var _signalBusComponent,
    _signalBusInst,
    _progressComponent,
    _progress;

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

function getCurrentSocialTable() {
    var current = currentGame();
    if (!current) {
        return null;
    }

    return socialNetTable[current.serviceId];
}
