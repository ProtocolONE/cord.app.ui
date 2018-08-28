import QtQuick 2.4
import Tulip 1.0

import GameNet.Components.Widgets 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import Application.Core 1.0


PopupBase {
    id: root

    property variant currentItem: App.serviceItemByServiceId(model.lastStoppedServiceId);

    function setupButton(button, serviceId) {
        button.gameItem = App.serviceItemByServiceId(serviceId);
    }

    onCurrentItemChanged: {
        if (!root.currentItem) {
            return;
        }

        root.setupButton(button1, root.currentItem.maintenanceProposal1);
        root.setupButton(button2, root.currentItem.maintenanceProposal2);
    }

    width: internalContent.width + defaultMargins * 2
    title: qsTr("GAME_BORING_TITLE")
    clip: true

    Row {
        id: internalContent

        spacing: 20

        Image {
            source: installPath + "Assets/Images/Application/Widgets/GameIsBoring/gameIsBoring.png"
        }

        Column {
            spacing: 20

            Text {
                width: 400
                font {
                    family: 'Arial'
                    pixelSize: 14
                }
                color: defaultTextColor
                smooth: true
                wrapMode: Text.WordWrap
                text: qsTr("GAME_BORING_TIP").arg(root.currentItem ? root.currentItem.name : '')
            }

            Row {
                spacing: 20

                GameIsBoringButton {
                    id: button1
                    width: 187
                    height: 93
                    onClicked: {
                        Marketing.send(Marketing.NotLikeTheGame, root.currentItem.serviceId,
                                               { serviceId: button1.gameItem.serviceId });
                        root.close();
                    }
                }

                GameIsBoringButton {
                    id: button2
                    width: 187
                    height: 93
                    onClicked: {
                        Marketing.send(Marketing.NotLikeTheGame, root.currentItem.serviceId,
                                               { serviceId: button2.gameItem.serviceId });
                        root.close();
                    }
                }
            }

            Text {
                width: 400
                font {
                    family: 'Arial'
                    pixelSize: 14
                }
                color: defaultTextColor
                smooth: true
                wrapMode: Text.WordWrap
                text: qsTr("GAME_BORING_TIP_2")
            }
        }
    }

    MinorButton {
        width: 200
        text: qsTr("GAME_FAILED_BUTTON_CLOSE")
        analytics {
            category: 'GameIsBoring'
            label: 'Close'
        }
        onClicked: {
            Marketing.send(Marketing.NotLikeTheGame, root.currentItem.serviceId, { serviceId: 0 });
            root.close();
        }
    }
}
