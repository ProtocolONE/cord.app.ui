var _private = null;

// UNDONE надо б скормить снаружи
var conferenceUrl = 'conference.qj.gamenet.ru';

function init(jabber, messenger) {
    if (_private) {
        throw new Error("[CreateRoom] Already initialized");
    }

    _private = new RoomCreate(jabber, messenger)
}

function RoomCreate(jabber, messenger) {
    var configs = {};

    // UNDONE вероятно стоит прописать полный конфиг
    var defaultConfig = {
        membersonly: true
    }

    function RoomConfig(roomJid, options) {
        this.jid = roomJid;
        this.topic = options.topic;
        this.invites = options.invites || [];
    }

    function onRoomCreated(roomJid) {
        if (!configs.hasOwnProperty(roomJid)) {
            return;
        }

        if (!jabber.mucManager.setConfiguration(roomJid, defaultConfig)) {
            console.log('[CreateRoom] Failed to set config');
        }
    }

    function onJoinRoom(roomJid) {
        var config;
        if (!configs.hasOwnProperty(roomJid)) {
            return;
        }

        config = configs[roomJid];
        if (config.topic) {
            jabber.mucManager.setSubject(roomJid, config.topic);
        }

        config.invites.forEach(function(jid) {
            jabber.invite(roomJid, jid);
        });

        delete configs[roomJid];
    }

    jabber.mucManager.roomCreated.connect(onRoomCreated);
    jabber.mucManager.joined.connect(onJoinRoom);

    this.create = function(options) {
        var roomJid = messenger.uuid() + '@' + conferenceUrl,
            config = new RoomConfig(roomJid, options);

        configs[roomJid] = config;

        jabber.mucManager.addRoom(roomJid);
        jabber.mucManager.join(roomJid, messenger.authedUser().userId);
    }
}

function create(options) {
    _private.create(options);
}

