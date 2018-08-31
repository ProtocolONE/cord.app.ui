import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0

Item {
    id: root

    property variant gameItem: App.currentGame()

    implicitWidth: 24
    implicitHeight: 300

    onVisibleChanged: {
        if (!visible) {
            view.opacity = 0;
        } else {
            switchAnim.start();
        }
    }

    SequentialAnimation {
        id: switchAnim

        NumberAnimation { target: view; property: "opacity"; from: 0; to: 1; duration: 350 }
    }

    ListView {
        id: view

        anchors.fill: parent
        spacing: 4
        orientation: ListView.Vertical
        interactive: false
        layoutDirection: Qt.LeftToRight
        model: gameItem ? gameItem.socialNet : undefined
        delegate: Item {
            id: delegate

            width: visible ? image.width : 0
            height: visible ? image.height : -view.spacing

            visible: !!model.link

            Image {
                id: image

                function iconUrl(id) {
                    var socialIcons = {
                        'fb' : 'fb.png',
                        'vk' : 'vk.png',
                        'yt' : 'yt.png',
                        'ok' : 'ok.png',
                        'gp' : 'gp.png',
                        'tw' : 'tw.png',
                        'mm' : 'mm.png'
                    }

                    return socialIcons.hasOwnProperty(id)?
                                (installPath + "Assets/Images/socialNet/" + socialIcons[id]) : ''
                }

                opacity: mouser.containsMouse ? 1 : 0.8
                source : iconUrl(model.id)

                Behavior on opacity {
                    NumberAnimation { duration: 250 }
                }

                CursorMouseArea {
                    id: mouser

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        App.openExternalUrl(link);

                        var nameMap = {
                            'fb' : 'facebook',
                            'vk' : 'vkontakte',
                            'yt' : 'youtube',
                            'ok' : 'odnoklassniki',
                            'gp' : 'google plus',
                            'tw' : 'twitter',
                            'mm' : 'moy mir'
                        };

                        Ga.trackSocial('outer link', nameMap[id], link);
                    }
                }
            }
        }
    }
}
