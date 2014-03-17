import QtQuick 1.1
import Tulip 1.0

import "GameMenu"

Item {
    id: root

    property alias model: view.model
    property alias flickable: view
    property alias currentIndex: view.currentIndex

    signal urlClicked(string url);
    signal pageClicked(string page);

    implicitWidth: 200
    implicitHeight: 600

    ListView {
        id: view

        boundsBehavior: Flickable.StopAtBounds
        anchors.fill: parent
        interactive: true
        maximumFlickVelocity: 1450
        delegate: menuDelegate
    }

    Component {
        id: menuDelegate

        GameMenuItem {
            onClicked: {
                if (model.link) {
                    root.urlClicked(model.url)
                } else {
                    view.currentIndex = index;
                    root.pageClicked(model.page);
                }
            }

            current: ListView.isCurrentItem
            icon: installPath + model.icon
            externalLink: model.link
            text: model.text
        }
    }

}

