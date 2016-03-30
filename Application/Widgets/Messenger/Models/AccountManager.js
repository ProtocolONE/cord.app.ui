.pragma library

var _jabber = null,
    _messenger = null,
    _storageComponent,
    _storageInstance,
    _managerComponent,
    _managerInstance,
    _options,
    _private,
    _listModel;

function init(messenger, jabber, listModel, options) {
    if (_jabber !== null) {
        throw new Error('AccountsManager already initialized');
    }

    _options = options;
    _messenger = messenger;
    _listModel = listModel;
    _jabber = jabber;

    _storageComponent = Qt.createComponent('./Storage.qml');
    if (_storageComponent.status !== 1) {
        throw new Error('Can\'t create Storage.qml ' + _storageComponent.errorString());
    }
    _storageInstance = _storageComponent.createObject(listModel);

    _managerComponent = Qt.createComponent('./AccountManager.qml');
    if (_managerComponent.status !== 1) {
        throw new Error('Can\'t create AccountManager.qml ' + _managerComponent.errorString());
    }

    _managerInstance = _managerComponent.createObject(listModel);

    _jabber.vcardManager.vCardReceived.connect(_private.onUpdateAvatar);
}

function signalBus() {
    return _managerInstance;
}

_private = {
    defaultAvatarIndex: 0,

    getDefaultAvatar: function () {
        _private.defaultAvatarIndex = (_private.defaultAvatarIndex + 1) % 12;
        return "defaultAvatar_" + (_private.defaultAvatarIndex + 1) + ".png";
    },

    onUpdateAvatar: function(vcard) {
        var item = _messenger.getUser(vcard.from);
        if (!item.isValid()) {
            return;
        }

        if (vcard.extra && vcard.extra.PHOTOURL) {
            item.avatar = vcard.extra.PHOTOURL + "?width=44";
        } else {
            item.avatar = _options.defaultAvatarPath + _private.getDefaultAvatar();
        }

        item.vcardNickname = vcard.nickName || "";
    }
};
