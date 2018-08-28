import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Dev 1.0

import GameNet.Core 1.0
import Application.Core 1.0
import Application.Controls 1.0
import Application.Core.Styles 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0

Rectangle {
    id: root

    width: 1000
    height: 800
    color: '#EEEEEE'

    property string userId: "400001000002837740"
    property string appKey: "e46bbb8616670c79dabaa963f0d29fe08d100685"


    function authDone(userId, appKey) {
        RestApi.Core.setUserId(userId);
        RestApi.Core.setAppKey(appKey);

        SignalBus.authDone(userId, appKey, "");
    }

    Component.onCompleted: {
        Styles.init();
        //Styles.setCurrentStyle('sand');
        Styles.setCurrentStyle('main');

        ContextMenu.init(contextMenuLayer);
        Tooltip.init(tooltipLayer);
        Popup.init(popupLayer);
        Moment.moment.lang('ru');
        MessageBox.init(messageLayer);

        WidgetManager.registerWidget('Application.Widgets.UserProfile');
        WidgetManager.init();

        User.reset();

        root.authDone(userId, appKey); // gna4@unit.test
        //SignalBus.authDone("400001000092302250", "86c558d41c1ae4eafc88b529e12650b884d674f5", "");
    }

    WidgetContainer {
        x: 100
        y: 100
        width: 229
        height: 92
        widget: 'UserProfile'
    }


    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }

    Item {
        id: contextMenuLayer

        anchors.fill: parent
    }

    Item {
        id: tooltipLayer

        anchors.fill: parent
    }

    Item {
        id: messageLayer

        anchors.fill: parent
    }
}
