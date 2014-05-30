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
import "../../../../Elements" as Elements

Elements.CursorMouseArea {
    id: container

    hoverEnabled: true
    property string orientation
    
    Component.onCompleted: {
        switch (container.orientation) {
        case 'N':
        {
            buttonArrow.rotation = 90;
        }
        break;
        case 'S':
        {
            buttonArrow.rotation = 270;
        }
        break;
        case 'W':
        {
            buttonArrow.rotation = 0;
        }
        break;
        case 'E':
        {
            buttonArrow.rotation = 180;
        }
        break;
        default:
        {
            buttonArrow.rotation = 0;
        }
        break;
        }
    }

    Image {
        id: buttonArrow

        anchors.centerIn: parent
        source: container.hoverEnabled && container.containsMouse
                ? (installPath + "Assets/Images/Features/CombatArmsShop/left_hover.png")
                : (installPath + "Assets/Images/Features/CombatArmsShop/left.png")
    }
}
