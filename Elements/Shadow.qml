/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1

Rectangle {
    property int windowWidth
    property int windowHeight
    property int shadowRadius

    x:0; y: 0
    width: windowWidth
    height: windowHeight
    color: "#00000000"
/*
    Rectangle {
        x: 0; y: 0;
        width: windowWidth + 4
        height: windowHeight + 4
        radius: shadowRadius
        color: "#000000" // f1f1f1
        opacity: 0.05

        Rectangle {
            x: 0; y: 0;
            width: windowWidth + 3
            height: windowHeight + 3
            radius: shadowRadius
            color: "#00000000" // "#d4d4d4"
            border { color: "#000000"; width: 1 }
            opacity:  0.18

            Rectangle {
                x: 0; y: 0;
                width: windowWidth + 2
                height: windowHeight + 2
                radius: shadowRadius
                color: "#00000000" //"#ababab"
                border { color: "#000000"; width: 1 }
                opacity: 0.34

                Rectangle {
                    x: 0; y: 0;
                    width: windowWidth + 1
                    height: windowHeight + 1
                    radius: shadowRadius
                    color: "#00000000" //"#8e8e8e"
                    border { color: "#000000"; width: 1 }
                    opacity: 0.46
                }
            }
        }
    }*/
}
