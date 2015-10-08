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

    function onParticipantPermissions(roomJid, jid, permissions) {
        var bareJid
            , user
            , inRoom
            , rawOccupant
            , participants
            , occupantExist;

        debug('[RoomParticipants] onParticipantPermissions', roomJid, jid, JSON.stringify(permissions));

        user = messenger.getUser(roomJid);
        bareJid = jidWithoutResource(permissions.jid || jabber.mucManager.participantFullJid(roomJid, jid));

        inRoom = permissions.affiliation !== "none" && permissions.affiliation !== "outcast";
        participants = user.participants;

        occupantExist = participants.contains(bareJid);

        if (inRoom) {
            if (occupantExist) { // append new occupant
                rawOccupant = createRawOccupant(bareJid);
                rawOccupant.affiliation = permissions.affiliation;

                debug('[RoomParticipants] append', JSON.stringify(rawOccupant))
                participants.append(rawOccupant);
                messenger.participantsChanged(user.jid);
            } else {
                participants.setProperty(bareJid, "affiliation", permissions.affiliation);
            }
            return;
        }

        if (occupantExist) { // remove from room
            participants.remove(bareJid);
            messenger.participantsChanged(user.jid);
        }
    }

    function onRoomPermissionsReceived(roomJid, permissions) {
        var user
            , rawOccupant
            , inRoom
            , occupants
            , participants;
        user = messenger.getUser(roomJid);
        participants = user.participants;

        occupants = permissions.reduce(function(acc, mucItem) {
            inRoom = mucItem.affiliation !== "none" && mucItem.affiliation !== "outcast";
            if (inRoom) {
                rawOccupant = createRawOccupant(mucItem.jid);
                rawOccupant.affiliation = mucItem.affiliation;
                acc.push(rawOccupant);
            }

            return acc;
        }, []) || [];

        participants.clear();

        occupants.forEach(function(occupant) {
            debug('[RoomParticipants] append', JSON.stringify(occupant))
            participants.append(occupant);
        });

        messenger.participantsChanged(user.jid);
    }

    function onJoined(roomJid) {
        debug('[RoomParticipants] Joined', roomJid);
        jabber.mucManager.requestPermissions(roomJid);
    }

    jabber.mucManager.participantPermissions.connect(onParticipantPermissions);
    jabber.mucManager.permissionsReceived.connect(onRoomPermissionsReceived);
    jabber.mucManager.joined.connect(onJoined);
}
