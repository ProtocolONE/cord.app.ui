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
    width: 1200
    height: 800
    color: '#EEEEEE'

    property string popupSize;

    Row {
        spacing: 10

        Button {
            width: 100
            height: 30
            text: 'Big'
            onClicked: {
                popupSize = 'big';
                manager.setupMockForRestApiPopups();
                manager.show();
            }
        }

        Button {
            width: 100
            height: 30
            text: 'Small'
            onClicked: {
                popupSize = 'small';
                manager.setupMockForRestApiPopups();
                manager.show();
            }
        }


        Button {
            width: 200
            height: 30
            text: 'License Reminder'
            onClicked: {
                manager.setupMockForLicenseReminder();
                manager.show();
            }
        }
    }

    WidgetManager {
        id: manager

        function setupMockForLicenseReminder() {
            App.setInstallDate(+new Date()/1000 - 86400 * 14);
            Settings.setValue("qml/features/SilentMode", "showDate", 0);

            App.isAnyLicenseAccepted = function() {
                return false;
            }

            App.isWindowVisible = function() {
                return false;
            }
        }

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

        function show() {
            manager.registerWidget('Application.Widgets.Announcements');
            manager.init();

            //Look at Application.Widgets.Announcements Component.onCompleted callback
            var widgetModel = manager.getWidgetByName('Announcements').model;
            widgetModel._lastShownPopupDate = 0;
        }

        Component.onCompleted: {
            TrayPopup.init()
        }
    }
}
