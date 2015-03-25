Qt.include("./MetaStorage.js");

/**
 * AccountStorage
 */
var AccountStorage = {
    _db: null,
    _jidWithoutResource: function(jid) {
        var pos = jid.indexOf('/');
        return pos < 0 ? jid : jid.substring(0, pos);
    },

    init: function(db) {
        this._db = db;

        var meta = new MetaStorage(this._db, 'Accounts');
        meta.migrate(0, 1, [
            "CREATE TABLE IF NOT EXISTS Accounts(" +
                '`jid` TEXT NOT NULL,' +
                '`avatar` TEXT,' +
                '`nickname` TEXT,' +
                '`displayName`	TEXT,' +
                '`lastTalkDate` INTEGER,' +
                '`type` INTEGER,' +
                'PRIMARY KEY(jid)' +
            ')'
         ]);
    },

    clear: function() {
        checkDataBaseResult(this._db.executeSql('DELETE FROM Accounts'));
    },

    save: function(bareJid, message) {
    },
    query: function(bareJid) {
    }
};
