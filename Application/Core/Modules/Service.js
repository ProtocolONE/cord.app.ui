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
    item.status = "Normal";
    item.statusText = "";
    item.menu = [];
    item.currentMenuIndex = 1;
    item.widgets = {};

    // External properties
    properties = [
                'gameId',
                'serviceId',
                'name',
                'gaName',
                'gameType',
                'genre',
                'imageSmall',
                'imageHorizontalSmall',
                'imageLogoSmall',
                'imagePopupArt',
                'maintenanceProposal1',
                'maintenanceProposal2',
                'logoText',
                'aboutGame',
                'miniToolTip',
                'shortDescription',
                'secondAllowed',
                'widgetList',
                'isPublishedInApp',
                'iconInApp',
                'typeShortcut',
                'sortPositionInApp',
                'hasOverlay',
                'socialNet'
            ];

    urlProps = [
                'forumUrl',
                'guideUrl',
                'blogUrl',
                'licenseUrl',
            ];

    Object.keys(properties).forEach(function(e){
        var prop = properties[e];
        if (data.hasOwnProperty(prop)) {
            item[prop] = data[prop];
        }
    });

    Object.keys(urlProps).forEach(function(e){
        var prop = urlProps[e];
        if (data.hasOwnProperty(prop)) {
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
