.pragma library

var serviceIdToGameItemIdex = {},
    indexToGameItem = {},
    count = 0;

var gamenetGameItem = {
    imageLogoSmall: "images/games/gamenet_logo_small.png",
    name: "GameNet",
    serviceId: "0"
};

function initGameItemList(list)
{
    var i, item;
    count = list.count;
    for (i = 0; i < count; ++i) {
        item = list.get(i);
        indexToGameItem[i] = item;
        serviceIdToGameItemIdex[item.serviceId] = i;
    }
}

function serviceItemByIndex(index)
{
    return indexToGameItem[index];
}

function serviceItemByServiceId(serviceId)
{
    if (serviceId == 0) {
        return gamenetGameItem;
    }

    var index = indexByServiceId(serviceId)
    return index != undefined ? indexToGameItem[index] : undefined;
}

function indexByServiceId(serviceId)
{
    return serviceIdToGameItemIdex[serviceId];
}

