.pragma library
/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

var indexToGameItem = {},
    gameIdToGameItem = {},
    serviceIdToGameItemIdex = {},
    serviceStartButtonClicked = {},
    servicesGrid,
    _previousGame,
    runningService = {};

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
    item.allreadyDownloaded = false;
    item.progress = -1;
    item.isInstalled = false;
    item.status = "Normal";
    item.statusText = "";
    item.menu = [];
    item.currentMenuIndex = 1;
    item.widgets = {};

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
    item.hasPremiumServer = false;

    if (item.gameId == 1021) {
        //HACK Use this hack due have just one game (BlackDesert) with that feature.
        if (Date.now() > 1451480400000) {
            item.hasPremiumServer = true;
        }
    }

    urlProps = [
        'guideUrl',
        //'blogUrl', // https://jira.gamenet.ru:8443/browse/QGNA-1264
        'licenseUrl',
    ];

    Object.keys(urlProps).forEach(function(e){
        var prop = urlProps[e];
        if (data.hasOwnProperty(prop) && !!data[prop]) {
            item[prop] = 'https://gamenet.ru' + data[prop];
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

