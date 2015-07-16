import QtQuick 2.4
import Tulip 1.0

Image {
    id: root

    function getSourceIcon() {
        var browser = BrowserDetect.getBrowserName();
        if (browser.indexOf('chrome') !== -1) {
            browser = 'chrome';
        }

        if (browser.indexOf('opera') !== -1) {
            browser = 'opera';
        }

        if (browser.indexOf('launcher') !== -1) {
            browser = 'opera';
        }

        if (browser.indexOf('yandex') !== -1) {
            browser = 'yandex';
        }

        var browserIcons = {
            "firefox": "ff.png",
            "iexplore": "ie.png",
            "opera": "opera.png",
            "chrome": "chrome.png",
            "yandex": "yandex.png"
        }

        return installPath + 'Assets/Images/Application/Widgets/AllGames/browsers/' +
                (browserIcons[browser] || 'unknown.png');
    }

    anchors {
        right: parent.right
        top: parent.top
        margins: 4
    }

    cache: false
    source: root.visible ? root.getSourceIcon() : ''
}
