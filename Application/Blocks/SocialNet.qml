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
        spacing: 5
        orientation: ListView.Horizontal
        layoutDirection: Qt.LeftToRight
        model: gameItem ? gameItem.socialNet : null

        delegate: Image {
            function iconUrl(id) {
                if (id === 'fb') {
                    return installPath + "Assets/Images/socialNet/fb.png";
                }

                if (id === 'vk') {
                    return  installPath + "Assets/Images/socialNet/vk.png";
                }

                if (id === 'yt') {
                    return installPath + "Assets/Images/socialNet/yt.png";
                }

                if (id === 'ok') {
                    return installPath + "Assets/Images/socialNet/ok.png";
                }

                return '';
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
