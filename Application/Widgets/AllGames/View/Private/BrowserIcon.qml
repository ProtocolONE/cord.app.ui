import QtQuick 1.1
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

        var browserIcons = {
            "firefox": "ff.png",
            "iexplore": "ie.png",
            "opera": "opera.png",
            "chrome": "chrome.png"
        }

        return installPath + 'Assets/Images/Application/Widgets/AllGames/browsers/' +
                (browserIcons[browser] || 'unknown.png');
    }

    anchors {
        right: parent.right
        top: parent.top
        margins: 4
    }

    source: root.visible ? root.getSourceIcon() : ''
}
