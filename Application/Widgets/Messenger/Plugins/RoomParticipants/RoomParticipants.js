var _private = null;

function init(jabber, messenger) {
    if (_private) {
        throw new Error("[RoomParticipants] Already initialized");
    }

    _private = new RoomParticipants(jabber, messenger)
}

function RoomParticipants(jabber, messenger) {

}
