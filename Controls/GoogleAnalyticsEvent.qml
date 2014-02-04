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

//  More info: https://developers.google.com/analytics/devguides/collection/analyticsjs/events

QtObject {
    // Страница/блок, в котором произошло событие
    property string page
    // Категория, например на странице произведено дейтсвие с конкретной игрой
    property string category
    // Описание произошедшего действия, например: 'Switch to game', 'Play', 'Pause' и т.д.
    property string action
    // Необязательный параметр, в который можно добавлять необходимую дополнительную информацию
    property string label

    function isValid() {
        return page !== "" && category !== "" && action !== "";
    }
}
