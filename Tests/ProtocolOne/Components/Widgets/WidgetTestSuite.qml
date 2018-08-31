import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

Item {
    width: 800
    height: 600

    WidgetManager {
        id: manager

        Component.onCompleted:  {
            manager.registerWidget('Tests.ProtocolOne.Components.Widgets.Fixtures.SimpleWidget');
            manager.registerWidget('Tests.ProtocolOne.Components.Widgets.Fixtures.DualViewWidget');
            manager.registerWidget('Tests.ProtocolOne.Components.Widgets.Fixtures.SingletonModelWidget');
            manager.registerWidget('Tests.ProtocolOne.Components.Widgets.Fixtures.SeparateModelWidget');
            manager.init();
        }
    }

    WidgetContainerTestCase {
    }
}
