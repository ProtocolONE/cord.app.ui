.pragma library

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
    item.gameId = data.gameId || '';
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
    item.sortPositionInApp = data.sortPositionInApp || '0';
    item.genrePosition = parseInt(data.genrePosition) | 0;
    item.hasOverlay = !!data.hasOverlay;
    item.socialNet = data.socialNet || '';
    item.isRunnable = !!data.isRunnable;
    item.backgroundInApp = data.backgroundInApp || '';

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
