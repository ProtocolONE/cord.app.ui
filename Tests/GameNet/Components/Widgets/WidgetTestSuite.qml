/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import GameNet.Components.Widgets 1.0

Item {
    width: 800
    height: 600

    WidgetManager {
        id: manager

        Component.onCompleted:  {
            manager.registerWidget('Tests.GameNet.Components.Widgets.Fixtures.SimpleWidget');
            manager.registerWidget('Tests.GameNet.Components.Widgets.Fixtures.DualViewWidget');
            manager.registerWidget('Tests.GameNet.Components.Widgets.Fixtures.SingletonModelWidget');
            manager.registerWidget('Tests.GameNet.Components.Widgets.Fixtures.SeparateModelWidget');
            manager.init();
        }
    }

    WidgetContainerTestCase {
    }
}
