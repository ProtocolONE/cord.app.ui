import QtQuick 1.1
import QXmpp 1.0
import Tulip 1.0

Item {
    id: root

    //UNDONE Migrate data
    function getHistory(jid) {
        var rootPath = 'qml/messenger/history/' + jid,
            storyBoard = [];

        try {
            var jidList = JSON.parse(Settings.value(rootPath, 'jids' , '[]'));
        } catch (e) {
            return [];
        }

        try {
            var dayList = JSON.parse(Settings.value(rootPath, 'days' , '[]'));
        } catch(e) {
            dayList = [];
        }

        dayList.forEach(function(day){
            try {
                var history = JSON.parse(Settings.value(rootPath + '/' + day, 'history' , '{}'));
            } catch(e) {
                history = [];
            }

            storyBoard = storyBoard.concat(history);
        });

        return storyBoard;
    }

    function clear(jid) {
        Settings.remove('qml/messenger/history/' + jid, '');
    }
}
