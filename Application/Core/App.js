.pragma library

Qt.include('Config.js');

var indexToGameItem = {},
    gameIdToGameItem = {},
    serviceIdToGameItemIdex = {},
    serviceStartButtonClicked = {},
    servicesGrid,
    _previousGame,
    runningService = {},
    sellItems = {};

function createService(data) {
    var item = {},
        properties,
        urlProps;

    if (!data || !data.hasOwnProperty("serviceId")) {
        return null;
    }

    // Internal item properties
    item.maintenance = false;
    item.maintenanceInterval = 0;
    item.maintenanceSettings = {
        "title": "",
        "newsTitle": "",
        "newsText": "",
        "newsLink": "",
        "isSticky": false
    }

    item.allreadyDownloaded = false;
    item.progress = -1;
    item.isInstalled = false;
    item.status = "Normal";
    item.statusText = "";
    item.menu = [];
    item.currentMenuIndex = 1;
    item.widgets = {};
    item.recheck = false;
    item.firstDownload = false;

    // External item properties
    item.gameId = data.gameId || 0;
    item.serviceId = data.serviceId || '';
    item.name = data.name || '';
    item.gaName = data.gaName || '';
    item.gameType = data.gameType || '';
    item.genre = data.genre || '';
    item.imageSmall = data.imageSmall || '';
    item.imageHorizontalSmall = data.imageHorizontalSmall || '';
    item.imageLogoSmall = data.imageLogoSmall || '';
    item.imagePopupArt = data.imagePopupArt || '';
    item.maintenanceProposal1 = data.maintenanceProposal1 || '';
    item.maintenanceProposal2 = data.maintenanceProposal2 || '';
    item.logoText = data.logoText || '';
    item.aboutGame = data.aboutGame || '';
    item.miniToolTip = data.miniToolTip || '';
    item.shortDescription = data.shortDescription || '';
    item.secondAllowed = !!data.secondAllowed;
    item.widgetList = data.widgetList || '';
    item.isPublishedInApp = !!data.isPublishedInApp;
    item.iconInApp = data.iconInApp || '';
    item.typeShortcut = data.typeShortcut || '';
    item.sortPositionInApp = data.sortPositionInApp || 0;
    item.genrePosition = parseInt(data.genrePosition) | 0;
    item.hasOverlay = !!data.hasOverlay;
    item.socialNet = data.socialNet || '';
    item.isRunnable = !!data.isRunnable;
    item.backgroundInApp = data.backgroundInApp || '';

    // standalone properties
    item.isStandalone = !!data.isStandalone;
    item.isClosedBeta = !!data.isClosedBeta;

    urlProps = [
        'mainUrl',
        'guideUrl',
        //'blogUrl', // https://jira.gamenet.ru:8443/browse/QGNA-1264
        'licenseUrl',
    ];

    Object.keys(urlProps).forEach(function(e){
        var prop = urlProps[e], propValue;
        if (data.hasOwnProperty(prop) && !!data[prop]) {
            propValue = '' + data[prop];
            item[prop] = (propValue.indexOf('//') != -1) ? propValue
                                                         : GnUrl.site(propValue);
        } else {
            item[prop] = '';
        }
    });

    try {
        item.widgets = JSON.parse('{' + item.widgetList + '}');
    } catch(e) {
        item.widgets = {};
    }

    return item;
}


function openSupportUrl(returnPath) {
    //id=10 это хардкоженная переменная, которую можно получить только после
    //установки плагина авторизации GameNet в DeskPro.

    var uri = 'https://gnlogin.ru/integrations/deskpro/?id=10';
    if (returnPath) {
        uri += '&return=' + encodeURIComponent(returnPath);
    }

    openExternalUrlWithAuth(uri);
}

