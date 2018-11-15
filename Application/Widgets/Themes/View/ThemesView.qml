import Tulip 1.0
import QtQuick 2.4

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0

import Application.Core.Styles 1.0

WidgetView {
    id: root

    anchors.fill: parent

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

    AuxiliaryButton {
        visible: App.isSingleGameMode()
        text: qsTr("Close")
        height: 30

        anchors {
            right: parent.right
            rightMargin: 20
            bottom: parent.bottom
            bottomMargin: 20
        }

        onClicked: {
            SignalBus.navigate("mygame", "");
        }
    }
}
