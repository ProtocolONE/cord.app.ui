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

        var metaConversation = new MetaStorage(this._db, 'Conversation');
        metaConversation.migrate(0, 1, [
            "CREATE TABLE IF NOT EXISTS Conversation(" +
                '`chatName` TEXT NOT NULL,' +
                '`timestamp` INTEGER,' +
                'PRIMARY KEY(chatName)' +
            ')',
            'CREATE INDEX IF NOT EXISTS IDX_Conversation_TS ON Conversation(chatName)',
         ]);

        // It's time to clear messages older than this._historySaveDuration
        this.setHistorySaveInterval(this._historySaveDuration);
    },

    setHistorySaveInterval: function(value) {
        this._historySaveDuration = value;
        if (typeof this._historySaveDuration !== 'number') {
            return;
        }

        if (!this._db) {
            return;
        }

        //INFO Delete messages from history with date more then max allowed history.
        checkDataBaseResult(
            this._db.executeSql('DELETE FROM Messages WHERE timestamp < ?', [this._historySaveDuration])
        );
    },

    clear: function() {

        if (!this._db)
            return;

        checkDataBaseResult(this._db.executeSql('DELETE FROM Messages'));
        checkDataBaseResult(this._db.executeSql('DELETE FROM Conversation'));

        var now = Date.now()/1000;
        var query = "INSERT INTO Messages VALUES(NULL, 'history_separator', NULL, NULL, NULL, NULL, ?, NULL, NULL, NULL)";
        var args = [now];

        checkDataBaseResult(this._db.executeSql(query, args));
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

        var result = this._db.executeSql(
            "SELECT * FROM Messages WHERE chatName = ? AND timestamp >= ?",
            ["history_separator", messageDate]
        );

        checkDataBaseResult(result);
        console.log("result.rows.length: " + result.rows.length);
        if (result.rows.length > 0)
            return "";

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
            "SELECT * FROM Messages WHERE chatName = ? AND timestamp >= ? AND timestamp <= ?",
            [id, from, to]
        );

        checkDataBaseResult(result);
        return result.rows || [];
    },

    queryLastMessageDate: function(id) {
        var result = this._db.executeSql(
            "SELECT MAX(timestamp) as `timestamp` FROM Messages WHERE chatName = ?", [id]
        );

        checkDataBaseResult(result);
        return result.rows[0].timestamp;
    },

    saveReadDate: function(bareJid, date) {
        var result = this._db.executeSql(
            "INSERT OR REPLACE INTO Conversation VALUES(?, ?)",
            [bareJid, (date/1000)|0]
        );
        checkDataBaseResult(result);
        return true;
    },

    queryReadDate: function(bareJid) {
        var result = this._db.executeSql(
            "SELECT timestamp FROM Conversation WHERE chatName = ?",
            [bareJid]
        );

        checkDataBaseResult(result);
        return result.rows[0].timestamp * 1000;
    }

};
