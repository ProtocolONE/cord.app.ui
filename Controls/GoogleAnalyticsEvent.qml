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
