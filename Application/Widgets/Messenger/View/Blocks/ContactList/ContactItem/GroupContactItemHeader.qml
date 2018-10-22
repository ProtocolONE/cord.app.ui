/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0

import GameNet.Controls 1.0

import "../../../../../../Core/Styles.js" as Styles
import "../../../../../../Core/App.js" as App

import "../../../../Models/Messenger.js" as Messenger

Item {
    id: root

    property alias occupantModel: occupantView.model

    property string title: ""

    signal nicknameClicked()
    signal clicked()
    signal rightButtonClicked(variant mouse);

    signal groupButtonClicked();

    implicitWidth: 78
    implicitHeight: 72

    QtObject {
        id: d

        property string imageRoot: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/"

        function getAvatar(user) {
            return Messenger.userAvatar(user);
        }

        function presenceStatus(user) {
            if (!user) {
                return "";
            }

            return Messenger.userPresenceState(user) || "";
        }

        function countText() {
            var translate = {
                textSingle: qsTr('GROUP_CONTACT_HEADER_MEMBER_COUNT_SINGLE'),
                textDouble: qsTr('GROUP_CONTACT_HEADER_MEMBER_COUNT_DOUBLE'),
                textMultiple: qsTr('GROUP_CONTACT_HEADER_MEMBER_COUNT_MULTIPLE')
            };

            var longModulo = occupantModel.count % 100;
            var shortModulo = longModulo % 10;
            var template = "";

            if ((longModulo < 10 || longModulo > 20) && shortModulo > 1 && shortModulo < 5) {
                template = translate['textDouble'];
            } else if (shortModulo == 1 && longModulo != 11) {
                template = translate['textSingle'];
            } else {
                template = translate['textMultiple'];
            }

            return occupantModel.count + " " + template;
        }
    }

    Row {
        anchors {
            fill: parent
            leftMargin: 12
            topMargin: 12
            bottomMargin: 12
        }

        spacing: 7

        Item {
            width: 200 -20
            height: parent.height

            Text {
                width: parent.width
                anchors {
                    baseline: parent.top
                    baselineOffset: 19
                }

                font {
                    family: "Arial"
                    pixelSize: 14
                }

                color: Styles.style.menuText
                // INFO Этот хак чинит проблему с уползанием текста, когад текст пустой
                text: root.title ? root.title : "  "
                elide: Text.ElideRight
                textFormat: Text.PlainText
            }

            Text {
                width: parent.width
                anchors {
                    baseline: parent.bottom
                    baselineOffset: -8
                }

                font {
                    family: "Arial"
                    pixelSize: 12
                }

                color: Styles.style.textBase
                opacity: 0.5
                text: d.countText()
                elide: Text.ElideRight
            }
        }

        Item {
            width: 248  +20
            height: parent.height

            ListView {
                id: occupantView

                anchors.fill: parent
                spacing: 7
                interactive: false
                orientation: ListView.Horizontal

                delegate: Item {
                    width: 48
                    height: 48
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        width: 48
                        height: 48
                        source: d.getAvatar(model);
                    }

                    Image {
                        visible: model.affiliation === "owner"
                        anchors {
                            top: parent.top
                            right: parent.right
                        }
                        source: installPath + "/Assets/Images/Application/Widgets/Messenger/ownerIcon.png"
                    }

                    PresenceIcon {
                        status: d.presenceStatus(model)
                    }

                    CursorMouseArea {
                        visible: model.jid != Messenger.authedUser().jid
                        anchors.fill: parent
                        onClicked: {
                            Messenger.selectUser(model);
                        }
                    }

                }
            }
        }
    }

    EditGroupButton {
        anchors {
            top: parent.top
            topMargin: 12
            right: parent.right
        }

        onClicked: root.groupButtonClicked()
    }

}
