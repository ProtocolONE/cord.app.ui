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
import Application.Core 1.0
import Application.Core.Styles 1.0

Column {
    spacing: 2

    property variant serviceItem

    Text {
        font { family: 'Open Sans Regular'; pixelSize: 24 }
        color: Styles.bannerTitleText
        text: serviceItem ? serviceItem.name : 'name'
    }

    Text {
        font { family: 'Open Sans Regular'; pixelSize: 12 }
        color: Styles.bannerInfoText
        text: serviceItem ? serviceItem.shortDescription : 'shortDescription'
    }
}
