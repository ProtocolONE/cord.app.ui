var _private = null;

function init(jabber, messenger) {
    if (_private) {
        throw new Error("[CreateRoom] Already initialized");
    }

    _private = new RoomCreate(jabber, messenger)
}

function RoomCreate(jabber, messenger) {
    var isDebug = false;

    var configs = {};

    var defaultConfig = {
        persistent: true,
        public: false,
        public_list: true,
        hasPassword: false,
        password: "",
        maxusers: 200,
        whois: "anyone",
        membersonly: true,
        moderated: true,
        membersByDefault: true,
        canChangeSubject: true,
        allowPrivateMessages: true,
        allowQueryUsers: true,
        allowInvites: true,
        allowVisitorStatus: true,
        allowVisitorNickChange: true,
        allowVoiceRequests: false,
        voiceRequestMinInterval: 1800,
        captchaWhitelist: []
    };

    function debug() {
        if (isDebug) {
            console.log.apply(console, arguments);
        }
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
            debug('[CreateRoom] Failed to set config');
        }
    }

    function applyConfig(roomJid) {
        var config;
        if (!configs.hasOwnProperty(roomJid)) {
            return;
        }

        config = configs[roomJid];
        if (config.topic) {
            jabber.setRoomTopic(roomJid, config.topic);
        }

        config.invites.forEach(function(jid) {
            jabber.invite(roomJid, jid);
        });

        delete configs[roomJid];
    }

    function onJoinRoom(roomJid) {
        var user;
        messenger.getUsersModel().beginBatch();

        user = messenger.getUser(roomJid);
        user.inContacts = true;
        user.presenceState = 'online';

        messenger.getUsersModel().endBatch();

        applyConfig(roomJid);
    }

// INFO этот код позволяет подключиться к всем доступным комнатам
//    _jabber.discoveryManager.itemsReceived.connect(function(items) {
//        items.items.forEach(function(room) {
//            _jabber.joinRoom(room.jid);
//        });
//    });

    jabber.mucManager.roomCreated.connect(onRoomCreated);
    jabber.mucManager.joined.connect(onJoinRoom);

    this.create = function(options) {
        var roomJid = options.jid || (messenger.uuid() + '@' + jabber.conferenceUrl()),
            config = new RoomConfig(roomJid, options);

        configs[roomJid] = config;
        jabber.joinRoom(roomJid);
    }
}

function create(options) {
    _private.create(options);
}

