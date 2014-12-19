.pragma library

function createService(data) {
    var item;

    if (!data || !data.hasOwnProperty("serviceId")) {
        return null;
    }

    item = data[i];

    item.maintenance = false;
    item.maintenanceInterval = 0;
    item.allreadyDownloaded = false;
    item.progress = -1;
    item.status = "Normal";
    item.statusText = "";
    item.menu = [];
    item.currentMenuIndex = 1;
    item.widgets = {};

    try {
        item.widgets = JSON.parse(item.widgetList);
    } catch(e) {
        item.widgets = {};
    }

    return item;
}
