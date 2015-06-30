/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Application/Core/App.js" as App
import "../../../Application/Core/TrayPopup.js" as TrayPopup
import "../../../Application/Core/restapi.js" as RestApi
import "../../../Application/Core/Popup.js" as Popup
import "../../../Application/Core/Styles.js" as Styles
import "../../../Application/Widgets/Maintenance/MaintenanceModel.js" as MaintenanceModel

Rectangle {
    width: 1000
    height: 600
    color: '#EEEEEE'

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

        App.isWindowVisible = function() {
            return false;
        }

        App.isAnyLicenseAccepted = function() {
            return false;
        }
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
                    App.serviceInstalled({serviceId: '300003010000000000'});
                }
            }

            Button {
                text: 'Service Started'
                onClicked: {
                    manager.setupMockForLicenseReminder();
                    App.serviceStarted({serviceId: '300003010000000000'});
                }
            }

            Button {
                text: 'Service Finished'
                onClicked: {
                    manager.setupMockForLicenseReminder();
                    App.serviceFinished({serviceId: '300003010000000000'});
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
                    App.premiumExpired();
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
                                image: 'http://yandex.ru/images/today?size=1920x1080',
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
            TrayPopup.init();

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
            Settings.remove("qml/Announcements2/reminderNeverExecute/300003010000000000/", "showDate");
            Settings.setValue("qml/features/SilentMode", "showDate", 0);
            App.setSettingsValue("GameDownloader/300003010000000000/", "installDate", Math.floor((+Date.now() / 1000)) - 604810);

            App.installDate = function() {
                return +new Date()/1000 - 86400 * 14;
            }




        }

        function show() {
            manager.setupMockForLicenseReminder();
            services.setupMockForRestApiPopups();


            //Look at Application.Widgets.Announcements Component.onCompleted callback
            var widgetModel = manager.getWidgetByName('Announcements').model;
            widgetModel._lastShownPopupDate = 0;

            App.authDone('fakeId', 'fakeAppKey');
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}

