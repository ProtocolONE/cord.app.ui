import QtQuick 2.4
import Application.Core.Settings 1.0

Item {
    id: root

    //UNDONE Migrate data
    function getHistory(jid) {
        var rootPath = 'qml/messenger/history/' + jid,
            storyBoard = [];

        try {
            var jidList = JSON.parse(AppSettings.value(rootPath, 'jids' , '[]'));
        } catch (e) {
            return [];
        }

        try {
            var dayList = JSON.parse(AppSettings.value(rootPath, 'days' , '[]'));
        } catch(e) {
            dayList = [];
        }

        dayList.forEach(function(day){
            try {
                var history = JSON.parse(AppSettings.value(rootPath + '/' + day, 'history' , '{}'));
            } catch(e) {
                history = [];
            }

            storyBoard = storyBoard.concat(history);
        });

        return storyBoard;
    }

    function clear(jid) {
        AppSettings.remove('qml/messenger/history/' + jid, '');
    }
}
