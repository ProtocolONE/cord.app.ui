import QtQuick 1.1
import "../Controls"

Rectangle {
    width: 600
    height: 400

    //  HACK: эмулируем сигнал для того чтобы ловить клик вне выпадающего списка
    //  в отладке из QtCreator
    MouseArea {
        id: mainWindow

        signal leftMouseClick(int x, int y);

        hoverEnabled: true
        anchors.fill: parent
        onClicked: mainWindow.leftMouseClick(mouse.x, mouse.y);
    }

    ComboBox {
        id: languageComboBox

        width: 300
        height: 48
        x: 150
        y: 100
        z: 100

        icon: installPath + "images/Pages/ApplicationSettings/language.png"
        model: ListModel {
            ListElement {
                value: "ru"
                icon: "Samples/images/language.png"
                text: "Русский язык"
            }
            ListElement {
                value: "en"
                icon: "Samples/images/language.png"
                text: "English"
            }
            ListElement {
                value: "sp"
                icon: "Samples/images/language.png"
                text: "Espanol"
            }
        }
    }


    ComboBox {
        id: speedComboBox

        width: 300
        height: 48
        x: 150
        y: 160
        z: 50

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
