.pragma library

var _news = init();

function init() {
    var component = Qt.createComponent('News.qml');

    if (component.status != 1) {
        console.log('FATAL: error loading news component');
        return null;
    }

    var obj = component.createObject(null);
    if (!obj) {
        console.log('FATAL: error creating news');
        return null;
    }

    return obj;
}

function getNews() {
    return  _news.newsXml;
}
