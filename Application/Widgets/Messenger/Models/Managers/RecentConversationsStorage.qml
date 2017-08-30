import QtQuick 2.4
import Tulip 1.0

import Application.Core.Settings 1.0

import "../MetaStorage.js" as Ms
import "../User.js" as User

Item {
    id: root

    property variant db;

    function initDb(bareJid) {
        root.db = getDb(bareJid);

        var meta = new Ms.MetaStorage(root.db, 'RecentConversations'),
            jid,
            data,
            parsedData;

        meta.migrate(0, 1, [
            "CREATE TABLE IF NOT EXISTS RecentConversations(" +
                '`jid` TEXT,' +
                '`timestamp` INTEGER,' +
                'PRIMARY KEY(jid),' +
                'UNIQUE(jid)' +
            ')'
        ]);

        jid = User.jidToUser(bareJid);

        //INFO Migrate to new data structure
        data = AppSettings.value('qml/messenger/recentconversation/' + jid, 'lastTalkDate', "{}");
        try {
            parsedData = JSON.parse(data);
        } catch(e) {
            parsedData = {};
        }

        data = Object.keys(parsedData);
        data.map(function(e) {
            root.saveData(e, parsedData[e]);
        });
        AppSettings.remove('qml/messenger/recentconversation/' + jid, 'lastTalkDate');
    }

    function getDb(bareJid) {
        return LocalStorage.openDatabaseSync('/Account/' + bareJid + '/', 'main', 1, 'Main', 0);
    }

    function saveData(jid, time) {
        var res = root.db.executeSql(
            "INSERT OR REPLACE INTO RecentConversations VALUES(?, ?)",
            [jid, (time/1000)|0]
        );

        Ms.checkDataBaseResult(res);
    }

    function loadData() {
        var data = root.db.executeSql("SELECT jid, timestamp FROM RecentConversations"),
            ret = {};

        Ms.checkDataBaseResult(data);

        data.rows.forEach(function(e){
            ret[e.jid] = e.timestamp * 1000;
        });

        return ret;
    }

    function clear() {
        Ms.checkDataBaseResult(root.db.executeSql('DELETE FROM RecentConversations'));
    }
}

