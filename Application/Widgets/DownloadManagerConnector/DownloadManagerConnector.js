.pragma library

var StartType = {
  'Unknown'     : -1,
  'Normal'      : 0,
  'Force'       : 1,
  'Recheck'     : 2, // Заставили перепроверить клиент из настроек
  'Shadow'      : 3,
  'Uninstall'   : 4
};

var accessHolder = {};

function setHasNoAccess(serviceId) {
  accessHolder[serviceId] = false;
}

function hasAcces(serviceId) {
  var index = accessHolder[serviceId];
  return index != undefined ? accessHolder[index] : true;
}

function resetAccess(serviceId) {
  accessHolder[serviceId] = true;
}
