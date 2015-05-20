Qt.include("./MetaStorage.js");

/**
 * СonversationStorage
 *
 * Отвечает за загрузку и сохранение сообщений диалогов в базу данных.
 */
var ConversationStorage = {
    _db: null,
    _historySaveDuration: true,
    _jidWithoutResource: function(jid) {
        var pos = jid.indexOf('/');
        return pos < 0 ? jid : jid.substring(0, pos);
    },

    init: function(db) {
        this._db = db;

        var meta = new MetaStorage(this._db, 'Messages');
        meta.migrate(0, 1, [
            "CREATE TABLE IF NOT EXISTS Messages(" +
                '`id` INTEGER NOT NULL,' +
                '`chatName` TEXT NOT NULL,' +
                '`fromJid` TEXT,' +
                '`fromDispname`	TEXT,' +
                '`toJid` TEXT,' +
                '`toDispname`	TEXT,' +
                '`timestamp` INTEGER,' +
                '`body` TEXT,' +
                '`type` INTEGER,' +
                '`crc`	TEXT,' +
                'PRIMARY KEY(id),' +
                'UNIQUE(crc)' +
            ')',
            'CREATE INDEX IF NOT EXISTS IDX_Messages_TS ON Messages(chatName, timestamp)',
            'CREATE INDEX IF NOT EXISTS IDX_Messages_Crc ON Messages(crc)'
         ]);
    },

    setHistorySaveInterval: function(value) {
        this._historySaveDuration = value;
        if (typeof this._historySaveDuration !== 'number') {
            return;
        }

        //INFO Delete messages from history with date more then max allowed history.
        checkDataBaseResult(
            this._db.executeSql('DELETE FROM Messages WHERE timestamp < ?', [this._historySaveDuration])
        );
    },

    clear: function() {
        checkDataBaseResult(this._db.executeSql('DELETE FROM Messages'));
    },

    save: function(bareJid, message) {
        var res,
            messageDate,
            from,
            to,
            query,
            args,
            crc;

        if (!message.to) {
            message.to = bareJid;
        }

        messageDate = (message.stamp || Date.now())/1000|0;
        crc = Qt.md5(message.from + message.to + message.body + messageDate);

        if (this._historySaveDuration === false) {
            //Return special case id value if message can`t be stored
            return crc;
        }

        to = this._jidWithoutResource(message.to);
        from = this._jidWithoutResource(message.from||bareJid);

        // OR IGNORE
        query = "INSERT INTO Messages VALUES(NULL, ?, ?, '', ?, '', ?, ?, ?, ?)";
        args = [bareJid, from, to, messageDate, message.body, message.type, crc];

        res = this._db.executeSql(query, args);
        checkDataBaseResult(res);

        return res.insertId;
    },
    query: function(id, from, to) {
        var result = this._db.executeSql(
            "SELECT * FROM Messages WHERE chatname = ? AND timestamp >= ? AND timestamp <= ?",
            [id, from, to]
        );

        checkDataBaseResult(result);
        return result.rows || [];
    },

    queryLastMessageDate: function(id) {
        var result = this._db.executeSql(
            "SELECT MAX(timestamp) as `timestamp` FROM Messages WHERE chatname = ?", [id]
        );

        checkDataBaseResult(result);
        return result.rows[0].timestamp * 1000;
    }
};
