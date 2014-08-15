import QtQuick 1.1
import QXmpp 1.0
import Tulip 1.0

import "../../../Core/moment.js" as Moment
import "History.js" as Js
import "User.js" as UserJs

Item {
    id: root

    property string myJid
    property string historySaveInterval

    onHistorySaveIntervalChanged: root.checkHistoryInterval();

    onMyJidChanged: {
        Js.historyCache = {};
        root.checkHistoryInterval();
        daysTimer.startEx();
    }

    Timer {
        id: daysTimer

        function startEx() {
            var thisDay = Moment.moment().endOf('day'),
                dayEnd = thisDay - Moment.moment();

            daysTimer.interval = +dayEnd + 60000;
            daysTimer.start();
        }

        onTriggered: {
            root.checkHistoryInterval();
            daysTimer.startEx();
        }
    }

    QtObject {
        id: d

        function getMyHistoryRootPath() {
            return 'qml/messenger/history/' + root.myJid;
        }

        function getMyHistoryPath(bareJid) {
            return d.getMyHistoryRootPath() + '/' + bareJid;
        }

        function getMyHistoryPathWithDay(bareJid, day) {
            return d.getMyHistoryPath(bareJid) + '/' + day;
        }

        function getHistorySaveDuration() {
            if (root.historySaveInterval == "-1") {
                return false;
            }

            if (root.historySaveInterval == "0") {
                return true;
            }

            var interval = root.historySaveInterval.split(' ');

            return +Moment.moment().subtract(interval[0], interval[1]).startOf('day');
        }

        function getCheckMap(existingMessages) {
            if (!existingMessages) {
                return {};
            }

            var checkMap = {}
                , item
                , key
                , i;

            for (i = 0; i < existingMessages.count; i++) {
                item = existingMessages.get(i);
                key = Qt.md5(item.jid + item.text + item.date);
                checkMap[key] = true;
            }

            return checkMap;
        }
    }

    function checkHistoryInterval() {
        var jidList,
            duration = d.getHistorySaveDuration();

        if (duration === false || duration === true) {
            return;
        }

        try {
            jidList = JSON.parse(Settings.value(d.getMyHistoryRootPath(), 'jids' , '[]'));
        } catch(e) {
            jidList = []
        }

        jidList.forEach(function(e) {
            var dayList;

            try {
                dayList = JSON.parse(Settings.value(d.getMyHistoryPath(jid), 'days' , '[]'));
            } catch(e) {
                dayList = [];
            }

            var oldLength = dayList.length;

            dayList.forEach(function(key){
                if (key < duration) {
                    dayList.splice(dayList.indexOf(key), 1);
                    Settings.remove(d.getMyHistoryPathWithDay(e, key), '');
                }
            });

            if (oldLength != dayList.length) {
                Settings.setValue(d.getMyHistoryPath(e), 'days', JSON.stringify(dayList));
            }
        });
    }

    function clear() {
        Settings.remove('qml/messenger/history/' + xmppClient.myJid, '');
    }

    function save(jid, message, date) {
        if (d.getHistorySaveDuration() === false) {
            return;
        }

        if (message.type !== QXmppMessage.Chat || !message.body) {
            return;
        }

        var messageDate = date,
            bareJid = UserJs.jidWithoutResource(jid),
            day;

        if (message.stamp != "Invalid Date") {
            messageDate = +(Moment.moment(message.stamp));
        }

        day = +Moment.moment(messageDate).startOf('day');

        if (!Js.historyCache.hasOwnProperty(bareJid)) {
            Js.historyCache[bareJid] = {};
        }

        if (!Js.historyCache[bareJid][day]) {
            try {
                Js.historyCache[bareJid][day] =
                    JSON.parse(Settings.value(d.getMyHistoryPathWithDay(bareJid, day), 'history' , '[]'));
            } catch(e) {
                Js.historyCache[bareJid][day] = [];
            }
        }

        Js.historyCache[bareJid][day].unshift({
                              from: UserJs.jidWithoutResource(message.from),
                              body: message.body,
                              date: messageDate || +new Date()
                          });

        Settings.setValue(d.getMyHistoryPathWithDay(bareJid, day), 'history',
                          JSON.stringify(Js.historyCache[bareJid][day]));

        var dayList;
        try {
            dayList = JSON.parse(Settings.value(d.getMyHistoryPath(bareJid), 'days' , '[]'));
        } catch(e) {
            dayList = []
        }

        if (dayList.indexOf(day) == -1) {
            dayList.unshift(day);
            Settings.setValue(d.getMyHistoryPath(bareJid), 'days' , JSON.stringify(dayList));
        }

        var jidList;
        try {
            jidList = JSON.parse(Settings.value(d.getMyHistoryRootPath(), 'jids' , '[]'));
        } catch(e) {
            jidList = []
        }

        if (jidList.indexOf(bareJid) == -1) {
            jidList.unshift(bareJid);
            Settings.setValue(d.getMyHistoryRootPath(), 'jids' , JSON.stringify(jidList));
        }
    }

    function query(jid, from, to, existingMessages) {
        var cache
            , checkMap = d.getCheckMap(existingMessages);

        from = from || +(Moment.moment().startOf('day'));

        try {
            cache = JSON.parse(Settings.value(d.getMyHistoryPath(jid), 'days' , '[]'));
        } catch(e) {
            cache = [];
        }

        return cache.filter(function(key){
            if (to) {
                return (key >= from) && (key < to);
            }

            if (key == from) {
                return true;
            }

            return false;
        }).map(function(e){
            var history;
            try {
                history = JSON.parse(Settings.value(d.getMyHistoryPathWithDay(jid, e), 'history' , '{}'));
            } catch(e) {
                history = {};
            }

            return history.filter(function(elem){
                var key = Qt.md5(elem.from + elem.body + elem.date);
                return !checkMap.hasOwnProperty(key);
            });
        });
    }
}
