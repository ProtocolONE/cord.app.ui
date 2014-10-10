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
            var charsText = d.getDefaultCharText(item),
                chars;

            if (item.hasOwnProperty('chars') && !item.isPrivacyFilterActive) {
                chars = item.chars.map(function(e) {
                    /*
                      INFO есть проблема от сервера, когда он отдает не строку а пустой массив []
                        это временный хак
                    */
                    if (typeof e.name !== 'string') {
                        e.name = '';
                    }

                    return e;
                });

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

            if (!item.hasOwnProperty('nickname')) {
                item.nickname = '';
            }

            if (!item.hasOwnProperty('avatar')) {
                item.avatar = '';
            }

            item.charsText = charsText;
            item.friendInviteSended = false;
            item.inviteMaximumLimitSended = false;
        }
    }

    onSearchTextChanged: {
        if (searchText.length == 0) {
            listViewModel.clear();
            return;
        }

        RestApi.User.search(searchText.trim(), false,
                            function(response) {
                                listViewModel.clear();
                                if (response.hasOwnProperty('error')) {
                                    return;
                                }

                                Object.keys(response).forEach(function(e) {
                                    var item = response[e];
                                    d.formatItem(item);
                                    listViewModel.append(item);
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

        function getDefaultAvatar(index) {
             var name = "defaultAvatar_" + (((index + 1) % 12) + 1) + ".png";
             return installPath + "/Assets/Images/Application/Widgets/Messenger/" + name;
        }

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
            nickname: model.nickname || model.gamenetid
            avatar: model.avatar || listView.getDefaultAvatar(index)
            charsText: model.charsText
            isFriend: model.isFriend
            isInviteToFriendSended: model.friendInviteSended
            inviteMaximumLimitSended: model.inviteMaximumLimitSended
            onClicked: {
                listView.currentIndex = index;
                select();
            }

            onInviteFriend: {
                if (model.friendInviteSended || !model.gamenetid) {
                    return;
                }

                RestApi.Social.sendInvite(model.gamenetid, function(response){
                    if (response.hasOwnProperty('error')) {
                        if (response.error.code == 503) {
                            listView.model.setProperty(index, 'inviteMaximumLimitSended', true);
                        }

                        if (response.error.code == 502) {
                            // Инвайт уже был отправлен ранее, просто показываем текст что отправлен
                            listView.model.setProperty(index, 'friendInviteSended', true);
                        }
                        return;
                    }

                    if (response.hasOwnProperty('result')) {
                        if (response.result) {
                            listView.model.setProperty(index, 'friendInviteSended', true);
                        }
                    }
                }, function(){

                });
            }

            function select() {
                if (model.gamenetid) {
                    MessengerJs.openDialog({jid: MessengerJs.userIdToJid(model.gamenetid),
                                               nickname: model.nickname});
                }
            }
        }

        model: ListModel {
            id: listViewModel
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
