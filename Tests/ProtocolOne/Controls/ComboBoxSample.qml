import QtQuick 2.4
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

import Dev 1.0

Rectangle {
    width: 600
    height: 400

    color: "#002336"

    //  HACK: эмулируем сигнал для того чтобы ловить клик вне выпадающего списка
    //  в отладке из QtCreator
    MouseArea {
        id: mainWindow

        signal leftMouseRelease(int x, int y);

        hoverEnabled: true
        anchors.fill: parent
        onClicked: mainWindow.leftMouseRelease(mouse.x, mouse.y);
    }

    ComboBox {
        id: languageComboBox

        width: 300
        height: 48
        x: 150
        y: 100
        z: 100
        dropDownSize: 5

        icon: installPath + "Assets/Images/Application/Widgets/ApplicationSettings/language.png"
        model: ListModel {
            ListElement {
                value: "ru"
                icon: "Samples/images/language.png"
                text: "Русский язык"
            }
            ListElement {
                value: "en"
                icon: "Samples/images/language.png"
                text: "English1"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol2"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol3"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol4"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol5"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol6"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol7"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol8"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol9"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol10"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol11"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol12"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol13"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol14"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol15"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol16"
            }
        }

        style {
            background: Styles.comboboxBackground
            normal: Styles.comboboxNormal
            hover: Styles.comboboxHover
            active: Styles.comboboxActive
            disabled: Styles.comboboxDisabled
            selectHover: Styles.comboboxSelectHover
            scrollBarCursor: Styles.comboboxScrollBarCursor
            scrollBarCursorHover: Styles.comboboxScrollBarCursorHover
        }
    }

    ComboBox {
        id: speedComboBox

        width: 300
        height: 48
        x: 150
        y: 160
        z: 50

        enabled: true
        model: ListModel {
            ListElement {
                value: 0
                text: "Неограниченно"
            }
            ListElement {
                value: 50
                text: "50 КБайт/с"
            }
            ListElement {
                value: 200
                text: "200 КБайт/с"
            }
            ListElement {
                value: 500
                text: "500 КБайт/с"
            }
            ListElement {
                value: 1000
                text: "1000 КБайт/с"
            }
            ListElement {
                value: 2000
                text: "2000 КБайт/с"
            }
            ListElement {
                value: 5000
                text: "5000 КБайт/с"
            }
        }
    }


    Rectangle {
        color: "#BBBBBB"
        width: 200
        height: 40
        x: 150
        y: 220

        Text {
            anchors.centerIn: parent
            text: "Установить 2000 КБайт/с"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var index = speedComboBox.findText("2000 КБайт/с");


                if (index >= 0) {
                    speedComboBox.currentIndex = index;
                }
            }
        }
    }

}
