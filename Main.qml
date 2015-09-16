/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application 1.0
import Application.Core 1.0
import Application.Core.RootWindow 1.0
import Application.Core.Styles 1.0
import Application.Controls 1.0
import Application.Blocks 1.0

Rectangle {
    id: root

    color: Styles.applicationBackground
    opacity: 0

    width: App.clientWidth
    height: App.clientHeight
    Component.onCompleted:  {
        // UNFO чтоб работала функциональность, приходиться продернуть синглтоны.
        //RootWindow.initWindow();

        WidgetManager.registerWidget('Application.Widgets.Analytics');
        WidgetManager.registerWidget('Application.Widgets.AllGames');
        WidgetManager.registerWidget('Application.Widgets.AlertAdapter');
        WidgetManager.registerWidget('Application.Widgets.Facts');
        WidgetManager.registerWidget('Application.Widgets.GameAdBanner');
        WidgetManager.registerWidget('Application.Widgets.GameInfo');
        WidgetManager.registerWidget('Application.Widgets.GameInstall');
        WidgetManager.registerWidget('Application.Widgets.Maintenance');
        WidgetManager.registerWidget('Application.Widgets.Messenger');
        WidgetManager.registerWidget('Application.Widgets.PremiumShop');
        WidgetManager.registerWidget('Application.Widgets.TaskBar');
        WidgetManager.registerWidget('Application.Widgets.TaskList');
        WidgetManager.registerWidget('Application.Widgets.TrayMenu');

        WidgetManager.registerWidget('Application.Widgets.UserProfile');
        WidgetManager.registerWidget('Application.Widgets.AutoRefreshCookie');
        WidgetManager.registerWidget('Application.Widgets.DownloadManagerConnector');
        WidgetManager.registerWidget('Application.Widgets.RememberGameDownloading');

        WidgetManager.registerWidget('Application.Widgets.GameNews');
        WidgetManager.registerWidget('Application.Widgets.GameLoad');

        WidgetManager.registerWidget('Application.Widgets.GameExecuting');
        WidgetManager.registerWidget('Application.Widgets.GameFailed');
        WidgetManager.registerWidget('Application.Widgets.GameIsBoring');
        WidgetManager.registerWidget('Application.Widgets.PromoCode');
        WidgetManager.registerWidget('Application.Widgets.NicknameEdit');
        WidgetManager.registerWidget('Application.Widgets.AccountActivation');
        WidgetManager.registerWidget('Application.Widgets.Announcements');
        WidgetManager.registerWidget('Application.Widgets.PublicTest');
        WidgetManager.registerWidget('Application.Widgets.SecondAccountAuth');
        WidgetManager.registerWidget('Application.Widgets.GameDownloadError');
        /*
          //INFO Disabled in 3.4
          manager.registerWidget('Application.Widgets.MyGamesMenu');
        */
        WidgetManager.registerWidget('Application.Widgets.NicknameReminder');
        WidgetManager.registerWidget('Application.Widgets.Overlay');
        // INFO Disabled in 3.5 Не используется на текущий момент и не переведено на новый браузер
        //WidgetManager.registerWidget('Application.Widgets.Money');
        WidgetManager.registerWidget('Application.Widgets.PremiumNotifier');
        WidgetManager.registerWidget('Application.Widgets.ServiceLockConnector');
        WidgetManager.registerWidget('Application.Widgets.GameUninstall');
        WidgetManager.registerWidget('Application.Widgets.DetailedUserInfo');
        WidgetManager.registerWidget('Application.Widgets.GameSettings');
        WidgetManager.registerWidget('Application.Widgets.ApplicationSettings');
        WidgetManager.registerWidget('Application.Widgets.PremiumServer');

        if (GoogleAnalyticsHelper.winVersion() > 0x0080) {
            //INFO Available in Vista+
            WidgetManager.registerWidget('Application.Widgets.Themes');
        }
    }

    DragWindowArea {
        anchors.fill: parent
    }

    ParallelAnimation {
        id: exitAnimation;

        onStopped: Qt.quit();

        NumberAnimation { target: root; property: "opacity"; from: 1; to: 0;  duration: 250 }
    }

    ParallelAnimation {
        id: hideAnimation

        onStopped: {
            App.hide();
            root.opacity = 1;
        }
        NumberAnimation { target: root; property: "opacity"; from: 1; to: 0;  duration: 250 }
    }

    ParallelAnimation {
        id: openAnimation

        running: true

        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1;  duration: 750 }
    }

    Connections {
        target: SignalBus

        onHideMainWindow: hideAnimation.start();

        onSetGlobalState: {
            globalState.state = name;

            switcher.source = (name == 'Loading') ? "../../Application/Blocks/SplashScreen.qml" :
                              (name == 'Authorization') ? "../../Application/Blocks/Auth/Index.qml" :
                              (name == 'Application') ? "../../Application/Blocks/AppScreen.qml": ''

        }
        onExitApplication: exitAnimation.start()
        onUpdateFinished: WidgetManager.init();
    }

    PageSwitcher {
        id: switcher

        property bool allreadyInitApp: false

        anchors.fill: parent

        onSwitchFinished: {
            if (globalState.state == 'Application' && !switcher.allreadyInitApp) {
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
            SignalBus.setGlobalState('Loading');
        }
    }

    HiddenAppCloseButton {
        anchors { left: parent.left; top: parent.top }
    }

    StateGroup {
        id: globalState
    }
}
