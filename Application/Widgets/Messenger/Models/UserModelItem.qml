import QtQuick 2.4
import GameNet.Controls 1.0
import "./Occupant.js" as OccupantJs

Item {
    id: root

    property string userId: ""
    property string jid: ""
    property variant groups

    property string nickname: ""
    property string vcardNickname: ""
    property int unreadMessageCount: 0
    property string statusMessage: ""
    property string presenceState: ""
    property string inputMessage: ""
    property string avatar: ""
    property variant lastActivity: 0
    property variant lastTalkDate: 0
    //property bool online: true по факту вычисляемы параметр по presenceState
    property string playingGame: ""
    property bool inContacts: false
    property bool isGroupChat: false
    property int subscription: 0

    function participants() {
        return partisipantsLoader.item
    }

    Loader {
        id: partisipantsLoader
        sourceComponent: root.isGroupChat ? partisipantsComponent : null
    }

    Component {
        id: partisipantsComponent

        Item {
            id: partisipantsContainer

            function append(raw) {
                participantsModel.append(raw);
            }

            function remove(jid) {
                participantsModel.removeById(jid);
            }

            function keys() {
                var q = participantsModel.count;
                return participantsModel.keys();
            }

            function contains(jid) {
                return participantsModel.contains(jid);
            }

            function setProperty(jid, name, value) {
                participantsModel.setPropertyById(jid, name, value);
            }

            function clear() {
                participantsModel.clear();
            }

            function count() {
                return participantsModel.count;
            }

            function get(jid) {
                console.log('WARNING! Using deprecated method UserModelItem.get(index), use getByIndex instead')
                return participantsModel.get(jid);
            }

            function getById(jid) {
                return participantsModel.getById(jid);
            }

            function getByIndex(i) {
                return participantsModel.get(i);
            }

            ExtendedListModel {
                id: participantsModel

                idProperty: "jid"
            }
        }
    }


}

