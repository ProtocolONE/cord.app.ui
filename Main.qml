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
import Application.Controls 1.0 as AppControls

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
    opacity: 0

    width: App.clientWidth
    height: App.clientHeight

    ParallelAnimation {
        id: exitAnimation;

        onCompleted: root.windowClose();
        NumberAnimation { target: root; property: "opacity"; from: 1; to: 0;  duration: 250 }
    }

    ParallelAnimation {
        id: hideAnimation

        onCompleted: {
            App.hide();
            root.opacity = 1;
        }
        NumberAnimation { target: root; property: "opacity"; from: 1; to: 0;  duration: 250 }
    }

    ParallelAnimation {
        id: openAnimation

        running: true
        onCompleted: App.isClientLoaded = true;

        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1;  duration: 750 }
    }

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
        }
    }

    Connections {
        target: App.signalBus()

        onHideMainWindow: hideAnimation.start();

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
        onUpdateFinished: App.setGlobalState("Authorization")
        onExitApplication: exitAnimation.start()
    }

    PageSwitcher {
        id: switcher

        property bool allreadyInitApp: false

        anchors.fill: parent

        onSwitchFinished: {
            if (root.state == 'Application' && !switcher.allreadyInitApp) {
                App.initFinished();
                switcher.allreadyInitApp = true;
            }

            qGNA_main.state = "HomePage";

*/
            //INFO App.initFinished also called from c++ slot MainWindow::acceptFirstLicense()
            App.initFinished();
            App.setGlobalState('Authorization');
        }
    }

    Bootstrap {
        anchors.fill: parent

        Component.onCompleted: {
            openAnimation.start();
            App.setGlobalState('Loading');
        }
    }

    AppControls.HiddenAppCloseButton {
        anchors { left: parent.left; top: parent.top }
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
