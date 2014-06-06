import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application 1.0

import "./Application/Core/App.js" as App

// HACL
import "./js/UserInfo.js" as UserInfo

Rectangle {
    id: root

    signal dragWindowPressed(int x, int y);
    signal dragWindowReleased(int x, int y);
    signal dragWindowPositionChanged(int x, int y);
    signal windowClose();

    state: "Loading"
    color: "#092135"

    width: App.clientWidth
    height: App.clientHeight

    MouseArea {
        anchors.fill: parent
        onPressed: dragWindowPressed(mouseX,mouseY);
        onReleased: dragWindowReleased(mouseX,mouseY);
        onPositionChanged: dragWindowPositionChanged(mouseX,mouseY);
    }

    Bootstrap {
        Component.onCompleted: {
            App.activateGame(App.serviceItemByGameId("92"))
        }
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
            manager.registerWidget('Application.Widgets.UserProfile');
            manager.init();
        }
    }

    Connections {
        target: App.signalBus()

        onSetGlobalState: root.state = name;
        onBackgroundMousePositionChanged: onWindowPositionChanged(mouseX, mouseY);
        onBackgroundMousePressed: onWindowPressed(mouseX, mouseY);
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

            //INFO App.initFinished also called from c++ slot MainWindow::acceptFirstLicense()
            App.initFinished();
*/
            App.setGlobalState('Authorization')

        }
    }

    Connections {
        target: UserInfo.instance()
        onAuthDone: {
            console.log('----------------- ')
            //switcher.sourceComponent = mainComponent;
            //timerSwitchToMain.start()
        }
    }


    PageSwitcher {
        id: switcher

        anchors.fill: parent
    }

    states: [
        State {
            name: 'Loading'
            PropertyChanges { target: switcher; source: "../../Application/Blocks/SplashScreen.qml" }
        },
        State {
            name: 'Authorization'
            PropertyChanges { target: switcher; source: "../../Application/Blocks/Auth/Index.qml" }
        },
        State {
            name: 'Application'
            PropertyChanges { target: switcher; source: "../../Application/Blocks/AppScreen.qml" }
        }
    ]
}
