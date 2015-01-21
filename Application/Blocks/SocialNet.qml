/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/App.js" as App
import "../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    property variant gameItem: App.currentGame()

    width: 300
    height: 24

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
        orientation: ListView.Horizontal
        interactive: false
        layoutDirection: Qt.LeftToRight
        model: gameItem ? gameItem.socialNet : undefined
        delegate: Item {
            id: delegate

            width: visible ? image.width : -view.spacing
            height: visible ? image.height : 0

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

                        GoogleAnalytics.trackEvent('/game/' + root.gameItem.gaName,
                                                   'SocialNet',
                                                   'Open link ' + link);
                    }
                }
            }
        }
    }
}
