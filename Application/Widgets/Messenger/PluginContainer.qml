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
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "Messenger"
    model: "Model"
    singletonModel: true
    view: [
        {name: 'Contacts', source: 'Contacts', byDefault: true},
        {name: 'Chat', source: 'Chat'}
    ]
}