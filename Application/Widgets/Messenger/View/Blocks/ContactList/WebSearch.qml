import QtQuick 1.1
import GameNet.Controls 1.0
import "../../../../../../Application/Core/restapi.js" as RestApi
import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as MessengerJs

NavigatableContactList {
    id: root

    property string searchText: ''

    internalView: listView

    QtObject {
        id: d

        property variant splitSearch: root.searchText.trim().toLowerCase().split(' ')

        function getDefaultCharText(item) {
            if (!item.isPrivacyFilterActive &&
               (!item.hasOwnProperty('chars') ||
                Object.keys(item.chars).length == 0)) {

                return qsTr("WEB_SEARCH_NOT_CHARS");
            }

            if (item.isPrivacyFilterActive) {
                return qsTr("WEB_SEARCH_CHARS_PRIVACY_FILTER_ACTIVE");
            }

            return '';
        }

        function sortFunc(a, b) {
            var aIndex = -1
            , bIndex = -1
            , aName = a.name.toLowerCase()
            , bName = b.name.toLowerCase();

            d.splitSearch.forEach(function(e) {
                if (aName.indexOf(e) !== -1) {
                    aIndex = 1;
                    return false;
                }
                return true;
            });


            d.splitSearch.forEach(function(e) {
                if (bName.indexOf(e) !== -1) {
                    bIndex = 1;
                    return false;
                }
                return true;
            });

            if (aIndex !== -1 && bIndex !== -1) {
                return 0;
            }

            return (aIndex !== -1 && bIndex === -1) ? -1 : 1;
        }

        function formatItem(item) {
            var chars = item.chars,
                charsText = d.getDefaultCharText(item);

            if (item.hasOwnProperty('chars') && !item.isPrivacyFilterActive) {
                chars.sort(d.sortFunc);

                chars = chars.slice(0, 4).forEach(function(e){
                    var regexpString = "(" + d.splitSearch.join("|") + ")",
                        searchKeys = ['game', 'name', 'class', 'server'];

                    searchKeys.forEach(function(value) {
                        if (new RegExp(regexpString, 'ig').test(e[value])) {
                            e[value] = '<b>' + e[value] + '</b>';
                        }
                    });

                    var plainText = function(e) {
                        var result = e['game'] + ': ' + e['name'],
                                lvl = e['charlevel'] + ' lvl';

                        if (!e['class'] || !e['server']) {
                            return result + '(' + lvl + ')';
                        }

                        return result +
                                '(' + e['class'] + ',' + lvl + ',' + e['server'] + ')';
                    }(e);

                    if (charsText.length > 0) {
                        charsText += '<br>';
                    }

                    charsText += plainText;
                });
            }

            item.charsText = charsText;
        }
    }

    onSearchTextChanged: {
        if (searchText.length == 0) {
            model.clear();
            return;
        }

        RestApi.User.search(searchText.trim(), false,
                            function(response) {
                                model.clear();

                                if (response.hasOwnProperty('error')) {
                                    return;
                                }

                                Object.keys(response).forEach(function(e) {
                                    var item = response[e];
                                    d.formatItem(item);
                                    model.append(item);
                                });
                            });
    }

    clip: true

    implicitWidth: 228
    implicitHeight: 400

    Text {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 12
        }

        width: parent.width - 12

        font {
            family: 'Arial'
            pixelSize: 14
        }
        color: Styles.style.messengerWebSearchBackgroundText

        text: qsTr("WEB_SEARCH_BACKGROUND_TEXT");

        wrapMode: Text.WordWrap
        visible: root.searchText.length == 0
    }

    NavigatableListView {
        id: listView

        anchors.fill: parent
        visible: root.searchText.length > 0
        highlightMoveSpeed: 1000
        boundsBehavior: Flickable.StopAtBounds
        currentIndex: -1
        onCountChanged: currentIndex = -1;

        delegate: WebSearchContact {
            function isSelected() {
                var user = MessengerJs.selectedUser(MessengerJs.USER_INFO_JID);
                if (!user || !user.jid || !model.gamenetid) {
                    return false;
                }

                return user.jid == MessengerJs.userIdToJid(model.gamenetid);
            }

            width: listView.width
            isHighlighted: listView.currentIndex === index;
            isActive: isSelected();
            searchText: root.searchText
            nickname: model.nickname
            avatar: model.avatar
            charsText: model.charsText
            onClicked: {
                listView.currentIndex = index;
                select();
            }

            function select() {
                if (model.gamenetid) {
                    MessengerJs.openDialog({jid: MessengerJs.userIdToJid(model.gamenetid),
                                               nickname: model.nickname});
                }
            }
        }

        model: ListModel {
            id: model
        }
    }

    ListViewScrollBar {
        anchors.right: listView.right
        height: listView.height
        width: 10
        listView: listView
        visible: listView.visible && listView.count > 0
        cursorMaxHeight: listView.height
        cursorMinHeight: 50
        color: Qt.darker(Styles.style.messengerContactsBackground, Styles.style.darkerFactor);
        cursorColor: Qt.darker(Styles.style.messengerContactsBackground, Styles.style.darkerFactor * 1.5);
    }
}
