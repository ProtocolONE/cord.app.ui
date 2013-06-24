import QtQuick 1.1
import QtWebKit 1.0
import Tulip 1.0

import "../restapi.js" as Api
import "../UserInfo.js" as UserInfo
import "../../Elements" as Elements

Window {
    id: window

    property string itemName: '';

    signal closeRequest();

    function clearCookie() {
        WebViewHelper.setCookiesFromUrl('', 'http://www.gamenet.ru')
        WebViewHelper.setCookiesFromUrl('', 'http://gamenet.ru')
        WebViewHelper.setCookiesFromUrl('', 'https://gnlogin.ru')
    }

    x: (Desktop.primaryScreenAvailableGeometry.width  - width) / 2 + 50
    y: (Desktop.primaryScreenAvailableGeometry.height - height) / 2 - 50

    deleteOnClose: true

    flags: Qt.Tool | Qt.WindowStaysOnTopHint

    width: 800
    height: 550

    visible: true
    topMost: true

    title: qsTr("SUPPORT_HELP")
    onBeforeClosed: clearCookie();

    WebView {
        id: view

        property variant _lastParent;

        function url() {
            return UserInfo.getUrlWithCookieAuth("http://www.gamenet.ru/support/qgna/" + itemName);
        }

        function updateNewWindowParent() {
            if (view._lastParent) {
                view._lastParent.destroy();
            }

            view._lastParent = _newParentHack.createObject(null);
            view._lastParent.parent = view;

            view.newWindowParent = view._lastParent;
        }

        anchors.fill: parent
        preferredWidth: 800
        preferredHeight: 550
        scale: 1
        smooth: false
        pressGrabTime: 0

        settings.pluginsEnabled: false
        settings.javascriptCanOpenWindows: true
        settings.javascriptCanAccessClipboard: true
        settings.localContentCanAccessRemoteUrls: true

        html: "<html><head><script type='text/javascript'>window.location='" + url() + "';</script></head><body></body></html>"

        newWindowComponent: Item {
            WebView {
                id: self

                settings.pluginsEnabled: false
                settings.javascriptEnabled: false
                settings.autoLoadImages: false

                onUrlChanged: {
                    Qt.openUrlExternally(url);
                    self.stop.trigger();
                    view.updateNewWindowParent();
                }
            }
        }

        Component.onCompleted: {
            clearCookie();
            updateNewWindowParent();
        }

        Component {
           id: _newParentHack

           Item {}
        }

        Elements.WorkInProgress {
            anchors.fill: parent
            interval: 0
            state: view.progress !== 1 ? 'opened' : 'closed'
        }
    }
}
