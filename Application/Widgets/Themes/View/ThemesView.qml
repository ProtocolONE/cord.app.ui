import Tulip 1.0
import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0

WidgetView {
    id: root

    width: 770
    height: 570

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
                        Ga.trackEvent('Themes', 'Install', model.name);
                    } else {
                        delegate.download();
                        view.lastClickedIndex = index;
                        Ga.trackEvent('Themes', 'Download', model.name);
                    }
                }
            }
        }
    }


}
