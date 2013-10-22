import QtQuick 1.1
import Tulip 1.0

import "AnnouncementsHelper.js" as AnnouncementsHelper
import "../../../js/PopupHelper.js" as PopupHelper
import "../../../js/restapi.js" as RestApi
import "../../../js/Core.js" as Core
import "../../../js/GoogleAnalytics.js" as GoogleAnalytics

import "../../../Elements" as Elements

Item {
    id: announcements

    property variant _lastShownPopupDate
    property bool isAuthed: false
    property int normalPopupInerval: 1800000
    property int reshowWrongClosedAnnounceInterval: 43200000
    property int announceDyingInterval: 2100000

    signal gamePlayClicked(string serviceId);
    signal openUrlRequest(string url);
    signal missClicked(string serviceId);
    signal internalGameStarted(string serviceId);

    Component.onCompleted: _lastShownPopupDate = + (new Date());

    function showGameInstalledAnnounce(serviceId) {
        if (AnnouncementsHelper.isAnyGameStarted()) {
            return;
        }

        Marketing.send(Marketing.AnnouncementShown, serviceId, { type: "installedGame" });

        var gameItem = Core.serviceItemByServiceId(serviceId);

        PopupHelper.showPopup(remindAboutGamePopUp,
                              {
                                  popupType: "installedGame",
                                  serviceId: serviceId,
                                  gameItem: gameItem,
                                  message: qsTr("ANNOUNCE_GAME_INSTALLED_MESSAGE"),
                                  buttonCaption: qsTr("ANNOUNCE_GAME_INSTALLED_BUTTON"),
                              }, 'gameInstalledAnnounce' + serviceId);

        GoogleAnalytics.trackEvent('/announcement/installedGame/' + serviceId,
                                   'Announcement', 'Show Announcement', gameItem.gaName);
    }

    function gameStartedCallback(serviceId) {
        Settings.setValue("qml/Announcements/", "AnyGameStarted", 1);
        Settings.setValue("qml/Announcements2/reminderExecuteLongAgo/" + serviceId + "/", "showDate", "");
        AnnouncementsHelper.onGameStarted();
        logicTimer.stop();
        internalGameStarted(serviceId);
    }

    function gameClosedCallback() {
        AnnouncementsHelper.onGameClosed();
        if (!AnnouncementsHelper.isAnyGameStarted()) {
            logicTick();
        }
    }

    function isGameExecuted(serviceId) {
        var succes = parseInt(Settings.value("gameExecutor/serviceInfo/" + serviceId + "/", "successCount", "0"), 10);
        var fail = parseInt(Settings.value("gameExecutor/serviceInfo/" + serviceId + "/", "failedCount", "0"), 10);
        return (succes + fail) > 0;
    }

    function getShownDate(announceId) {
        return parseInt(Settings.value("qml/Announcements2/" + announceId + "/", "showDate", ""), 10);
    }

    function setShownDate(announceId, date) {
        Settings.setValue("qml/Announcements2/" + announceId + "/", "showDate", date);
    }

    function getReminderExecuteLongAgoShowDate(serviceId) {
        return parseInt(Settings.value("qml/Announcements2/reminderExecuteLongAgo/" + serviceId + "/", "showDate", ""), 10);
    }

    function getReminderNeverExecuteShowDate(serviceId) {
        return parseInt(Settings.value("qml/Announcements2/reminderNeverExecute/" + serviceId + "/", "showDate", ""), 10);
    }

    function isClosedProperly(announceId) {
        return Settings.value("qml/Announcements2/" + announceId + "/", "closedRight", "") == 1;
    }

    function setClosedProperly(announceId, isClosedRight) {
        Settings.setValue("qml/Announcements2/" + announceId + "/", "closedRight", isClosedRight ? 1 : 0);
    }

    function showSmallAnnouncement(announceItem) {
        Marketing.send(Marketing.AnnouncementShown,
                       announceItem.serviceId,
                       { type: "announcementSmall", id: announceItem.id });

        var gameItem = Core.serviceItemByServiceId(announceItem.serviceId);
        PopupHelper.showPopup(announceGameItemPopUp,
                              {
                                  gameItem: gameItem,
                                  message: announceItem.text,
                                  buttonCaption: announceItem.textOnButton,
                                  announceItem: announceItem
                              }, 'announce' + announceItem.id);

        GoogleAnalytics.trackEvent('/announcement/small/' + announceItem.id,
                                   'Announcement', 'Show Announcement', gameItem.gaName);
    }


    function isAnnounceValid(announce) {
        var shownDate = getShownDate(announce.id);
        if (shownDate) {
            return false;
        }

        if (isClosedProperly(announce.id)) {
            return false;
        }

        var playedServiceId = announce.playedServiceId;
        if (playedServiceId) {
            if (!isGameExecuted(playedServiceId)) {
                return false;
            }
        }

        return true;
    }

    function showBigAnnouncement(announceItem) {
        Marketing.send(Marketing.AnnouncementShown,
                       announceItem.serviceId,
                       { type: "announcementBig", id: announceItem.id });
        bigAnnounceWindow.imageUrl = announceItem.image;
        bigAnnounceWindow.announceItem = announceItem;
        bigAnnounceWindow.visible = true

        var gameItem = Core.serviceItemByServiceId(announceItem.serviceId);
        GoogleAnalytics.trackEvent('/announcement/big/' + announceItem.id,
                                   'Announcement', 'Show Announcement', gameItem.gaName);
    }

    function showAnnouncement(announceItem) {
        if (!announceItem) {
            return;
        }

        if (announceItem.size === "small") {
            showSmallAnnouncement(announceItem);
        } else if (announceItem.size === "big") {
            showBigAnnouncement(announceItem);
        } else {
            console.log('unknown announce size ', JSON.stringify(announceItem));
        }
    }

    function checkAndShowDyingAnnouncements() {
        if (!AnnouncementsHelper.announceList)
            return;

        for (var index in AnnouncementsHelper.announceList) {
            if (!AnnouncementsHelper.announceList.hasOwnProperty(index)) {
                continue;
            }

            var announce = AnnouncementsHelper.announceList[index];
            if (!announce) {
                continue;
            }

            var id = announce.id;
            var startDate = +(new Date(parseInt(announce.startTime, 10) * 1000)),
                endDate = +(new Date(parseInt(announce.endTime, 10) * 1000));

            var now = +(new Date());
            if (endDate < now || endDate > new Date(now + announceDyingInterval)) {
                // уже мертвое или не протухающее
                continue;
            }

            if (!isAnnounceValid(announce)) {
                continue;
            }

            showAnnouncement(announce);
        }
    }

    function showNextAnnouncement() {
        var now = +(new Date()),
            foundStartDate,
            foundItem;

        for (var index in AnnouncementsHelper.announceList) {
            if (!AnnouncementsHelper.announceList.hasOwnProperty(index)) {
                continue;
            }

            var announce = AnnouncementsHelper.announceList[index];
            if (!announce) {
                continue;
            }

            var id = announce.id;
            var startDate = +(new Date(parseInt(announce.startTime, 10) * 1000)),
                endDate = +(new Date(parseInt(announce.endTime, 10) * 1000));

            if (now < startDate || now > endDate) {
                continue;
            }

            if (isClosedProperly(id)) {
                continue;
            }

            var playedServiceId = announce.playedServiceId;
            if (playedServiceId > 0) {
                if (!isGameExecuted(playedServiceId)) {
                    continue;
                }
            }

            var lastShownDate = getShownDate(id);
            if (!lastShownDate) {
                if (!foundItem || foundStartDate > startDate) {
                    foundItem = announce;
                    foundStartDate = startDate;
                }

                continue;
            }

            if ((now - lastShownDate) > reshowWrongClosedAnnounceInterval) {
                if (!foundItem || foundStartDate > startDate) {
                    foundItem = announce;
                    foundStartDate = startDate;
                }
            }
        }

        if (foundItem) {
            setShownDate(foundItem.id, now);
            _lastShownPopupDate = now;
            showAnnouncement(foundItem);
        }
    }

    function getDays(timespan) {
        return Math.floor(timespan / 86400000);
    }

    function getWeeks(timespan) {
        return Math.floor(getDays(timespan) / 7);
    }

    function showReminderNeverExecute(serviceId, message, buttonText) {
        var now = +(new Date());
        Settings.setValue("qml/Announcements2/reminderNeverExecute/" + serviceId + "/", "showDate", now);
        Marketing.send(Marketing.AnnouncementShown, serviceId, { type: "reminderNeverExecute" });

        var gameItem = Core.serviceItemByServiceId(serviceId);
        PopupHelper.showPopup(remindAboutGamePopUp,
                              {
                                  popupType: "reminderNeverExecute",
                                  gameItem: gameItem,
                                  serviceId: serviceId,
                                  buttonCaption: buttonText,
                                  message: message
                              }, 'remindNeverExecute' + serviceId);

        GoogleAnalytics.trackEvent('/announcement/reminderNeverExecute/' + serviceId,
                                   'Announcement', 'Show Announcement', gameItem.gaName);

    }

    function showReminderLongTimeExecute(serviceId) {
        //INFO На момент 9 июля 2013 эффективность этого окна порядка 3,75%. В тоже время оно сильно раздражает
        //особенно если у тебя много установленных игр. При запуске обновленного QGNA принято решение временно
        //выключить этот функционал, чтобы доработать его и сделать менее раздражающим. Подробности у Бондаренко.
        return;

        var now = +(new Date());
        Settings.setValue("qml/Announcements2/reminderExecuteLongAgo/" + serviceId + "/", "showDate", now);
        Marketing.send(Marketing.AnnouncementShown, serviceId, { type: "reminderExecuteLongAgo" });

        var gameItem = Core.serviceItemByServiceId(serviceId);
        PopupHelper.showPopup(remindAboutGamePopUp,
                              {
                                  popupType: "reminderExecuteLongAgo",
                                  gameItem: gameItem,
                                  serviceId: serviceId,
                                  buttonCaption: qsTr("REMINDER_PLAYED_LONGAGO_BUTTON"),
                                  message: qsTr("REMINDER_PLAYED_LONGAGO_MESSAGE")
                              }, 'remindLongTimeAgo' + serviceId);

        GoogleAnalytics.trackEvent('/announcement/reminderExecuteLongAgo/' + serviceId,
                                   'Announcement', 'Show Announcement', gameItem.gaName);
    }

    function showNextReminder() {
        // TODO: в будущем может стоит бегать по коллекции сервисов
        var services = ["300009010000000000",
                        "300003010000000000",
                        "300006010000000000",
                        "300005010000000000",
                        "300002010000000000"];

        var now = +(new Date());

        for (var i = 0; i < services.length; ++i) {
            var serviceId = services[i];
            var installDate = +(Settings.value("GameDownloader/" + serviceId + "/", "installDate", ""));
            if (!installDate) {
                continue;
            }

            var timeFromInstall = now - installDate;
            var elapsedDays = getDays(timeFromInstall);
            var elapsedWeeks = getWeeks(timeFromInstall);

            var lastExecuteDate = +(Settings.value("gameExecutor/serviceInfo/" + serviceId + "/", "lastExecutionTime", ""));
            if (lastExecuteDate) {
                // игру запускали давно
                var reminderExecuteLongAgoShowDate = getReminderExecuteLongAgoShowDate(serviceId);
                var timeFromExecute = now - lastExecuteDate;
                var elapsedWeeksFromExecute = getWeeks(timeFromExecute);

                if (!reminderExecuteLongAgoShowDate) {
                    if (elapsedWeeksFromExecute >= 1) {
                        showReminderLongTimeExecute(serviceId);
                        return;
                    }
                } else {
                    var timeBetweenLastShownAndExecuteTime = reminderExecuteLongAgoShowDate - lastExecuteDate;
                    var showLongAgoWeeks = getWeeks(timeBetweenLastShownAndExecuteTime);
                    if (elapsedWeeksFromExecute > showLongAgoWeeks) {
                        showReminderLongTimeExecute(serviceId);
                        return;
                    }
                }
            } else {
                // игру не запускали - игра ни разу не запускалась
                var reminderNeverExecuteShowDate = getReminderNeverExecuteShowDate(serviceId);
                if (!reminderNeverExecuteShowDate) {
                    if (elapsedDays >= 1) {
                        if (!isAuthed) {
                            showReminderNeverExecute(serviceId,
                                                     qsTr("REMINDER_NEVER_PLAYED_FRIST_TIME_MESSAGE"),
                                                     qsTr("REMINDER_NEVER_PLAYED_FRIST_TIME_BUTTON"));
                        } else {
                            showReminderNeverExecute(serviceId,
                                                     qsTr("REMINDER_NEVER_PLAYED_MESSAGE"),
                                                     qsTr("REMINDER_NEVER_PLAYED_BUTTON"));
                        }
                        return;
                    }
                } else {
                    var timeBetweenLastShownAndInstallDate = reminderNeverExecuteShowDate - installDate;
                    var showNeverExecutenWeeks = getWeeks(timeBetweenLastShownAndInstallDate);
                    if (elapsedWeeks > showNeverExecutenWeeks) {
                        if (elapsedWeeks === 1 || ((elapsedWeeks - showNeverExecutenWeeks) >= 2)) {
                            showReminderNeverExecute(serviceId,
                                                     qsTr("REMINDER_NEVER_PLAYED_MESSAGE"),
                                                     qsTr("REMINDER_NEVER_PLAYED_BUTTON"));
                            return;
                        }
                    }
                }
            }
        }
    }

    function getLogicTickInterval() {
        var now =  (+new Date());
        var nextTick = (_lastShownPopupDate + normalPopupInerval) < now
                ? now + normalPopupInerval
                : _lastShownPopupDate + normalPopupInerval;

        if (AnnouncementsHelper.announceList) {
            for (var index in AnnouncementsHelper.announceList) {
                if (!AnnouncementsHelper.announceList.hasOwnProperty(index)) {
                    continue;
                }

                var announce = AnnouncementsHelper.announceList[index];
                if (!announce) {
                    continue;
                }

                var id = announce.id;
                var startDate = +(new Date(parseInt(announce.startTime, 10) * 1000)),
                    endDate = +(new Date(parseInt(announce.endTime, 10) * 1000));

                // уже мертвое или не протухающее
                if (endDate < now || endDate > now + announceDyingInterval) {
                    continue;
                }

                if (!isAnnounceValid(announce)) {
                    continue;
                }

                var currentNextTick = endDate - announceDyingInterval;
                if (nextTick > currentNextTick) {
                    nextTick = currentNextTick;
                }
            }
        }

        return Math.max(3000, nextTick - (+now));
    }

    function logicTick() {
        logicTimer.stop();

        if (AnnouncementsHelper.isAnyGameStarted()) {
            return;
        }

        checkAndShowDyingAnnouncements();

        var now = +(new Date());
        if ((now - _lastShownPopupDate) > normalPopupInerval) {
            showNextAnnouncement();
        }

        if ((now - _lastShownPopupDate) > normalPopupInerval) {
            showNextReminder();
        }

        logicTimer.interval = getLogicTickInterval();
        logicTimer.start();
    }

    function getAnnouncementSuccessCallback(response) {
        // схораняем без обработки - так как в целом они не нужна
        AnnouncementsHelper.announceList = response.announcement;
        logicTick();
    }

    function announceCloseClick(announceItem) {
        setClosedProperly(announceItem.id, true);
    }

    function announceActionClick(announceItem) {
        if (announceItem.url) {
            openUrlRequest(announceItem.url)
        } else {
            gamePlayClicked(announceItem.serviceId);
        }

        setClosedProperly(announceItem.id, true);
    }

    Component {
        id: announceGameItemPopUp

        Elements.GameItemPopUp {
            id: announcePopUp

            property variant announceItem
            state: "Orange"

            function sendAnnouncementActionClicked() {
                Marketing.send(Marketing.AnnouncementActionClicked,
                               announceItem.serviceId,
                               { type: "announcementSmall", id: announceItem.id });
                var gameItem = Core.serviceItemByServiceId(announceItem.serviceId);
                GoogleAnalytics.trackEvent('/announcement/small/' + announceItem.id,
                                           'Announcement', 'Action on Announcement', gameItem.gaName);
            }

            Connections {
                target: announcements
                onInternalGameStarted: {
                    if (!announceItem || !announceItem.serviceId) {
                        return;
                    }

                    if (serviceId == announceItem.serviceId && !announceItem.url) {
                        announcePopUp.sendAnnouncementActionClicked();
                        announcements.setClosedProperly(announceItem.id, true);
                        shadowDestroy();
                    }
                }
            }

            onAnywhereClicked: {
                Marketing.send(Marketing.AnnouncementMissClicked,
                               announceItem.serviceId,
                               { type: "announcementSmall", id: announceItem.id });

                if (announceItem.url) {
                    announcements.announceActionClick(announceItem);
                    return;
                }

                announcements.missClicked(announceItem.serviceId);

                var gameItem = Core.serviceItemByServiceId(announceItem.serviceId);
                GoogleAnalytics.trackEvent('/announcement/small/' + announceItem.id,
                                           'Announcement', 'Miss Click On Announcement', gameItem.gaName);

            }

            onPlayClicked: {
                announcePopUp.sendAnnouncementActionClicked();
                announcements.announceActionClick(announceItem);                
            }

            onCloseButtonClicked: {
                Marketing.send(Marketing.AnnouncementClosedClicked,
                               announceItem.serviceId,
                               { type: "announcementSmall", id: announceItem.id });
                announcements.announceCloseClick(announceItem);

                var gameItem = Core.serviceItemByServiceId(announceItem.serviceId);
                GoogleAnalytics.trackEvent('/announcement/small/' + announceItem.id,
                                           'Announcement', 'Close Announcement', gameItem.gaName);
            }
        }
    }

    Component {
        id: remindAboutGamePopUp

        Elements.GameItemPopUp {
            id: remindGameItemPopup

            property variant serviceId: ""
            property variant popupType: "unknown"

            function sendAnnouncementActionClicked() {
                Marketing.send(Marketing.AnnouncementActionClicked, serviceId, { type: popupType });

                var gameItem = Core.serviceItemByServiceId(serviceId);
                GoogleAnalytics.trackEvent('/announcement/'+ popupType +'/' + serviceId,
                                           'Announcement', 'Action on Announcement', gameItem.gaName);
            }

            Connections {
                target: announcements
                onInternalGameStarted: {
                    if (remindGameItemPopup.serviceId == serviceId) {
                        remindGameItemPopup.sendAnnouncementActionClicked();
                        shadowDestroy();
                    }
                }
            }

            state: "Green"
            onAnywhereClicked: {
                Marketing.send(Marketing.AnnouncementMissClicked, serviceId, { type: popupType });
                announcements.missClicked(serviceId);

                var gameItem = Core.serviceItemByServiceId(serviceId);
                GoogleAnalytics.trackEvent('/announcement/'+ popupType +'/' + serviceId,
                                           'Announcement', 'Miss Click On Announcement', gameItem.gaName);
            }

            onCloseButtonClicked: {
                Marketing.send(Marketing.AnnouncementClosedClicked, serviceId, { type: popupType });

                var gameItem = Core.serviceItemByServiceId(serviceId);
                GoogleAnalytics.trackEvent('/announcement/'+ popupType +'/' + serviceId,
                                           'Announcement', 'Close Announcement', gameItem.gaName);
            }

            onPlayClicked: {
                remindGameItemPopup.sendAnnouncementActionClicked();
                announcements.gamePlayClicked(serviceId);
            }
        }
    }

    Timer {
        id: logicTimer

        repeat: true
        running: false
        triggeredOnStart: false
        onTriggered: logicTick();
    }

    Timer {
        id: refreshTimer

        interval: 10800000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            logicTimer.stop();
            RestApi.Games.getAnnouncement(getAnnouncementSuccessCallback, function (){});
        }
    }

    Window {
        id: bigAnnounceWindow

        property string imageUrl: ""
        property variant announceItem

        width: 900
        height: 500
        x: Desktop.primaryScreenAvailableGeometry.x + (Desktop.primaryScreenAvailableGeometry.width - width) / 2
        y: Desktop.primaryScreenAvailableGeometry.y + (Desktop.primaryScreenAvailableGeometry.height - height) / 2

        flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
        deleteOnClose: false

        function sendAnnouncementActionClicked() {
            Marketing.send(Marketing.AnnouncementActionClicked,
                           bigAnnounceWindow.announceItem.serviceId,
                           { type: "announcementBig", id: bigAnnounceWindow.announceItem.id });

            var gameItem = Core.serviceItemByServiceId(bigAnnounceWindow.announceItem.serviceId);
            GoogleAnalytics.trackEvent('/announcement/big/' + bigAnnounceWindow.announceItem.id,
                                       'Announcement', 'Show Announcement', gameItem.gaName);
        }

        function close() {
            Marketing.send(Marketing.AnnouncementClosedClicked,
                           bigAnnounceWindow.announceItem.serviceId,
                           { type: "announcementBig", id: bigAnnounceWindow.announceItem.id });

            bigAnnounceWindow.visible = false;
            announcements.announceCloseClick(bigAnnounceWindow.announceItem);

            var gameItem = Core.serviceItemByServiceId(bigAnnounceWindow.announceItem.serviceId);
            GoogleAnalytics.trackEvent('/announcement/big/' + bigAnnounceWindow.announceItem.id, 'Announcement', 'Close Announcement', gameItem.gaName);
        }

        Connections {
            target: announcements
            onInternalGameStarted: {
                if (!bigAnnounceWindow.announceItem || !bigAnnounceWindow.announceItem.serviceId) {
                    return;
                }

                if (serviceId == bigAnnounceWindow.announceItem.serviceId && !bigAnnounceWindow.announceItem.url) {
                    bigAnnounceWindow.sendAnnouncementActionClicked();
                    announcements.setClosedProperly(bigAnnounceWindow.announceItem.id, true);
                    bigAnnounceWindow.visible = false;
                }
            }
        }

        Item {
            anchors.fill: parent

            Image {
                anchors.fill: parent
                source: bigAnnounceWindow.imageUrl

                Elements.CursorMouseArea {
                    hoverEnabled: true
                    anchors.fill: parent

                    onClicked: {
                        bigAnnounceWindow.sendAnnouncementActionClicked();
                        bigAnnounceWindow.visible = false
                        announcements.announceActionClick(bigAnnounceWindow.announceItem);

                        var gameItem = Core.serviceItemByServiceId(bigAnnounceWindow.announceItem.serviceId);
                        GoogleAnalytics.trackEvent('/announcement/big/' + bigAnnounceWindow.announceItem.id,
                                                   'Announcement', 'Action on Announcement', gameItem.gaName);
                    }
                }
            }

            Elements.CursorMouseArea {
                id: closeButtonImageMouser

                width: 40
                height: 40
                hoverEnabled: true
                anchors { right: parent.right; top: parent.top; }
                onClicked: bigAnnounceWindow.close()
            }

            Image {
                id: closeButtonImage

                anchors { right: parent.right; top: parent.top; rightMargin: 9; topMargin: 9 }
                source: installPath + "images/closeButton.png"
                opacity: closeButtonImageMouser.containsMouse ? 0.9 : 0.5

                Behavior on opacity {
                    NumberAnimation { duration: 225 }
                }
            }
        }
    }
}
