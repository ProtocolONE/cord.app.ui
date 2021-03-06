import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

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
            var result = {};
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

                    e.charlevel = (e.charlevel || "").toString();

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

            result.nickname = item.nickname || "";
            result.protocolOneid = item.protocolOneid || "";
            result.avatar = item.avatar || "";
            result.gender = item.gender || "";
            result.firstname = item.firstname || "";
            result.lastname = item.lastname || "";
            result.charsText = charsText;
            result.isFriend = item.isFriend || false;
            result.isPrivacyFilterActive = item.isPrivacyFilterActive || false;
            result.friendInviteSended = false;
            result.inviteMaximumLimitSended = false;

            return result;
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

                                var viewMovel = response.map(function(item) {
                                    var result =d.formatItem(item);
                                    return result;
                                });

                                listViewModel.append(viewMovel);
                            });
    }

    clip: true

    implicitWidth: 228
    implicitHeight: 400

    Item {
        anchors.fill: parent
        visible: listView.count == 0

        Image {
            width: parent.width
            opacity: Styles.baseBackgroundOpacity
            source: installPath + "/Assets/Images/Application/Widgets/Messenger/EmptyContactInfo/background.png"
        }

        Rectangle {
            anchors.fill: parent
            opacity: 0.65
            color: Styles.contentBackgroundDark
        }
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
        highlightMoveVelocity: 1000
        boundsBehavior: Flickable.StopAtBounds
        currentIndex: -1
        onCountChanged: currentIndex = -1;

        delegate: WebSearchContact {
            function isSelected() {
                var user = MessengerJs.selectedUser(MessengerJs.USER_INFO_JID);
                if (!user || !user.jid || !model.protocolOneid) {
                    return false;
                }

                return user.jid == MessengerJs.userIdToJid(model.protocolOneid);
            }

            function internalSubscrition(m) {
                return MessengerJs.getUser(MessengerJs.userIdToJid(m.protocolOneid)).subscription || 0;
            }

            width: listView.width
            isHighlighted: listView.currentIndex === index;
            isActive: isSelected();
            searchText: root.searchText
            nickname: model.nickname || model.protocolOneid
            avatar: model.avatar || listView.getDefaultAvatar(index)
            charsText: model.charsText
            subscrition: internalSubscrition(model)
            contactSent: model.friendInviteSended
            inviteMaximumLimitSended: model.inviteMaximumLimitSended
            onClicked: {
                listView.currentIndex = index;
                select();
            }

            onRequestAddToContact: {
                MessengerJs.addContact(MessengerJs.userIdToJid(model.protocolOneid));
                listViewModel.setProperty(model.index, 'friendInviteSended', true)
                select();
            }

            function select() {
                if (model.protocolOneid) {
                    MessengerJs.openDialog({jid: MessengerJs.userIdToJid(model.protocolOneid),
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
                    category: "Messenger WebSearch"
                    label: "OpenDetailedUserInfo"
                }

                styleImages {
                   normal: d.imageRoot + "ContactItem/infoIconNormal.png"
                   hover: d.imageRoot + "ContactItem/infoIconHover.png"
                }

                onClicked: SignalBus.openDetailedUserInfo({
                                                        userId: model.protocolOneid,
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

    ContactsScrollBar {
        id: scrollBar

        listView: listView
        anchors.right: listView.right
        visible: listView.visible && listView.count > 0
    }
}
