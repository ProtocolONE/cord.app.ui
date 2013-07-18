.pragma library

var _news = null;
var _objects  = [];

function getNews() {
    return _news ? _news.newsXml : '';
}

function setNews(news) {
    _news = news;
    _news.newsObtained.connect(function() {
        _objects.forEach(function(e){
            e.updateNews();
        });
    });
}

function timerReload() {
    return _news ? _news.timerReload : false;
}

function setTimerReload(timerReload) {
    if (_news) {
        _news.timerReload = timerReload;
    }
}

function subscribe(obj) {
    _objects.push(obj);
}
