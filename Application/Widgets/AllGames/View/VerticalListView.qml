import QtQuick 2.4

import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0

import "Private" as Private

WidgetView {
    id: root

    implicitWidth: parent.width
    implicitHeight: parent.height

    Component.onCompleted: d.fillGrid();

    QtObject {
        id: d

        function fillGrid() {
            listView.model = App.getRegisteredServices();
        }
    }

    ContentBackground {
        color: Styles.contentBackgroundDark
    }

    Text {
        anchors {
            left: parent.left
            top: parent.top
            margins: 6

        }

        text: qsTr("Games:")

        color: Styles.mainMenuText
        font { family: "Arial"; pixelSize: 16 }
    }

    ListView {
        id: listView

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 30
            leftMargin: 6
        }

        height: parent.height - 30
        interactive: true

        spacing: 10

        orientation: ListView.Vertical

        delegate: Rectangle {
            id: serviceItem

            property string serviceId: listView.model[index]
            property variant serviceItem: App.serviceItemByServiceId(serviceItem.serviceId)

            width: parent.width
            height: 48

            color: Styles.contentBackgroundDark

            Row {
                width: parent.width
                height: parent.height
                spacing: 10

                Item {
                    height: 48
                    width: height

                    Image {
                        anchors.fill: parent
                        source: serviceItem.serviceItem.imageSmall || ''
                        visible: !!source
                    }
                }

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }

                    text: serviceItem.serviceItem.name

                    color: Styles.mainMenuText
                    font { family: "Arial"; pixelSize: 16 }
                }
            }


            CursorMouseArea {
                id: mouseArea

                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    App.activateGameByServiceId(serviceItem.serviceId);
                    SignalBus.navigate('mygame', 'GameItem');
                }
            }

        }
    }

    VerticalSplit {
        height: parent.height
        anchors.right: parent.right
    }
}
