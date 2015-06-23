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

Rectangle {
    width: 1000
    height: 600
    color: '#EEEEEE'

    property string popupSize;

    Column {
        spacing: 10

        Row {
            spacing: 10

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
                onClicked: manager.show();
            }
        }

        Row {
            spacing: 10

            Button {
                text: 'Service Installed'
                onClicked: {
                    App.serviceInstalled({serviceId: '300003010000000000'});
                }
            }

            Button {
                text: 'Service Started'
                onClicked: {
                    App.serviceStarted({serviceId: '300003010000000000'});
                }
            }

            Button {
                text: 'Service Finished'
                onClicked: {
                    App.serviceFinished({serviceId: '300003010000000000'});
                }
            }
        }
    }

    RequestServices {
        function setupMockForRestApiPopups() {
            RestApi.Games.getAnnouncement = function(fn) {
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
            manager.init();

            manager.show();

        }
    }

    WidgetManager {
        id: manager

        function setupMockForLicenseReminder() {
            Settings.remove("qml/Announcements2/reminderNeverExecute/300003010000000000/", "showDate");
            Settings.setValue("qml/features/SilentMode", "showDate", 0);

            App.installDate = function() {
                return +new Date()/1000 - 86400 * 14;
            }

            App.isAnyLicenseAccepted = function() {
                return false;
            }

            App.isWindowVisible = function() {
                return false;
            }
        }

        function show() {
            setupMockForLicenseReminder();


            //Look at Application.Widgets.Announcements Component.onCompleted callback
            var widgetModel = manager.getWidgetByName('Announcements').model;
            widgetModel._lastShownPopupDate = 0;

            App.authDone('fakeId', 'fakeAppKey');
        }
    }
}
