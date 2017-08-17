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
import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0
import Application.Core.MessageBox 1.0

Item {
    id: root

    function save() {
    }

    function load() {
        blacklistModel.clear();
        RestApi.User.getIgnoreList(d.getIgnoreListCallback, d.getIgnoreListCallback);
    }

    function reset() {
        load();
    }

    function setMarketingsParams(params) {
        return params;
    }

    QtObject {
        id: d

        property int rowHeight: 40

        function getIgnoreListCallback(res) {
            if (!Array.isArray(res)) {
                return;
            }

            res.map(d.formatItem).forEach(function(i) {
                    blacklistModel.append(i);
            });
        }

        function formatItem(item) {
            return {
                userId: (item.id || "") + "",
                avatar: item.avatarSmall || "",
                nickname: item.nickname || ""
            }
        }

        function unblockUser(userId, index) {
            blacklistModel.remove(index);

            var messengerWidget = WidgetManager.getWidgetByName("Messenger")

            if (!!messengerWidget && !!messengerWidget.model) {
                var messenger = messengerWidget.model.signalBus();
                messenger.unblockUser( {jid: messenger.userIdToJid(userId)});
            }
        }
    }

    ScrollArea {
        allwaysShown: true
        anchors {
            fill: parent
            bottomMargin: 62
        }

        Column {
            spacing: 20

            width: parent.width - 50

            SettingsCaption {
                text: qsTr("Черный список")
                font.pixelSize: 14
            }

            ListView {
                id: blacklistView

                clip: true
                width: parent.width
                height: count > 0 ? count * 40 : 40

                model: ListModel {
                    id: blacklistModel
                }

                delegate: Item {
                    id: blackListItemComponentRoot

                    width: parent.width
                    height: d.rowHeight

                    Row {
                        anchors.fill: parent
                        spacing: 10

                        Item {
                            width: height
                            height: d.rowHeight

                            Image {
                                anchors.centerIn: parent
                                source: model.avatar
                            }
                        }

                        Text {
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }

                            color: Styles.infoText
                            text: model.nickname
                        }

                        ImageButton {
                            anchors { verticalCenter: parent.verticalCenter }

                            width: 30
                            height: 30

                            style {
                                normal: "#00000000"
                                hover: "#00000000"
                            }

                            styleImages {
                                normal: installPath + Styles.popupCloseIcon
                                hover: installPath + Styles.popupCloseIcon.replace('.png', '_hover.png')
                            }

                            toolTip: qsTr("Удалить пользователя из черного списка")
                            tooltipGlueCenter: true
                            onClicked: d.unblockUser(model.userId, model.index)
                        }
                    }
                }
            }
        }
    }
}
