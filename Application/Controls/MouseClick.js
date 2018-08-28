// INFO походу этим не стоит пользоваться и никто и не пользуеся

.pragma library

var _widgetList = [];

function register(item, callback) {
    _widgetList.push({item: item, callback: callback});
}

function widgets() {
    return _widgetList;
}
