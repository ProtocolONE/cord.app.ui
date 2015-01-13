.pragma library

function createService(data) {
    var item = {},
        properties;

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
                'forumUrl',
                'guideUrl',
                'blogUrl',
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

    Object.keys(properties).forEach(function(e){
        var prop = properties[e];
        if (data.hasOwnProperty(prop)) {
            item[prop] = data[prop];
        }
    });

    try {
        item.widgets = JSON.parse('{' + item.widgetList + '}');
    } catch(e) {
        item.widgets = {};
    }

    return item;
}
