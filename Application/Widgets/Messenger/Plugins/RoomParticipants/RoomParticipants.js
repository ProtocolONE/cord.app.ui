var _private = null;

Qt.include("../../Models/User.js");
Qt.include("../../Models/Occupant.js");

function init(jabber, messenger) {
    if (_private) {
        throw new Error("[RoomParticipants] Already initialized");
    }

    _private = new RoomParticipants(jabber, messenger)
}

function RoomParticipants(jabber, messenger) {
    var isDebug = false;

    var self = this;

    function debug() {
        if (isDebug) {
            console.log.apply(console, arguments);
        }
    }

    function appendParticipant(user, rawOccupant) {
        debug('[RoomParticipants] append', JSON.stringify(rawOccupant))
        user.participants.append(rawOccupant);
    }

    function findOccupant(user, jid) {
        for (var i = 0; i < user.participants.count; ++i) {
            if (user.participants.get(i).jid == jid) {
                return i;
            }
        }

        return -1;
    }

    function onParticipantPermissions(roomJid, jid, permissions) {
        var bareJid
            , user
            , inRoom
            , index
            , rawOccupant;

        debug('[RoomParticipants] onParticipantPermissions', roomJid, jid, JSON.stringify(permissions));

        user = messenger.getUser(roomJid);
        bareJid = jidWithoutResource(permissions.jid || jabber.mucManager.participantFullJid(roomJid, jid));

        inRoom = permissions.affiliation !== "none" && permissions.affiliation !== "outcast";
        index = findOccupant(user, bareJid);

        if (inRoom) {
            if (index === -1) { // append new occupant
                rawOccupant = createRawOccupant(bareJid);
                rawOccupant.affiliation = permissions.affiliation;
                appendParticipant(user, rawOccupant)
            } else {
                user.participants.setProperty(index, "affiliation", permissions.affiliation);
            }
            return;
        }

        if (index !== -1) { // remove from room
            user.participants.remove(index);
        }
    }

    function onRoomPermissionsReceived(roomJid, permissions) {
        var user
            , rawOccupant
            , inRoom
            , occupants;
        user = messenger.getUser(roomJid);

        occupants = permissions.reduce(function(acc, mucItem) {
            inRoom = mucItem.affiliation !== "none" && mucItem.affiliation !== "outcast";
            if (inRoom) {
                rawOccupant = createRawOccupant(mucItem.jid);
                rawOccupant.affiliation = mucItem.affiliation;
                acc.push(rawOccupant);
            }

            return acc;
        }, []) || [];

        // UNDONE sort occupants;

        user.participants.clear();
        occupants.forEach(function(occupant) {
            appendParticipant(user, occupant);
        });
    }

    function onJoined(roomJid) {
        debug('[RoomParticipants] Joined', roomJid);
        jabber.mucManager.requestPermissions(roomJid);
    }

    jabber.mucManager.participantPermissions.connect(onParticipantPermissions);
    jabber.mucManager.permissionsReceived.connect(onRoomPermissionsReceived);
    jabber.mucManager.joined.connect(onJoined);
}
