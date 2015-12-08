import QtQuick 2.4
import GameNet.Controls 1.0

import Tulip 1.0

import "./Occupant.js" as OccupantJs

Item {
    id: root

    property variant messenger
    property string targetJid: ""
    property string topic: ""

    signal editStarted();

    function reset() {
        root.topic = "";
        root.targetJid = "";
        occupantsModel.clear();
    }

    function isActive() {
        return d.active;
    }

    function owner() {
        return d.owner;
    }

    function createRoom(jid) {
        var roomJid = d.getNewRoomJid();
        root.startEdit(roomJid);

        d.lastActiveContact = jid || "";

        if (jid) {
            addUser(jid);
        }
    }

    function close() {
        if (!d.active) {
            return;
        }
        d.active = false;

        occupantsModel.clear();

        if (d.isCreateNew()) {
            if (d.lastActiveContact) {
                root.messenger.selectUser({jid: d.lastActiveContact})
            } else {
                root.messenger.closeChat();
            }
        }
    }

    function startEdit(roomJid) {
        d.owner = false;

        if (targetJid !== roomJid) {
            targetJid = roomJid;
            occupantsModel.clear();
        }

        occupantsModel.forEachId(function(item) {
            occupantsModel.setPropertyById(item, "canDelete", true);
        });

        var room = messenger.getUser(roomJid || d.getNewRoomJid())
        , jid
        , occupantItem
        , selfJid
        , selfRawOccupant
        , participants;

        root.topic = room.nickname;
        selfJid = messenger.authedUser().jid;
        selfRawOccupant = d.rawOccupant(selfJid, "member");
        selfRawOccupant.self = true;

        occupantsModel.append(selfRawOccupant);

        participants = room.participants;
        participants.keys().forEach(function(participantId) {
            occupantItem = participants.getById(participantId);
            if (participantId === selfJid) {
                d.owner = (occupantItem.affiliation === "owner");
                occupantsModel.setPropertyById(participantId, "affiliation", occupantItem.affiliation);
            } else {
                occupantsModel.append(d.rawOccupant(participantId, occupantItem.affiliation, false));
            }
        });

        // INFO Может упасть, если что смотреть как формируется модель для шапки групповый чатов.
        occupantsModel.sort(d.sort);

        d.active = true;
        root.editStarted();
    }

    function addUser(jid) {
        if (occupantsModel.contains(jid)) {
            return;
        }

        occupantsModel.append(d.rawOccupant(jid));
        occupantsModel.sort(d.sort);
    }

    function removeUser(jid) {
        occupantsModel.removeById(jid);
    }

    function occupants() {
        return occupantsModel.model;
    }

    function apply() {
        d.active = false;
        if (d.isCreateNew()) {
            d.createNewRoom();
            return;
        }

        d.applyChanges();
    }

    function isSelected(jid) {
        var result = false;
        occupantsModel.forEach(function(item) {
            if (item.jid === jid) {
                result = true;
            }
        });

        return result;
    }

    function canDelete(jid) {
        var result = false;
        occupantsModel.forEach(function(item) {
            if (item.jid === jid) {
                result = item.canDelete;
            }
        });

        return result;
    }

    function groupTitle() {
        if (root.topic) {
            return root.topic;
        }

        var tmp = []
            , i
            , occupants = root.occupants()
            , occupant
            , selfJid = root.messenger.authedUser().jid
            , jid;


        for(i = 0; i < occupants.count; ++i) {
            jid = occupants.get(i).jid;
            if (selfJid === jid) {
                continue;
            }

            occupant = root.messenger.getUser(jid);
            tmp.push(occupant.nickname);
        }

        tmp.push(root.messenger.authedUser().nickname);

        return tmp.join(", ");
    }

    QtObject {
        id: d

        property string lastActiveContact: ""

        property bool active: false;
        property bool owner: false
        property string newRoomJid: ""

        function isCreateNew() {
            return root.targetJid === d.newRoomJid;
        }

        function rawOccupant(jid, affiliation, canDelete) {
            return {
                jid: jid,
                affiliation: affiliation || "member",
                canDelete: (canDelete !== undefined) ? canDelete : true,
                self: false
            }
        }

        function getNewRoomJid() {
            var conferenceUrl;
            if (!d.newRoomJid) {
                conferenceUrl = root.messenger.getJabberClient().conferenceUrl()
                d.newRoomJid = Uuid.create() + '@' + conferenceUrl;
            }

            root.messenger.selectUser({jid: d.newRoomJid});
            return d.newRoomJid;
        }

        function createNewRoom() {
            var invites = [];

            occupantsModel.forEach(function(item) {
                if (item.self) {
                    return;
                }

                invites.push(item.jid);
            });

            root.messenger.createRoom(d.newRoomJid, root.topic, invites);
            d.newRoomJid = "";
        }

        function applyChanges() {
            var removeUsers = []
                , currentUsers = {}
                , inviteUsers = []
                , roomUser
                , jabber = root.messenger.getJabberClient()
                , i
                , participants
                , toRemove = [];

            roomUser = root.messenger.getUser(root.targetJid);

            if (roomUser.nickname !== root.topic) {
                jabber.setRoomTopic(root.targetJid, root.topic)
            }

            participants = roomUser.participants;

            participants.keys().forEach(function(participantId) {
                if (!occupantsModel.contains(participantId)) {
                    jabber.mucManager.setPermission(root.targetJid, participantId, 'none');
                    toRemove.push(participantId);
                } else {
                    currentUsers[participantId] = 1;
                }
            });

            occupantsModel.forEachId(function(item) {
                if (!currentUsers.hasOwnProperty(item)) {
                    jabber.mucManager.sendInvitationMediated(root.targetJid, item, "");
                    participants.append(OccupantJs.createRawOccupant(item));
                }
            });

            toRemove.forEach(participants.remove);

            root.messenger.participantsChanged(root.targetJid);
        }

        function sort(a, b) {
            if (a.affiliation === "owner") {
                return -1;
            }

            if (b.affiliation === "owner") {
                return 1;
            }

            return a.jid.localeCompare(b.jid);
        }
    }

    Connections {
        target: root.messenger

        onSelectedUserChanged: {
            root.close()
        }
    }

    ExtendedListModel {
        id: occupantsModel

        idProperty: "jid"
    }

}
