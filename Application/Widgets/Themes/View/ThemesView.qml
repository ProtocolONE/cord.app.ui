import Tulip 1.0
import QtQuick 1.1

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0

import "../../../Core/Styles.js" as Styles
import "../../../Core/moment.js" as Moment

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    width: 770
    height: 570

    Rectangle {
        anchors.fill: parent
        opacity: Styles.style.baseBackgroundOpacity
        color: Styles.style.contentBackgroundLight
    }

    ScrollArea {
        anchors{
            fill: parent
            topMargin: 10
            leftMargin: 10
        }

        GridView {
            id: view

            property variant lastClickedIndex

            width: parent.width
            interactive: false
            height: view.model
                    ? Math.ceil(view.model.count / 2) * cellHeight
                    : parent.height

            clip: true
            cellWidth: 380
            cellHeight: 210

            model: root.model.dataModel

            delegate: Theme {
                id: delegate

                onDownloadedChanged: {
                    if (view.lastClickedIndex == index) {
                        view.lastClickedIndex = -1;
                        delegate.install();
                    }
                }

                onClicked: {
                    if (delegate.downloaded) {
                        delegate.install();
                        GoogleAnalytics.trackEvent('/Themes', 'Install', model.name);
                    } else {
                        delegate.download();
                        view.lastClickedIndex = index;
                        GoogleAnalytics.trackEvent('/Themes', 'Download', model.name);
                    }
                }
            }
        }
    }
}
