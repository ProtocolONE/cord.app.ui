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
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

HorizontalSplit {
    width: parent.width

    style: SplitterStyleColors {
        main: Qt.darker(Styles.style.popupBackground, Styles.style.darkerFactor)
        shadow: Qt.lighter(Styles.style.popupBackground, Styles.style.lighterFactor)
    }
}
