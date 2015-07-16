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

/**
 * https://gamenet.me:8443/display/GN/Google+Analytics+in+application
 */
QtObject {
    // Страница/блок, в котором произошло событие
    property string page
    onPageChanged: {
        console.log('WARNING! DEPRECATED! Do not never set Google Analytics page!', page);
    }

    // Категория, например на странице произведено дейтсвие с конкретной игрой
    property string category

    // Описание произошедшего действия, например: 'play', 'pause' и т.д.
    property string action

    // Необязательный параметр, в который можно добавлять необходимую дополнительную информацию
    property string label

    // Необязательный параметр, в который можно добавлять необходимую дополнительную информацию
    property int value

    function isValid() {
        return category !== "" && action !== "";
    }
}
