/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0
import Application.Blocks 1.0
import Application.Core 1.0
import Application.Core.Settings 1.0

import "./AnnouncementsModel.js" as AnnouncementsHelper

WidgetModel {
    id: announcements

    property variant _lastShownPopupDate: 0
    property int normalPopupInerval: 1800000
    property int reshowWrongClosedAnnounceInterval: 43200000
    property int announceDyingInterval: 2100000

    signal gamePlayClicked(string serviceId);
    signal openUrlRequest(string url);
    signal missClicked(string serviceId);
    signal internalGameStarted(string serviceId);

    signal gameAcceptLicenseClicked(string serviceId);
    signal gameMissLicenseClicked(string serviceId);

    settings: WidgetSettings {
        namespace: 'Announcements'

        property int bigAnnouncementStopDate: 0
        property int smallAnnouncementStopDate: 0
        property bool showGameInstallNoExecuteReminder: true
    }

    Component.onCompleted: _lastShownPopupDate = + (new Date());

    function checkIsAnnouncementBlocked(announceItem) {
        if (!announceItem) {
            return false;
        }

        if (announceItem.size === "small") {
            return announcements.settings.smallAnnouncementStopDate > 0;
        } else if (announceItem.size === "big") {
            return announcements.settings.bigAnnouncementStopDate > 0;
        }

        return false;
    }

    function showGameInstalledAnnounce(serviceId) {
        if (AnnouncementsHelper.isAnyGameStarted()) {
            return;
        }

        Marketing.send(Marketing.AnnouncementShown, serviceId, { type: "InstalledGame", userId: User.userId()});

        var gameItem = App.serviceItemByServiceId(serviceId);

        TrayPopup.showPopup(artPopupComponent,
                              {
                                  popupType: "InstalledGame",
                                  serviceId: serviceId,
                                  gameItem: gameItem,
                                  message: qsTr("ANNOUNCE_GAME_INSTALLED_MESSAGE"),
                                  buttonCaption: qsTr("ANNOUNCE_GAME_INSTALLED_BUTTON"),
                                  messageFontSize: 16
                              }, 'gameInstalledAnnounce' + serviceId);

        Ga.trackEvent('Announcement InstalledGame', 'show', gameItem.gaName);
    }

    function gameStartedCallback(serviceId) {
        AppSettings.setValue("qml/Announcements/", "AnyGameStarted", 1);
        AppSettings.setValue("qml/Announcements2/reminderExecuteLongAgo/" + serviceId + "/", "showDate", "");
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
        return parseInt(AppSettings.value("qml/Announcements2/" + announceId + "/", "showDate", ""), 10);
    }

    function setShownDate(announceId, date) {
        AppSettings.setValue("qml/Announcements2/" + announceId + "/", "showDate", date);
    }

    function getReminderNeverExecuteShowDate(serviceId) {
        return parseInt(AppSettings.value("qml/Announcements2/reminderNeverExecute/" + serviceId + "/", "showDate", ""), 10);
    }

    function isClosedProperly(announceId) {
        return AppSettings.value("qml/Announcements2/" + announceId + "/", "closedRight", "") == 1;
    }

    function setClosedProperly(announceId, isClosedRight) {
        AppSettings.setValue("qml/Announcements2/" + announceId + "/", "closedRight", isClosedRight ? 1 : 0);
    }

    function showSmallAnnouncement(announceItem) {
        Marketing.send(Marketing.AnnouncementShown,
                       announceItem.serviceId,
                       { type: "announcementSmall", id: announceItem.id, userId: User.userId() });

        var gameItem = App.serviceItemByServiceId(announceItem.serviceId);
        TrayPopup.showPopup(announceGameItemPopUp,
                              {
                                  gameItem: gameItem,
                                  message: announceItem.text,
                                  image: announceItem.image,
                                  buttonCaption: announceItem.textOnButton,
                                  announceItem: announceItem
                              }, 'announce' + announceItem.id);

        Ga.trackEvent('Announcement Small ' + announceItem.id, 'show', gameItem.gaName);
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
                       { type: "announcementBig", id: announceItem.id, userId: User.userId() });

        bigAnnounceWindow.imageUrl = announceItem.image;
        bigAnnounceWindow.announceItem = announceItem;
        bigAnnounceWindow.buttonMessage = announceItem.textOnButton;
        bigAnnounceWindow.buttonStyle = announceItem.buttonColor;
        bigAnnounceWindow.visible = true

        var gameItem = App.serviceItemByServiceId(announceItem.serviceId);
        Ga.trackEvent('Announcement Big ' + announceItem.id, 'show', gameItem.gaName);
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

            if (announcements.checkIsAnnouncementBlocked(announce)) {
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

            if (announcements.checkIsAnnouncementBlocked(announce)) {
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
        AppSettings.setValue("qml/Announcements2/reminderNeverExecute/" + serviceId + "/", "showDate", now);

        var gameItem = App.serviceItemByServiceId(serviceId);

        TrayPopup.hidePopup('gameInstalledAnnounce' + serviceId);
        TrayPopup.showPopup(artPopupComponent,
                              {
                                  popupType: "ReminderNeverExecute",
                                  gameItem: gameItem,
                                  serviceId: serviceId,
                                  buttonCaption: buttonText,
                                  message: message,
                                  messageFontSize: 16
                              }, 'remindNeverExecute' + serviceId);
    }

    function showNextReminder() {
        if (!announcements.settings.showGameInstallNoExecuteReminder) {
            return;
        }

        var services = App.getRegisteredServices()
            , serviceId
            , installDate
            , timeFromInstall
            , elapsedDays
            , lastExecuteDate;
        var now = (+new Date());

        for (var i = 0, len = services.length; i < len; ++i) {
            serviceId = services[i];
            installDate = +(ApplicationStatistic.gameInstallDate(serviceId));
            if (!installDate) {
                continue;
            }

            timeFromInstall = now - installDate;
            elapsedDays = getDays(timeFromInstall);

            lastExecuteDate = +(ApplicationStatistic.gameLastExecutionTime(serviceId));
            if (!lastExecuteDate) {
                checkReminderNeverExecute(serviceId, elapsedDays)
            }
        }
    }

    function checkReminderNeverExecute(serviceId, elapsedDays) {
        var reminderNeverExecuteShowDate = getReminderNeverExecuteShowDate(serviceId)
            , now = +(new Date())
            , daysBetweenLastShownAndNow
            , dayOfWeek;

        // игру не запускали - игра ни разу не запускалась
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
            daysBetweenLastShownAndNow = getDays(now - reminderNeverExecuteShowDate);
            dayOfWeek = (new Date()).getDay();
            if (daysBetweenLastShownAndNow > 7
                || (daysBetweenLastShownAndNow >= 1 && (dayOfWeek == 0 || dayOfWeek == 5 || dayOfWeek == 6))) {

                showReminderNeverExecute(serviceId,
                                         qsTr("REMINDER_NEVER_PLAYED_MESSAGE"),
                                         qsTr("REMINDER_NEVER_PLAYED_BUTTON"));
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

        //Мы снова должны выполнить проверку, т.к. showNextAnnouncement модифицирует _lastShownPopupDate
        if ((now - _lastShownPopupDate) > normalPopupInerval) {
            showNextReminder();
        }

        logicTimer.interval = getLogicTickInterval();
        logicTimer.start();
    }

    function getAnnouncementSuccessCallback(response) {
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

    Connections {
        target: SignalBus
        onServiceStarted: gameStartedCallback(gameItem.serviceId)
        onServiceFinished: gameClosedCallback(gameItem.serviceId)
        onServiceInstalled: {
            if (!App.isWindowVisible()) {
                announcements.showGameInstalledAnnounce(gameItem.serviceId);
            }
        }
    }

    Connections {
        target: announcements

        onGamePlayClicked: {
            if (!serviceId || serviceId == 0) {
                console.log('bad service id ' + serviceId);
                return;
            }

            var item = App.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('bad service id ' + serviceId);
                return;
            }

            SignalBus.selectService(serviceId);
            App.activateWindow();
            App.downloadButtonStart(serviceId);
        }

        onMissClicked: {
            SignalBus.selectService(serviceId);
            App.activateWindow();
        }

        onGameAcceptLicenseClicked: {
            SignalBus.selectService(serviceId);

            var item = App.serviceItemByServiceId(serviceId);
            if (App.isAnyLicenseAccepted() || !item || item.gameType != "standalone") {
                App.activateWindow();
                return;
            }

            var path = App.getExpectedInstallPath(serviceId);
            App.setServiceInstallPath(serviceId, path);
            App.gameSettingsModelInstance().createShortcutOnDesktop(serviceId);
            App.gameSettingsModelInstance().createShortcutInMainMenu(serviceId);
            App.acceptFirstLicense(serviceId);
            App.downloadButtonStart(serviceId);
        }

        onGameMissLicenseClicked: {
            SignalBus.selectService(serviceId);
            var item = App.serviceItemByServiceId(serviceId);
            if (App.isAnyLicenseAccepted() || !item || item.gameType != "standalone") {
                App.activateWindow();
                return;
            }

            SignalBus.selectService(serviceId);
            App.activateWindow();
        }

        onOpenUrlRequest: App.openExternalUrlWithAuth(url)
    }

    QtObject {
        id: d

        function setNoLicenseRemindShown() {
            var today = Qt.formatDate(new Date(), "yyyy-MM-dd");
            AppSettings.setValue("qml/features/SilentMode", "showDate", today);
        }

        function isNoLicenseRemindShownToday() {
            var today = Qt.formatDate(new Date(), "yyyy-MM-dd");
            var showDate = AppSettings.value("qml/features/SilentMode", "showDate", 0);
            return (today == showDate);
        }

        function shouldNoLicenseRemind() {
            var installDate = ApplicationStatistic.installDate();
            if (!installDate) {
                return false;
            }

            var duration = Math.floor((+ new Date()) / 1000) - installDate;
            return duration > 86400;
        }

        function noLicenseRemind() {
            if (App.isAnyLicenseAccepted()) {
                return;
            }

            if (!d.shouldNoLicenseRemind()) {
                return;
            }

            if (d.isNoLicenseRemindShownToday()) {
                return;
            }

            if (App.isWindowVisible()) {
                return;
            }

            d.setNoLicenseRemindShown();

            var installDate = ApplicationStatistic.installDate(),
                currentDate = Math.floor((+ new Date()) / 1000);

            var serviceId = ApplicationStatistic.installWithService();
            if (serviceId == "0") {
                serviceId = "300012010000000000"
            }

            var gameItem = App.serviceItemByServiceId(serviceId),
                popUpOptions;

            if (gameItem.gameType != "standalone") {
                return;
            }

            var page = ('/silenceMode/reminder/art/%1').arg(serviceId)

            popUpOptions = {
                gameItem: gameItem,
                page: page,
                buttonCaption: qsTr("SILENT_REMIND_POPUP_BUTTON"),
                message: qsTr("SILENT_REMIND_POPUP_MESSAGE").arg(gameItem.licenseUrl),
            };

            TrayPopup.showPopup(artNoLicenseRemind, popUpOptions, 'silentModeRemider' + serviceId);
        }
    }

    Component {
        id: artNoLicenseRemind

        ArtPopup {
            id: popUp

            property string page

            onPlayClicked: {
                announcements.gameAcceptLicenseClicked(popUp.gameItem.serviceId);
                Ga.trackEvent(popUp.page, 'Announcement SilentModeRemider', 'action', gameItem.gaName);
            }

            onAnywhereClicked: {
                announcements.gameMissLicenseClicked(popUp.gameItem.serviceId);
                Ga.trackEvent(popUp.page, 'Announcement SilentModeRemider', 'miss click', gameItem.gaName);
            }

            onCloseButtonClicked: {
                Ga.trackEvent(popUp.page, 'Announcement SilentModeRemider', 'close', gameItem.gaName);
            }

            Component.onCompleted: {
                Ga.trackEvent(page, 'Announcement SilentModeRemider', 'show', gameItem.gaName);
            }
        }
    }

    Component {
        id: announceGameItemPopUp

        GamePopup {
            id: announcePopUp

            property variant announceItem

            function sendAnnouncementActionClicked() {
                Marketing.send(Marketing.AnnouncementActionClicked,
                               announceItem.serviceId,
                               { type: "announcementSmall", id: announceItem.id, userId: User.userId() });

                var gameItem = App.serviceItemByServiceId(announceItem.serviceId);
                Ga.trackEvent('Announcement Small ' + announceItem.id, 'action', gameItem.gaName);
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
                               { type: "announcementSmall", id: announceItem.id, userId: User.userId() });

                if (announceItem.url) {
                    announcements.announceActionClick(announceItem);
                    return;
                }

                announcements.missClicked(announceItem.serviceId);

                var gameItem = App.serviceItemByServiceId(announceItem.serviceId);
                Ga.trackEvent('Announcement Small ' + announceItem.id, 'miss click', gameItem.gaName);
            }

            onPlayClicked: {
                announcePopUp.sendAnnouncementActionClicked();
                announcements.announceActionClick(announceItem);
            }

            onCloseButtonClicked: {
                Marketing.send(Marketing.AnnouncementClosedClicked,
                               announceItem.serviceId,
                               { type: "announcementSmall", id: announceItem.id, userId: User.userId() });
                announcements.announceCloseClick(announceItem);

                var gameItem = App.serviceItemByServiceId(announceItem.serviceId);
                Ga.trackEvent('Announcement Small ' + announceItem.id, 'close', gameItem.gaName);
            }

            Component.onCompleted: {
                var gameItem = App.serviceItemByServiceId(announceItem.serviceId);
                Ga.trackEvent('Announcement Small ' + announceItem.id, 'show', gameItem.gaName);
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
                Marketing.send(Marketing.AnnouncementActionClicked, serviceId, { type: popupType, userId: User.userId() });

                var gameItem = App.serviceItemByServiceId(serviceId);
                Ga.trackEvent('Announcement '+ popupType, 'action', gameItem.gaName);
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
                Marketing.send(Marketing.AnnouncementMissClicked, serviceId, { type: popupType, userId: User.userId() });
                announcements.missClicked(serviceId);

                var gameItem = App.serviceItemByServiceId(serviceId);
                Ga.trackEvent('Announcement '+ popupType, 'miss click', gameItem.gaName);
            }

            onCloseButtonClicked: {
                Marketing.send(Marketing.AnnouncementClosedClicked, serviceId, { type: popupType, userId: User.userId() });

                var gameItem = App.serviceItemByServiceId(serviceId);
                Ga.trackEvent('Announcement '+ popupType, 'close', gameItem.gaName);
            }

            onPlayClicked: {
                remindGameItemPopup.sendAnnouncementActionClicked();
                announcements.gamePlayClicked(serviceId);
            }

            Component.onCompleted: {
                Ga.trackEvent('Announcement '+ popupType, 'show', remindGameItemPopup.gameItem.gaName);
                Marketing.send(Marketing.AnnouncementShown, serviceId, { type: popupType, userId: User.userId() });
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

    Connections {
        target: SignalBus
        onAuthDone: refreshTimer.restart();
        onLogoutDone: {
            logicTimer.stop();
            refreshTimer.stop();
            bigAnnounceWindow.visible = false;
        }
    }

    Timer {
        id: refreshTimer

        interval: 10800000
        running: false
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            logicTimer.stop();
            console.log('Query announcements');
            RestApi.Games.getAnnouncement(getAnnouncementSuccessCallback, function (){});
        }
    }

    BigAnnounceWindow {
        id: bigAnnounceWindow

        Connections {
            target: announcements
            onInternalGameStarted: bigAnnounceWindow.internalGameStarted(serviceId)
        }

        onAnnounceCloseClick: announcements.announceCloseClick(announceItem)
    }
}
