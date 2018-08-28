import QtQuick 2.4
import Tulip 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../Models/Messenger.js" as MessengerJs

NavigatableContactList {
    id: root

    property alias model: navigatableView.model

    property string searchText
    property bool nothingFound: searchText !== '' && searchContactModel.count === 0

    signal userClicked(string jid);

    onSearchTextChanged: {
        updateFilter(searchText);
    }

    clip: true

    implicitWidth: 228
    implicitHeight: 400

    internalView: navigatableView

    function sortFunction(a, b) {
        if (a.value > b.value) {
            return 1;
        }

        return -1;
    }

    function updateFilter(text) {
        var res = []
            , item
            , filterText = text.toLowerCase();

        searchContactModel.clear();
        if (filterText === "") {
            return;
        }

        MessengerJs.eachUser(function(user) {
            if (!user.inContacts) {
                return;
            }

            if (0 !== user.nickname.toLowerCase().indexOf(filterText)) {
                return;
            }

            item = {
                jid: user.jid,
                value: user.nickname
            };

            res.push(item);
        });

        res.sort(sortFunction);

        res.forEach(function(e) {
            searchContactModel.append({jid: e.jid});
        });
    }

    NavigatableListView {
        id: navigatableView

        model: searchContactModel
        anchors {
            fill: parent
            rightMargin: 12
        }

        currentIndex: -1
        highlightMoveVelocity: 1000
        boundsBehavior: Flickable.StopAtBounds
        onCountChanged: currentIndex = -1;
        delegate: ContactItemDelegate {
            width: navigatableView.width
            user: model
            isHighlighted: navigatableView.currentIndex == index
        }
    }

    ListModel {
        id: searchContactModel
    }

    ContactsScrollBar {
        id: scrollBar

        listView: navigatableView
        anchors.left: listView.right
    }
}
