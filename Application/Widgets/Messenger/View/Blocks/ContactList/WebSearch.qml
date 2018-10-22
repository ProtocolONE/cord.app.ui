import QtQuick 1.1
import GameNet.Controls 1.0
import "../../../../../Core/restapi.js" as RestApi
import "../../../../../Core/Styles.js" as Styles
import "../../../../../Core/App.js" as App
import "../../../Models/Messenger.js" as MessengerJs

NavigatableContactList {
    id: root

    property string searchText: ''

    internalView: listView

    QtObject {
        id: d

        property variant splitSearch: root.searchText.trim().toLowerCase().split(' ')
        property string imageRoot: installPath + "Assets/Images/Application/Widgets/Messenger/"

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
        var searchStr;
        if (searchText.length == 0) {
            listViewModel.clear();
            return;
        }

        searchStr = searchText.trim();
        searchStr = encodeURIComponent(searchStr);

        RestApi.User.search(searchStr, false,
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

    Image {
        anchors.centerIn: parent

        source: d.imageRoot + "EmptyContactInfo/background.png"
        opacity: Styles.style.baseBackgroundOpacity
        visible: listView.count == 0
    }

    Item {
        y: 10

        width: 190
        height: 405

        visible: (root.searchText.length == 0) || (listView.count === 0)

        Image {
            x: 21
            source: d.imageRoot + "greenArrow.png"

            Text {
                text: qsTr("WEB_SEARCH_BUTTON_HELP_TEXT")
                width: 100
                color: "#1abc9c"
                wrapMode: Text.Wrap
                font.pixelSize: 14
                anchors {
                    verticalCenter: parent.bottom
                    left: parent.right
                    leftMargin: 10
                    verticalCenterOffset: 6
                }
            }
        }

        Image {
            x: 62
            source: d.imageRoot + "blueArrow.png"

            Text {
                text: qsTr("WEB_SEARCH_INPUT_HELP_TEXT")
                width: 100
                color: "#3498db"
                wrapMode: Text.Wrap
                font.pixelSize: 14
                anchors {
                    top: parent.top
                    topMargin: 29
                    left: parent.right
                    leftMargin: 10
                }
            }
        }
    }

    NavigatableListView {
        id: listView

        function getDefaultAvatar(index) {
             var name = "defaultAvatar_" + (((index + 1) % 12) + 1) + ".png";
             return d.imageRoot + name;
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

            isInContacts: MessengerJs.getUser(MessengerJs.userIdToJid(model.gamenetid)).inContacts
            inviteMaximumLimitSended: model.inviteMaximumLimitSended
            onClicked: {
                listView.currentIndex = index;
                select();
            }

            onRequestAddToContact: {
                MessengerJs.addContact(MessengerJs.userIdToJid(model.gamenetid));
                select();
            }

            function select() {
                if (model.gamenetid) {
                    MessengerJs.openDialog({jid: MessengerJs.userIdToJid(model.gamenetid),
                                               nickname: model.nickname});
                }
            }

            ImageButton {
                id: informationIcon

                width: 11
                height: 11
                anchors {
                    top: parent.top
                    topMargin: 8
                    right: parent.right
                    rightMargin: 14
                }

                style {
                    normal: "#00000000"
                    hover: "#00000000"
                    disabled: "#00000000"
                }

                analytics {
                    page: "/messenger"
                    category: "WebSearch"
                    action: "OpenDetailedUserInfo"
                }

                styleImages {
                   normal: d.imageRoot + "ContactItem/infoIconNormal.png"
                   hover: d.imageRoot + "ContactItem/infoIconHover.png"
                }

                onClicked: App.openDetailedUserInfo({
                                                        userId: model.gamenetid,
                                                        nickname: model.nickname,
                                                        status: "",
                                                        isFriend: model.isFriend,
                                                        isSended: model.friendInviteSended || model.inviteMaximumLimitSended
                                                    });
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
