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

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../Models/Messenger.js" as MessengerJs

WidgetView {
    implicitWidth: parent.width
    implicitHeight: parent.height

    Rectangle {
        anchors {
            fill: parent
            leftMargin: 1
        }

        color: "#FFFFFF"

        Column {
            anchors.fill: parent

            Rectangle {
                id: searchContactItem

                width: parent.width
                height: 53
                color: "#FAFAFA"

                Rectangle {
                    height: 1
                    width: parent.width
                    color: "#FFFFFF"
                    anchors.top: parent.top
                }

                Row {
                    anchors {
                        fill: parent
                        margins: 10
                        topMargin: 11
                        bottomMargin: 11
                    }

                    spacing: 10

                    Button {
                        width: 32
                        height: 32

                        style: ButtonStyleColors {
                            normal: "#1ABC9C"
                            hover: "#019074"
                        }

                        Image {
                            anchors.centerIn: parent

                            source: installPath + "Assets/Images/Application/Widgets/Messenger/add_friend.png"
                        }
                    }

                    Input {
                        id: searchContactInput

                        property bool isSearching: false

                        function sortFunction(a, b) {
                            if (a.value > b.value) {
                                return 1;
                            }

                            return -1;
                        }

                        function filterFunction(pattern, testedValue) {
                            if (pattern === "" || testedValue === "") {
                                return false;
                            }
                            if (pattern.length > testedValue.length) {
                                return false;
                            }
                            if (testedValue.substring(0, pattern.length) === pattern) {
                                return true;
                            }
                        }

                        function updateFilter() {
                            var res = []
                            , item;
                            searchContactModel.clear();

                            MessengerJs.eachUser(function(user) {
                                if (!filterFunction(searchContactInput.text, user.nickname)) {
                                    return;
                                }

                                item = {
                                    jid: user.jid,
                                    value: user.nickname
                                };

                                res.push(item);
                            });

                            res.sort(searchContactInput.sortFunction);

                            res.forEach(function(e) {
                                searchContactModel.append({
                                                              jid: e.jid
                                                          });
                            });
                        }

                        height: parent.height
                        width: parent.width - 42

                        icon: installPath + "/Assets/Images/Application/Widgets/Messenger/chat_search.png"

                        placeholder: qsTr("MESSENGER_SEARCH_FRIEND_PLACE_HOLDER")
                        fontSize: 14
                        showCapslock: false
                        showLanguage: false
                        style: InputStyleColors {
                            normal: "#e5e5e5"
                            active: "#3498db"
                            hover: "#3498db"
                            placeholder: "#a4b0ba"
                        }

                        onTextChanged: {
                            searchContactInput.isSearching = (searchContactInput.text.length > 0);
                            if (searchContactInput.isSearching) {
                                searchContactInput.updateFilter();
                            }
                        }
                    }
                }

                Rectangle {
                    height: 1
                    width: parent.width
                    color: "#E5E5E5"
                    anchors.bottom: parent.bottom
                }

                ListModel {
                    id: searchContactModel
                }
            }

            Item {
                width: parent.width
                height: parent.height - searchContactItem.height - 2

                ContactList {
                    anchors.fill: parent
                    visible: !searchContactInput.isSearching
                    model: MessengerJs.groupsModel()
                }

                SearchContactList {
                    visible: searchContactInput.isSearching
                    anchors.fill: parent
                    model: searchContactModel
                    onUserClicked: searchContactInput.text = "";
                }
            }
        }

    }

    Rectangle {
        width: 1
        height: parent.height
        color: "#e5e5e5"
    }
}

