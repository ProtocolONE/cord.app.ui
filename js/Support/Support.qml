import QtQuick 1.1
import QtWebKit 1.0
import Tulip 1.0

import "../restapi.js" as Api
import "../userInfo.js" as UserInfo
import "../../Elements" as Elements

Window {
    id: window

    property string itemName: '';

    signal closeRequest();

    x: (Desktop.primaryScreenAvailableGeometry.width  - width) / 2 + 50
    y: (Desktop.primaryScreenAvailableGeometry.height - height) / 2 - 50

    deleteOnClose: true

    flags: Qt.Tool | Qt.WindowStaysOnTopHint

    width: 800
    height: 400

    visible: true
    topMost: true

    title: qsTr("SUPPORT_HELP")

    function clearCookie() {
        WebViewHelper.setCookiesFromUrl('', 'http://www.gamenet.ru')
        WebViewHelper.setCookiesFromUrl('', 'http://gamenet.ru')
        WebViewHelper.setCookiesFromUrl('', 'https://gnlogin.ru')
    }

    onBeforeClosed: clearCookie();

    WebView {
        id: view

        function url() {
            return UserInfo.getUrlWithCookieAuth("http://www.gamenet.ru/support/qgna/" + itemName);
        }

        anchors.fill: parent
        preferredWidth: 800
        preferredHeight: 400
        scale: 1
        smooth: false

        settings.pluginsEnabled: false
        settings.javascriptCanOpenWindows: true
        settings.javascriptCanAccessClipboard: true
        settings.localContentCanAccessRemoteUrls: true

        html: "<html><head><script type='text/javascript'>window.location='" + url() + "';</script></head><body></body></html>"

        Component.onCompleted: clearCookie();

        Elements.WorkInProgress {
            anchors.fill: parent
            interval: 0
            state: view.progress !== 1 ? 'opened' : 'closed'
        }
    }
}
