/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../Core/App.js" as App
import "../../../../Core/restapi.js" as RestApi
import "../../../../Core/Styles.js" as Styles

Item {
    id: root

    property string targetId: ""
    property string nametech: ""
    property alias avatar: avatarIamge.source

    property alias ratingIcon: ratingIconImage.source
    property alias premiumIcon: premiumIconImage.source

    property alias fio: fioline.text
    property alias subInfo1: subLineText1.text
    property alias subInfo2: subLineText2.text

    property int level: 1
    property int rating: 1
    property int countAchievements: 1

    property alias progressBar: progressBar.progress
    property int progress: 0

    property string currentExp: ""
    property string nextExp: ""

    function clearAchievment() {
        achievmentsModel.clear();
    }

    function appendAchievment(a) {
        achievmentsModel.append({
                                    source: a.source || "",
                                    title: a.title || "",
                                    description: a.description || "",
                                    level: a.level || 0
                                });
    }

    function setFriendshipStatus(isFriend, isFriendRequestSended) {
        sendFriendRequestButton.inProgress = false;
        d.isFriend = isFriend;
        d.isFriendRequestSended = isFriendRequestSended;
        d.friendRequestMessage = qsTr("DETAILED_USER_INFO_MAIN_INFO_SEND_FRIEND_REQUEST_SENDED")
    }

    implicitWidth: parent.width
    implicitHeight: 178

    QtObject {
        id: d

        property string urlId: root.nametech || root.targetId
        property bool isFriend: false
        property bool isFriendRequestSended: false
        property string friendRequestMessage: ""

        function openProfile() {
            App.openExternalUrlWithAuth(('https://gamenet.ru/users/%1/').arg(d.urlId));
        }

        function openRating() {
            App.openExternalUrlWithAuth(('https://gamenet.ru/users/%1/ratings/').arg(d.urlId));
        }

        function openAchievements() {
            App.openExternalUrlWithAuth(('https://gamenet.ru/users/%1/achievements/').arg(d.urlId));
        }

        function sendFriendRequest() {
            sendFriendRequestButton.inProgress = true;

            RestApi.Social.sendInvite(root.targetId, function(response) {
                sendFriendRequestButton.inProgress = false;
                d.isFriendRequestSended = true;
                d.friendRequestMessage = qsTr("DETAILED_USER_INFO_MAIN_INFO_SEND_FRIEND_REQUEST_SENDED")

                if (response.hasOwnProperty('error')) {
                    if (response.error.code == 503) {
                        d.friendRequestMessage = qsTr("DETAILED_USER_INFO_MAIN_INFO_SEND_FRIEND_REQUEST_LIMIT")
                    }
                    return;
                }

            }, function(){
                sendFriendRequestButton.inProgress = false;
            });
        }
    }

    Column {
        anchors {
            top: parent.top
            topMargin: 15
            left: parent.left
            leftMargin: 15
        }

        width: 100
        spacing: 12

        Item {
            width: 100
            height: 100
            clip: true

            WebImage {
                id: avatarIamge

                width: 100
                fillMode: Image.PreserveAspectFit
            }

            CursorMouseArea {
                anchors.fill: parent
                onClicked: d.openProfile();
                toolTip: qsTr("DETAILED_USER_INFO_MAIN_INFO_AVATAR_TOOLTIP")
            }
        }

        Item {
            width: parent.width
            height: 32
            visible: !d.isFriend

            CheckedButton {
                id: sendFriendRequestButton

                visible: !d.isFriendRequestSended
                anchors.fill: parent
                checked: true
                boldBorder: true
                text: qsTr("DETAILED_USER_INFO_MAIN_INFO_REQUEST_BUTTON") // "Дружить"
                onClicked: d.sendFriendRequest();
            }

            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                text: d.friendRequestMessage
                visible: d.isFriendRequestSended
                font {
                    family: "Arial"
                    pixelSize: 12
                }
                color: Styles.style.lightText
            }
        }
    }

    Column {
        anchors {
            fill: parent
            topMargin: 15
            leftMargin: 130
            rightMargin: 15
            bottomMargin: 15
        }

        Item {
            width: parent.width
            height: 60

            Column {
                anchors.fill: parent

                Text {
                    id: fioline

                    width: parent.width
                    font {
                        family: "Arial"
                        pixelSize: 14
                    }

                    color: Styles.style.lightText
                    visible: !!text
                }

                Text {
                    id: subLineText1

                    width: parent.width
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }

                    color: Styles.style.textBase
                    visible: !!text
                }

                Text {
                    id: subLineText2

                    width: parent.width
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }

                    color: Styles.style.textBase
                    visible: !!text
                }
            }
        }

        Item {
            width: parent.width
            height: 35

            Row {
                anchors.fill: parent
                spacing: 10

                Item {
                    height: parent.height
                    width: (parent.width - 10) / 2

                    Image {
                        id: premiumIconImage
                    }

                    Row {
                        anchors {
                            left: parent.left
                            leftMargin: 22
                        }

                        Text {
                            font {
                                family: "Arial"
                                pixelSize: 12
                            }

                            color: Styles.style.lightText
                            text: root.level
                        }

                        Text {
                            font {
                                family: "Arial"
                                pixelSize: 12
                            }

                            color: Styles.style.textBase
                            text: qsTr("DETAILED_USER_INFO_MAIN_INFO_LEVEL") // " уровень"
                        }
                    }

                    ProgressBar {
                        id: progressBar

                        anchors {
                            top: parent.top
                            topMargin: 20
                        }

                        width: 100
                        height: 2
                        style {
                            background: Styles.style.applicationBackground
                            line: Styles.style.detailedUserInfoMainInfoLevelProgressLine // UNDONE
                        }
                    }
                }

                Item {
                    height: parent.height
                    width: (parent.width - 10) / 2

                    Image {
                        id: ratingIconImage
                    }

                    Row {
                        anchors {
                            left: parent.left
                            leftMargin: 22
                        }

                        Text {
                            font {
                                family: "Arial"
                                pixelSize: 12
                            }

                            color: Styles.style.lightText
                            text: root.rating

                            CursorMouseArea {
                                anchors.fill: parent
                                onClicked: d.openRating()
                                toolTip: qsTr("DETAILED_USER_INFO_MAIN_INFO_RATING_TOOLTIP")
                            }
                        }

                        Text {
                            font {
                                family: "Arial"
                                pixelSize: 12
                            }

                            color: Styles.style.textBase
                            text: qsTr("DETAILED_USER_INFO_MAIN_INFO_RATING") // " место"
                        }
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 55

            Row {
                width: parent.width
                height: 20

                Text {
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }

                    color: Styles.style.textBase
                    textFormat: Text.RichText
                    text: qsTr("DETAILED_USER_INFO_MAIN_INFO_ACHIEVEMENT") // "Награды и достижения "
                }

                Text {
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }

                    textFormat: Text.RichText
                    color: Styles.style.textBase
                    text: "("
                }

                Text {
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }

                    color: Styles.style.lightText
                    textFormat: Text.RichText
                    text: root.countAchievements

                    CursorMouseArea {
                        anchors.fill: parent
                        toolTip: qsTr("DETAILED_USER_INFO_MAIN_INFO_ACHIEVEMENT_TOOLTIP")
                        onClicked: d.openAchievements()
                    }

                }

                Text {
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }

                    color: Styles.style.textBase
                    textFormat: Text.RichText
                    text: ")"
                }
            }

            ListView {
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 20
                }

                spacing: 5
                width: 30*6 + 5*5
                height: 30
                interactive: false
                orientation: ListView.Horizontal

                model: ListModel {
                    id: achievmentsModel
                }

                delegate: Item {
                    width: 30
                    height: 30

                    Image {
                        width: parent.width
                        height: parent.height
                        source: model.source
                    }

                    CursorMouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        cursor: CursorArea.ArrowCursor
                        toolTip: ("%1 (%2)\n%3").arg(model.title).arg(model.level).arg(model.description)
                    }
                }
            }
        }
    }
}
