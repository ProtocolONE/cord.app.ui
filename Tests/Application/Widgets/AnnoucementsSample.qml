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
import QtQuick.Window 2.2

import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Dev 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Popup 1.0
import Application.Core.Styles 1.0

import "../../../Application/Widgets/Maintenance/MaintenanceModel.js" as MaintenanceModel

Window {
    width: 1000
    height: 600
    color: '#EEEEEE'

    onClosing: {
        Qt.quit();
    }

    Component.onCompleted: {
        Styles.init();
        Styles.setCurrentStyle('mainStyle');
        Popup.init(popupLayer);

        RestApi.Games.getMaintenance = function(callback) {
            callback({"schedule" :
                         {"300012010000000000":
                             {"id":"300012010000000000",
                                 "startTime": (+new Date() - 1) / 1000,
                                 "endTime": (+new Date() + 8000) / 1000
                          },

                         "300009010000000000":
                             {"id":"300009010000000000",
                                 "startTime": (+new Date() - 1) / 1000,
                                 "endTime": (+new Date() + 28000) / 1000
                          }
                     }});
        };

        App.activateGameByServiceId("300012010000000000");

        MaintenanceModel.showMaintenanceEnd['300012010000000000'] = 1;
        MaintenanceModel.showMaintenanceEnd['300009010000000000'] = 1;

//        App.isWindowVisible = function() {
//            return false;
//        }

//        App.isAnyLicenseAccepted = function() {
//            return false;
//        }
    }

    property string popupSize: 'small'

    Column {
        spacing: 10

        Row {
            spacing: 10

            Button {
                text: 'Settings'
                onClicked: {
                    Popup.show('ApplicationSettings');
                }
            }

            Button {
                text: 'Big'
                onClicked: {
                    popupSize = 'big';
                    manager.show();
                }
            }

            Button {
                text: 'Small'
                onClicked: {
                    popupSize = 'small';
                    manager.show();
                }
            }

            Button {
                text: 'License Reminder'
                onClicked: {
                    popupSize = '';
                    manager.show();
                }
            }
        }

        Row {
            spacing: 10

            Button {
                text: 'Service Installed'
                onClicked: {
                    manager.setupMockForLicenseReminder();
                    SignalBus.serviceInstalled({serviceId: '300003010000000000'});
                }
            }

            Button {
                text: 'Service Started'
                onClicked: {
                    manager.setupMockForLicenseReminder();
                    SignalBus.serviceStarted({serviceId: '300003010000000000'});
                }
            }

            Button {
                text: 'Service Finished'
                onClicked: {
                    manager.setupMockForLicenseReminder();
                    SignalBus.serviceFinished({serviceId: '300003010000000000'});
                }
            }

            Button {
                text: 'Service Downloaded'
                onClicked: {
                    manager.setupMockForLicenseReminder();
                    App.mainWindowInstance().downloaderFinished('300003010000000000');
                }
            }

            Button {
                text: 'Premium expired'
                onClicked: {
                    manager.setupMockForLicenseReminder();
                    SignalBus.premiumExpired();
                }
            }
        }
    }

    RequestServices {
        id: services

        function setupMockForRestApiPopups() {
            RestApi.Games.getAnnouncement = function(fn) {
                if (popupSize == "") {
                    fn({});
                    return;
                }

                fn({
                       announcement: [
                           {
                                id: Math.random(),
                                serviceId: '300003010000000000',
                                size: popupSize,
                                image: 'https://images.gamenet.ru/pics/app/service/1418914233742.png',
                                buttonColor: 1,
                                text: 'Hello',
                                textOnButton: 'Play',
                                startTime: +new Date() / 1000,
                                endTime: +new Date() / 1000 + 10000000,
                                isPublished: 1
                            }
                       ]
                   });
            }
        }

        onReady: {
            setupMockForRestApiPopups();

            manager.registerWidget('Application.Widgets.Announcements');
            manager.registerWidget('Application.Widgets.ApplicationSettings');
            manager.registerWidget('Application.Widgets.Messenger');
            manager.registerWidget('Application.Widgets.Overlay');
            manager.registerWidget('Application.Widgets.DownloadManagerConnector');
            manager.registerWidget('Application.Widgets.PremiumNotifier');
            manager.registerWidget('Application.Widgets.Maintenance');
            manager.init();



            //manager.show();

        }
    }

    WidgetManager {
        id: manager

        function setupMockForLicenseReminder() {
            AppSettings.remove("qml/Announcements2/reminderNeverExecute/300003010000000000/", "showDate");
            AppSettings.setValue("qml/features/SilentMode", "showDate", 0);
            AppSettings.setValue("GameDownloader/300003010000000000/", "installDate", Math.floor((+Date.now() / 1000)) - 604810);

//            ApplicationStatistic.installDate = function() {
//                return +new Date()/1000 - 86400 * 14;
//            }
        }

        function show() {
            manager.setupMockForLicenseReminder();
            services.setupMockForRestApiPopups();


            //Look at Application.Widgets.Announcements Component.onCompleted callback
            var widgetModel = manager.getWidgetByName('Announcements').model;
            widgetModel._lastShownPopupDate = 0;

            SignalBus.authDone('fakeId', 'fakeAppKey', "");
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}

