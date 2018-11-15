.pragma library

var indexToGameItem = {},
    gameIdToGameItem = {},
    serviceIdToGameItemIdex = {},
    serviceStartButtonClicked = {},
    servicesGrid,
    _previousGame,
    runningService = {},
    sellItems = {};

//function createServiceOld(data, site) {
//    var item = {},
//        properties,
//        urlProps;

//    if (!data || !data.hasOwnProperty("serviceId")) {
//        return null;
//    }

//    // Internal item properties
//    item.maintenance = false;
//    item.maintenanceInterval = 0;
//    item.maintenanceSettings = {
//        "title": "",
//        "newsTitle": "",
//        "newsText": "",
//        "newsLink": "",
//        "isSticky": false
//    }

//    item.allreadyDownloaded = false;
//    item.progress = -1;
//    item.isInstalled = false;
//    item.status = "Normal";
//    item.statusText = "";
//    item.menu = [];
//    item.currentMenuIndex = 1;
//    item.widgets = {};
//    item.recheck = false;
//    item.firstDownload = false;

//    // External item properties
//    item.gameId = data.gameId || 0;
//    item.serviceId = data.serviceId || '';
//    item.name = data.name || '';
//    item.gaName = data.gaName || '';
//    item.gameType = data.gameType || '';
//    item.genre = data.genre || '';
//    item.imageSmall = data.imageSmall || '';
//    item.imageHorizontalSmall = data.imageHorizontalSmall || '';
//    item.imageLogoSmall = data.imageLogoSmall || '';
//    item.imagePopupArt = data.imagePopupArt || '';
//    item.maintenanceProposal1 = data.maintenanceProposal1 || '';
//    item.maintenanceProposal2 = data.maintenanceProposal2 || '';
//    item.logoText = data.logoText || '';
//    item.aboutGame = data.aboutGame || '';
//    item.miniToolTip = data.miniToolTip || '';
//    item.shortDescription = data.shortDescription || '';
//    item.secondAllowed = !!data.secondAllowed;
//    item.widgetList = data.widgetList || '';
//    item.isPublishedInApp = !!data.isPublishedInApp;
//    item.iconInApp = data.iconInApp || '';
//    item.typeShortcut = data.typeShortcut || '';
//    item.sortPositionInApp = data.sortPositionInApp || 0;
//    item.genrePosition = parseInt(data.genrePosition) | 0;
//    item.hasOverlay = !!data.hasOverlay;
//    item.socialNet = data.socialNet || '';
//    item.isRunnable = !!data.isRunnable;
//    item.backgroundInApp = data.backgroundInApp || '';

//    // standalone properties
//    item.isStandalone = !!data.isStandalone;
//    item.isClosedBeta = !!data.isClosedBeta;

//    urlProps = [
//        'mainUrl',
//        'guideUrl',
//        //'blogUrl',
//        'licenseUrl',
//    ];

//    Object.keys(urlProps).forEach(function(e){
//        var prop = urlProps[e], propValue;
//        if (data.hasOwnProperty(prop) && !!data[prop]) {
//            propValue = '' + data[prop];
//            item[prop] = (propValue.indexOf('//') != -1) ? propValue
//                                                         : site(propValue);
//        } else {
//            item[prop] = '';
//        }
//    });

//    try {
//        item.widgets = JSON.parse('{' + item.widgetList + '}');
//    } catch(e) {
//        item.widgets = {};
//    }

//    return item;
//}

function createService(data, site) {
    var item = {},
        properties,
        urlProps;

    if (!data || !data.hasOwnProperty("game") || !data.game.hasOwnProperty("id")) {
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
    item.gameId = data.game.id || 0; // UNDONE remove gameId
    item.serviceId = data.game.id || ''; // UNDONE rename
    item.name = data.game.name || '';
    item.gaName = data.game.alias || ''; // UNDONE may be different options

    //item.gameType = data.gameType || '';
    item.gameType ='standalone'

    item.genre = data.game.genre.name || '';

    item.imageSmall = data.imageSmall || '';
    item.imageHorizontalSmall = data.imageHorizontalSmall || '';
    item.imageLogoSmall = data.imageLogoSmall || '';
    item.imagePopupArt = data.imagePopupArt || '';

    item.maintenanceProposal1 = ''
    item.maintenanceProposal2 = ''

    if (!!data.maintenanceProposal1 && !!data.maintenanceProposal1.id)
        item.maintenanceProposal1 = data.maintenanceProposal1.id;

    if (!!data.maintenanceProposal2 && !!data.maintenanceProposal2.id)
        item.maintenanceProposal2 = data.maintenanceProposal2.id;

    item.logoText = data.logoText || '';
    item.aboutGame = data.aboutGame || '';
    item.miniToolTip = data.miniToolTip || '';
    item.shortDescription = data.shortDescription || '';
    item.secondAllowed = !!data.secondAllowed;

    //item.widgetList = data.widgetList || '';
    item.widgetList = '"gameDownloading":"GameAdBanner","gameStarting":"GameAdBanner"';

    //item.isPublishedInApp = !!data.isPublishedInApp;  // UNDONE
    item.isPublishedInApp = true


    item.iconInApp = data.game.iconInApp || '';
    item.typeShortcut = data.game.shortcut.alias || '';
    item.sortPositionInApp = data.sortPriority || 0;
    item.genrePosition = 0; //parseInt(data.genrePosition) | 0; // UNDONE
    item.hasOverlay = false // !!data.hasOverlay; // INFO removed
    item.socialNet = (data.game.socialGroups || []).map(function(e) {
        return {
            id: e.socialNetwork.alias,
            link: e.url
        };
    });

    item.isRunnable = true // !!data.isRunnable;  // UNDONE
    item.backgroundInApp = data.backgroundInApp || '';

    // standalone properties
    item.isStandalone = false // !!data.isStandalone; // UNDONE removed
    item.isClosedBeta = false // !!data.isClosedBeta; // UNDONE removed

    if (!!data.game.forumUrl) {
        item.forumUrl = data.game.forumUrl;
    }

    if (!!data.game.officialSite) {
        item.mainUrl = data.game.officialSite;

        // UNDONE
        item.licenseUrl = data.game.officialSite;
    }

//    urlProps = [
//        'mainUrl',
//        'guideUrl',
//        //'blogUrl',
//        'licenseUrl',
//    ];

//    Object.keys(urlProps).forEach(function(e){
//        var prop = urlProps[e], propValue;
//        if (data.hasOwnProperty(prop) && !!data[prop]) {
//            propValue = '' + data[prop];
//            item[prop] = (propValue.indexOf('//') != -1) ? propValue
//                                                         : site(propValue);
//        } else {
//            item[prop] = '';
//        }
//    });

    try {
        item.widgets = JSON.parse('{' + item.widgetList + '}');
    } catch(e) {
        item.widgets = {};
    }

    return item;
}




