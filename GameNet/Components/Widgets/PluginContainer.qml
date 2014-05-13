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
import "WidgetManager.js" as WidgetManager

Item {
    property string name
    property string version: '1.0'
    property bool singletonModel: false
    property string model
    property variant view

    Component.onCompleted: {
        WidgetManager.log('PluginContainer `' + name + '` onCompleted executed');
    }
}
