/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "GameNews"
    model: "GameNewsModel"
    view: [
        {name: 'NewsSingleGame', source: 'NewsSingleGame', byDefault: true},
        {name: 'NewsMyGames', source: 'NewsMyGames'}
    ]
    singletonModel: true
}
