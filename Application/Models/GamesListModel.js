.pragma library

var gamesListModel = initModel(),
    _gamesListModelList;
//    _previousGame = gamesListModel.currentGameItem

function initModel() {
    var component = Qt.createComponent('GamesListModel.qml');

    if (component.status != 1) {
        console.log('FATAL: error loading model:', component.errorString());
        return null;
    }

    _gamesListModelList = component.createObject(null);
    if (!_gamesListModelList) {
        console.log('FATAL: error creating model');
        return null;
    }

    return _gamesListModelList;
}
