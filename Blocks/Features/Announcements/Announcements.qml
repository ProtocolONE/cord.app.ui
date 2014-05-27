import QtQuick 1.1
import Tulip 1.0

import "AnnouncementsHelper.js" as AnnouncementsHelper
import "../../../js/PopupHelper.js" as PopupHelper
import "../../../js/restapi.js" as RestApi
import "../../../js/Core.js" as Core
import "../../../js/GoogleAnalytics.js" as GoogleAnalytics
import "../../../Proxy/App.js" as AppProxy

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

    signal gameAcceptLicenseClicked(string serviceId);
    signal gameMissLicenseClicked(string serviceId);

    Component.onCompleted: _lastShownPopupDate = + (new Date());

    function showGameInstalledAnnounce(serviceId) {
        if (AnnouncementsHelper.isAnyGameStarted()) {
            return;
        }

        Marketing.send(Marketing.AnnouncementShown, serviceId, { type: "installedGame" });

        var gameItem = Core.serviceItemByServiceId(serviceId);

        PopupHelper.showPopup(artPopupComponent,
                              {
                                  popupType: "installedGame",
                                  serviceId: serviceId,
                                  gameItem: gameItem,
                                  message: qsTr("ANNOUNCE_GAME_INSTALLED_MESSAGE"),
                                  buttonCaption: qsTr("ANNOUNCE_GAME_INSTALLED_BUTTON"),
                                  messageFontSize: 16
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

        return true;
    }

    function showBigAnnouncement(announceItem) {
        Marketing.send(Marketing.AnnouncementShown,
                       announceItem.serviceId,
                       { type: "announcementBig", id: announceItem.id });
        bigAnnounceWindow.imageUrl = announceItem.image;
        bigAnnounceWindow.announceItem = announceItem;
        bigAnnounceWindow.buttonMessage = announceItem.textOnButton;
        bigAnnounceWindow.buttonStyle = announceItem.buttonColor;
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

        var gameItem = Core.serviceItemByServiceId(serviceId);
        PopupHelper.showPopup(artPopupComponent,
                              {
                                  popupType: "reminderNeverExecute",
                                  gameItem: gameItem,
                                  serviceId: serviceId,
                                  buttonCaption: buttonText,
                                  message: message,
                                  messageFontSize: 16
                              }, 'remindNeverExecute' + serviceId);
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
        PopupHelper.showPopup(artPopupComponent,
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
                        "300004010000000000",
                        "300002010000000000",
                        "300012010000000000",
                        "300005010000000000"];

        var now = +(new Date());

        for (var i = 0; i < services.length; ++i) {
            var serviceId = services[i];
            var installDate = +(Core.gameInstallDate(serviceId));
            if (!installDate) {
                continue;
            }

            var timeFromInstall = now - installDate;
            var elapsedDays = getDays(timeFromInstall);
            var elapsedWeeks = getWeeks(timeFromInstall);

            var lastExecuteDate = +(Core.gameLastExecutionTime(serviceId));
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
                    // 1. всплываем на следующий день
                    if (elapsedDays >= 1) {
                        showReminderNeverExecute(serviceId,
                                                 qsTr("REMINDER_NEVER_PLAYED_MESSAGE"),
                                                 qsTr("REMINDER_NEVER_PLAYED_BUTTON"));
                        return;
                    }
                } else {
                    // 2. в пятницу, суб, воскресенье
                    // 3. 7 дней с последнего показа
                    var timeBetweenLastShownAndNow = now - reminderNeverExecuteShowDate;
                    var dayOfWeek = (new Date()).getDay();
                    if ((getDays(timeBetweenLastShownAndNow) > 7)
                            || (getDays(timeBetweenLastShownAndNow) >= 1 && (dayOfWeek == 0 || dayOfWeek == 5 || dayOfWeek == 6)) ) {
                        showReminderNeverExecute(serviceId,
                                                 qsTr("REMINDER_NEVER_PLAYED_MESSAGE"),
                                                 qsTr("REMINDER_NEVER_PLAYED_BUTTON"));
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

        d.noLicenseRemind();

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

    QtObject {
        id: d

        function setNoLicenseRemindShown() {
            var today = Qt.formatDate(new Date(), "yyyy-MM-dd");
            Settings.setValue("qml/features/SilentMode", "showDate", today);
        }

        function isNoLicenseRemindShownToday() {
            var today = Qt.formatDate(new Date(), "yyyy-MM-dd");
            var showDate = Settings.value("qml/features/SilentMode", "showDate", 0);
            return (today == showDate);
        }

        function shouldNoLicenseRemind() {
            var installDate = Core.installDate();
            if (!installDate) {
                return false;
            }

            var duration = Math.floor((+ new Date()) / 1000) - installDate;
            return duration > 86400;
        }

        function noLicenseRemind() {
            if (AppProxy.isAnyLicenseAccepted()) {
                return;
            }

            if (!d.shouldNoLicenseRemind()) {
                return;
            }

            if (d.isNoLicenseRemindShownToday()) {
                return;
            }

            if (AppProxy.isWindowVisible()) {
                return;
            }

            d.setNoLicenseRemindShown();

            var installDate = Core.installDate(),
                currentDate = Math.floor((+ new Date()) / 1000);

            var serviceId = Settings.value("qGNA", "installWithService", "0");
            if (serviceId == "0") {
                serviceId = "300012010000000000"
            }

            var gameItem = Core.serviceItemByServiceId(serviceId),
                popUpOptions;

            if (gameItem.gameType != "standalone") {
                return;
            }

            var page = ('/silenceMode/reminder/art/%1').arg(serviceId);
            popUpOptions = {
                gameItem: gameItem,
                page: page,
                buttonCaption: qsTr("SILENT_REMIND_POPUP_BUTTON"),
                message: qsTr("SILENT_REMIND_POPUP_MESSAGE").arg(gameItem.licenseUrl),

            };

            //  INFO: костыль для решения тикета QGNA-702 - Тестирование новых всплывашек
            //  После окончания работ по выбору всплывашки - удалить код
            var alternativeIndex = (Math.floor(Math.random() * 100)) % 4;
            if (serviceId == "300009010000000000") {
                popUpOptions.page = ('/silenceMode/reminder/art/%1/%2').arg(serviceId).arg(alternativeIndex);
                popUpOptions.additionalParam = alternativeIndex;
            }

            PopupHelper.showPopup(artNoLicenseRemind, popUpOptions, 'silentModeRemider' + serviceId);
        }
    }

    Component {
        id: artNoLicenseRemind

        ArtPopup {
            id: popUp

            property string page

            onPlayClicked: {
                announcements.gameAcceptLicenseClicked(popUp.gameItem.serviceId);
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Action on Announcement', gameItem.gaName);
            }

            onAnywhereClicked: {
                announcements.gameMissLicenseClicked(popUp.gameItem.serviceId);
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Miss Click On Announcement', gameItem.gaName);
            }

            onCloseButtonClicked: {
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Close Announcement', gameItem.gaName);
            }

            Component.onCompleted: {
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Show Announcement', gameItem.gaName);
            }
        }
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
        id: artPopupComponent

        ArtPopup {
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

            Component.onCompleted: {
                GoogleAnalytics.trackEvent(
                            '/announcement/'+ popupType +'/' + serviceId,
                            'Announcement',
                            'Show Announcement',
                            remindGameItemPopup.gameItem.gaName);
                Marketing.send(Marketing.AnnouncementShown, serviceId, { type: popupType });

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
        property int buttonStyle: 1
        property alias buttonMessage: windowAnnounceButtonText.text

        property Gradient hoverGradientStyle1: Gradient {
            GradientStop { position: 0; color: "#257f02" }
            GradientStop { position: 1; color: "#257f02" }
        }

        property Gradient normalGradientStyle1: Gradient {
            GradientStop { position: 0; color: "#4ab120" }
            GradientStop { position: 1; color: "#257f02" }
        }

        property Gradient hoverGradientStyle2: Gradient {
            GradientStop { position: 0; color: "#e5761c" }
            GradientStop { position: 1; color: "#e5761c" }
        }

        property Gradient normalGradientStyle2: Gradient {
            GradientStop { position: 0; color: "#f29b55" }
            GradientStop { position: 1; color: "#e5761c" }
        }

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

                anchors { right: parent.right; top: parent.top; rightMargin: 2; topMargin: 2 }
                source: installPath + "images/CloseGrayBackground.png"
                opacity: closeButtonImageMouser.containsMouse ? 0.9 : 0.5

                Behavior on opacity {
                    NumberAnimation { duration: 225 }
                }
            }

            Image {
                anchors {
                    top: parent.top
                    topMargin: 2
                    left: parent.left
                    leftMargin: 2
                }

                source: installPath + "images/GameNetLogoGrayBackground.png"

                Elements.CursorMouseArea {
                    anchors.fill: parent
                    onClicked: AppProxy.openExternalUrl("http://gamenet.ru")
                }
            }

            Item {
                width: parent.width
                height: 107
                anchors.bottom: parent.bottom

                Rectangle {
                    anchors.fill: parent
                    color: "#000000"
                    opacity: 0.5
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: Math.max(40 + windowAnnounceButtonText.width, 300)
                    height: 64
                    color: "#FFFFFF"

                    Rectangle {
                        id: windowAnnounceButton

                        property Gradient hover: bigAnnounceWindow.buttonStyle == 1
                                                 ? bigAnnounceWindow.hoverGradientStyle1
                                                 : bigAnnounceWindow.hoverGradientStyle2

                        property Gradient normal: bigAnnounceWindow.buttonStyle == 1
                                                 ? bigAnnounceWindow.normalGradientStyle1
                                                 : bigAnnounceWindow.normalGradientStyle2

                        anchors { fill: parent; margins: 2 }
                        gradient: windowAnnounceButtonMouser.containsMouse ? windowAnnounceButton.hover : windowAnnounceButton.normal

                        Text {
                            id: windowAnnounceButtonText

                            anchors.centerIn: parent
                            color: "#ffffff"
                            font { family: "Arial"; pixelSize: 28}
                        }

                        Elements.CursorMouseArea {
                            id: windowAnnounceButtonMouser

                            anchors.fill: parent
                            hoverEnabled: true
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
                }
            }

            Rectangle {
                anchors {
                    fill: parent
                    rightMargin: 1
                    bottomMargin: 1
                }

                color: "#00000000"
                border {
                    width: 1
                    color: "#1e1b1b"
                }
            }
        }
    }
}
