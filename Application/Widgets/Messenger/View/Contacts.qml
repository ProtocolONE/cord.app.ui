import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import Gamenet.Controls 1.0

import "../Models/Messenger.js" as MessengerJs

WidgetView {
    implicitWidth: 228
    implicitHeight: parent.height - 100

    Column {
        anchors.fill: parent

        Rectangle {
            id: searchContactItem

            width: parent.width
            height: 52
            color: "#FAFAFA"

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

                anchors {
                    fill: parent
                    margins: 10
                }

                icon: installPath + "/images/Application/Widgets/Messenger/chat_search.png"

                showCapslock: false
                showLanguage: false
                style: InputStyleColors {
                    // UNDONE нарыть цвета
                }

                onTextChanged: {
                    searchContactInput.isSearching = (searchContactInput.text.length > 0);
                    if (searchContactInput.isSearching) {
                        searchContactInput.updateFilter();
                    }
                }
            }

            ListModel {
                id: searchContactModel
            }
        }

        HorizontalSplit {
            width: parent.width
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

