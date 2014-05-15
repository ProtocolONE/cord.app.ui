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
import GameNet.Controls 1.0

Item {
    id: root

    Column {
        x: 30
        spacing: 20

        CheckBox {
            text: qsTr("USE_OVERLAY")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
        }
    }
}
