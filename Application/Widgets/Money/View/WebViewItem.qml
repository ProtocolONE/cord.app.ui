import QtQuick 2.4
import QtWebKit 1.0
import GameNet.Controls 1.0
import Tulip 1.0

Item {
    id: componentRoot

    property variant tabInstance
    property alias newWindowParent: webView.newWindowParent
    property alias url: webView.url
    property alias html: webView.html
    property alias title: webView.title
    property alias progress: webView.progress
    property alias icon: webView.icon
    signal paymentResponse(int amount);

    function refresh() {
        webView.reload.trigger();
    }

    onProgressChanged: if (tabInstance) tabInstance.progress = progress;

    OldTinyScrollbar {
        id: scrollBar

        height: componentRoot.height
        width: webView.width
        anchors { left: componentRoot.right; top: componentRoot.top; leftMargin: -width }
        visible: true
        flickable: menuBarContent
        z: 1
    }

    OldScrollBar {
        id: scrollBarView

        height: componentRoot.height
        //width: webView.width
        anchors { left: componentRoot.right; top: componentRoot.top; leftMargin: -width }
        visible: true
        flickable: menuBarContent
        baseRect {
            opacity: 0.75
            color: '#c0c0c0'
        }
        z: 1
    }

    Flickable {
        id: menuBarContent

        clip: true

        anchors { fill: parent }

        contentHeight: webView.height
        contentWidth: webView.width
        interactive: false

        WebView {
            id: webView

            preferredWidth: menuBarContent.width
            preferredHeight: menuBarContent.height
            scale: 1
            smooth: false
            pressGrabTime: 0

            settings.pluginsEnabled: false
            settings.javascriptCanAccessClipboard: true
            settings.localContentCanAccessRemoteUrls: true
            settings.developerExtrasEnabled: true

            onTitleChanged: {
                if (tabInstance) {
                    tabInstance.title = title;
                }
            }

            javaScriptWindowObjects: QtObject {
                WebView.windowObjectName: "overlay"

                function paymentResponse(amount) {
                    componentRoot.paymentResponse(amount);
                }
            }

            newWindowParent: rootRect
            newWindowComponent: webViewItem


            // Disable context menu hack
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
            }
        }
    }
}
