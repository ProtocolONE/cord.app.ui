/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2017, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import GameNet.Core 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

PopupBase {
    id: root

    property bool isLicenseRead : false
    property string licenseText : ""
    property string licenseIdForBDO : "390"

    property bool resultSended : false

    property bool hasGuildConflict : false
    property bool inProgress: false
    property string conflictMessage: ""

    width: App.clientWidth - 100
    height: App.clientHeight - 70

    title: qsTr("Перенос персонажей с Премиум-сервера")
    clip: true

    function licenseResponse(response) {
        if (!!!response
            || !response.hasOwnProperty("license")
            || !!!response.license
            || !response.license.hasOwnProperty("text")
            || !!!response.license.text) {
            root.skipLicenseClick();
            return;
        }

       root.licenseText = response.license.text;
    }

    function acceptLicenseClick() {
        if (root.resultSended) {
            return;
        }

        root.inProgress = true;
        RestApi.Core.execute('user.getChars', {
                         targetId: User.userId(),
                         gameId: "1021",
                         z: Math.random()
                     },
                     true, root.checkGuildCharsResponse, root.checkGuildCharsResponse);
    }

    function checkGuildCharsResponse(response) {
        root.inProgress = false;
        root.conflictMessage = qsTr("Произошла ошибка. Попробуйте позже или обратитесь в службу поддержки.");

        if (!!!response || !Array.isArray(response)) {
            console.log('Wrong char response');
            root.hasGuildConflict = true;
            return;
        }

        var charIndex = Lodash._.findIndex(response, function(e) {
            return e.gameId == "1021"
                && e.serverId == "10077" // P2P server
                && !!e.guildId;
        });

        var canTransfer = (charIndex == -1);
        try {
            if (!canTransfer) {
                var c = response[charIndex];
                console.log('Transfer declined. You have char "' + (c.name || "Unknown")
                            + '" in guild "' + (c.guildName || "Unknown") + '"');
                root.conflictMessage = qsTr('Для участия в трансфере необходимо покинуть гильдию на Премиум сервере.\n\nПерсонаж "%1", гильдия "%2".\n\nПерезапустите игру через 2 часа после выхода из гильдии и примите предложении о переносе персонажей.')
                    .arg((c.name || "Неизвестно")).arg((c.guildName || "Неизвестно"))
            }
        } catch(e) {
        }

        root.hasGuildConflict = !canTransfer;

        if (canTransfer) {
            root.resultSended = true;
            root.model.acceptLicenseClick();
            root.close();
        }
    }

    function rejectLicenseClick() {
        if (root.resultSended) {
            return;
        }

        root.resultSended = true;
        root.model.rejectLicenseClick();
        root.close();
    }

    function skipLicenseClick() {
        if (root.resultSended) {
            return;
        }

        root.resultSended = true;
        root.model.skipLicenseClick();
    }

    onClose: {
        root.skipLicenseClick();
    }

    Component.onCompleted: {
        RestApi.Core.execute('service.getLicense',
                             {
                                 serviceId: "30000000000",
                                 requiredLicenseId: root.licenseIdForBDO,
                                 type: "html"
                             },
                             false, root.licenseResponse, function(err) {
                                 root.close();
                             });

    }

    Column {
        width: parent.width
        height: 340
        spacing: 10

        Text {
            visible: !root.hasGuildConflict
            font {
                family: 'Arial'
                pixelSize: 14
            }

            width: parent.width
            color: defaultTextColor
            smooth: true
            wrapMode: Text.WordWrap
            text: qsTr("Предлагаем вам перенести своих персонажей с Премиум-сервера и присоединиться к боевым товарищам на Эллиане. Перенос осуществляется на весьма выгодных и практичных условиях, которые мы, собственно, и приводим для ознакомления ниже. Если вы согласны с ними, нажмите \"Принять\", и мы примем вашу заявку на перенос.")
        }

        Rectangle {
            id: lisenceContainer

            width: parent.width
            height: 280
            visible: !root.hasGuildConflict

            ScrollArea {
                anchors.fill: parent
                scrollbarWidth: 10
                allwaysShown: true

                onYPositionChanged: {
                    if (!root.isLicenseRead) {
                        if (yPosition + heightRatio > 0.95) {
                            root.isLicenseRead = true;
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: lisenceText.height + 40

                    Text {
                        id: lisenceText

                        x: 20
                        y: 20
                        width: parent.width - 40

                        font {
                            family: "Arial"
                            pixelSize: 16
                        }

                        onLinkActivated: App.openExternalUrl(link)
                        textFormat: Text.RichText
                        wrapMode: Text.Wrap
                        text: root.licenseText
                    }
                }
            }
        }

        Text {
            visible: root.hasGuildConflict
            font {
                family: 'Arial'
                pixelSize: 14
            }

            width: parent.width
            color: defaultTextColor
            smooth: true
            wrapMode: Text.WordWrap
            text: root.conflictMessage
        }
    }

    PopupHorizontalSplit {}

    Item {
        width: parent.width
        height: 50

        Row {
            spacing: 10
            layoutDirection: Qt.RightToLeft
            anchors.fill: parent

            TextButton {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Пропустить")
                onClicked: root.close();

                enabled: !root.inProgress
            }

            MinorButton {
                inProgress: root.inProgress

                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Отмена")
                onClicked: root.rejectLicenseClick();
                visible: !root.hasGuildConflict
            }

            PrimaryButton {
                inProgress: root.inProgress

                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Принять")
                enabled: root.isLicenseRead
                visible: !root.hasGuildConflict
                onClicked: root.acceptLicenseClick()
            }
        }
    }
}
