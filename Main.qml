/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Blocks 1.0

import "Application"
import "Application/Core/App.js" as App
import "Application/Core/User.js" as User

import "Application/Core/restapi.js" as RestApi // @@DEBUG
Rectangle {
    id: root

    signal dragWindowPressed(int x, int y);
    signal dragWindowReleased(int x, int y);
    signal dragWindowPositionChanged(int x, int y);
    signal windowClose();

    color: "#092135"

    width: App.clientWidth
    height: App.clientHeight

    MouseArea {
        anchors.fill: parent
        onPressed: dragWindowPressed(mouseX,mouseY);
        onReleased: dragWindowReleased(mouseX,mouseY);
        onPositionChanged: dragWindowPositionChanged(mouseX,mouseY);
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.AlertAdapter');
            manager.registerWidget('Application.Widgets.Facts');
            manager.registerWidget('Application.Widgets.GameAdBanner');
            manager.registerWidget('Application.Widgets.GameInfo');
            manager.registerWidget('Application.Widgets.GameInstall');
            manager.registerWidget('Application.Widgets.Maintenance');
            manager.registerWidget('Application.Widgets.Messenger');
            manager.registerWidget('Application.Widgets.PremiumShop');
            manager.registerWidget('Application.Widgets.TaskBar');
            manager.registerWidget('Application.Widgets.TaskList');
            manager.registerWidget('Application.Widgets.TrayMenu');
            manager.registerWidget('Application.Widgets.UserProfile');
            manager.registerWidget('Application.Widgets.AutoRefreshCookie');
            manager.registerWidget('Application.Widgets.DownloadManagerConnector');
            manager.registerWidget('Application.Widgets.GameNews');
            manager.registerWidget('Application.Widgets.GameLoad');
            manager.registerWidget('Application.Widgets.GameExecuting');
            manager.registerWidget('Application.Widgets.GameFailed');
            manager.registerWidget('Application.Widgets.GameIsBoring');
            manager.registerWidget('Application.Widgets.PromoCode');
            manager.registerWidget('Application.Widgets.NicknameEdit');
            manager.registerWidget('Application.Widgets.AccountActivation');
            manager.init();
//            RestApi.Games.getMaintenance = function(callback) {
//                callback({"schedule" :
//                             {"300012010000000000":
//                                 {"id":"300012010000000000",
//                                     "startTime": (+new Date() - 1) / 1000,
//                                     "endTime": (+new Date() + 28000) / 1000
//                              },

//                             "300009010000000000":
//                                 {"id":"300009010000000000",
//                                     "startTime": (+new Date() - 1) / 1000,
//                                     "endTime": (+new Date() + 28000) / 1000
//                              }
//                         }});
//            };
        }
    }

    Connections {
        target: App.signalBus()

        onSetGlobalState: {
            console.log('onSetGlobalState', name);
            root.state = name;

            switcher.source = (name == 'Loading') ? "../../Application/Blocks/SplashScreen.qml" :
                              (name == 'Authorization') ? "../../Application/Blocks/Auth/Index.qml" :
                              (name == 'ServiceLoading') ? "../../Application/Blocks/ServiceLoading/Index.qml" :
                              (name == 'Application') ? "../../Application/Blocks/AppScreen.qml": ''

        }
        onBackgroundMousePositionChanged: dragWindowPositionChanged(mouseX, mouseY);
        onBackgroundMousePressed: dragWindowPressed(mouseX, mouseY);
        onUpdateFinished: {
            /*
            var serviceId = App.startingService() || "0"
                , item;

            if (serviceId == "0") {
                if (!App.isAnyLicenseAccepted()) {
                    serviceId = Settings.value("qGNA", "installWithService", "0");
                }
            }

            qGNA_main.selectService(serviceId);

            if (!App.isAnyLicenseAccepted()) {
                var item = Core.serviceItemByServiceId(serviceId);

                firstLicense.withPath = (serviceId != "0" && serviceId != "300007010000000000" && !!item)
                firstLicense.serviceId = serviceId;

                if (serviceId != "0" && item) {
                    firstLicense.pathInput = App.getExpectedInstallPath(serviceId);
                } else {
                    qGNA_main.state = "HomePage";
                }

                firstLicense.openMoveUpPage();
                return;
            }

            qGNA_main.state = "HomePage";

*/
            //INFO App.initFinished also called from c++ slot MainWindow::acceptFirstLicense()
            App.initFinished();
            App.setGlobalState('Authorization')
        }
    }

    PageSwitcher {
        id: switcher

        anchors.fill: parent
    }

    Bootstrap {
        anchors.fill: parent

        Component.onCompleted: {
            App.setGlobalState('Loading');
        }
    }

//    TODO это не работает, разобратся
//    <Unknown File>: QML StateGroup: Can't apply a state change as part of a state definition.
//
//    states: [
//        State {
//            name: 'Loading'
//            PropertyChanges { target: switcher; source: "../../Application/Blocks/SplashScreen.qml" }
//        },
//        State {
//            name: 'Authorization'
//            PropertyChanges { target: switcher; source: "../../Application/Blocks/Auth/Index.qml" }
//        },
//        State {
//            name: 'ServiceLoading'
//            PropertyChanges { target: switcher; source: "../../Application/Blocks/ServiceLoading/Index.qml" }
//        },
//        State {
//            name: 'Application'
//            PropertyChanges { target: switcher; source: "../../Application/Blocks/AppScreen.qml" }
//        }
//    ]
}
