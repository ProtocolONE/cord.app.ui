import QtQuick 1.1
import QtWebKit 1.0
import Tulip 1.0

import "../restapi.js" as Api
import "../UserInfo.js" as UserInfo
import "../../Elements" as Elements
import "../../Proxy" as Proxy
import "../../Proxy/App.js" as App

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

    flags: Qt.Tool

    width: 800
    height: 550

    visible: true
    topMost: true

    title: qsTr("SUPPORT_HELP")
    onBeforeClosed: clearCookie();

    Timer {
        id: delayTimer

        /*
          HACK - нужно определять как-то активацию основного окна, и отличать её от клика по рабочей области приложения,
          лучшего решения пока не удалось найти.
        */

        interval: 5
        onTriggered: {
            if (mainWindowProxy.isLeftClick) {
                return;
            }

            window.activate();
            mainWindowProxy.isLeftClick = false;
        }
    }

    Proxy.MainWindowHelper {
        id: mainWindowProxy

        property bool isLeftClick: false

        onLeftMouseClick: isLeftClick = true;
        onWindowActivate: delayTimer.restart();
        onWindowDeactivate: isLeftClick = false;
    }

    WebView {
        id: view

        property variant _lastParent;

        function url() {
            return UserInfo.getUrlWithCookieAuth("http://www.gamenet.ru/support/qgna/" + itemName);
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

        newWindowParent: view
        newWindowComponent: Item {
            id: delegate

            WebView {
                id: self

                settings.pluginsEnabled: false
                settings.javascriptEnabled: false
                settings.autoLoadImages: false

                onUrlChanged: {
                    delegate.visible = false;
                    App.openExternalUrl(url)
                }
            }
        }

        Component.onCompleted: {
            clearCookie();

            if (view.hasOwnProperty('activateLinkClicked')
                && view.hasOwnProperty('linkClicked')) {
                view.activateLinkClicked = true;
                view.linkClicked.connect(function(url) {
                    App.openExternalUrl(url);
                });
            }
        }
    }

    Elements.WorkInProgress {
        anchors.fill: parent
        interval: 0
        state: view.progress !== 1 ? 'opened' : 'closed'
    }
}
