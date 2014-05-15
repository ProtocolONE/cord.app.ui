import QtQuick 1.1
import GameNet.Controls 1.0

Item {
    id: root

    property alias message: messageText.text

    implicitHeight: 473
    implicitWidth: 500

    signal clicked();

    Column {
        anchors.fill: parent
        spacing: 20

        Item {
            width: parent.width
            height: 35

            Text {
                font {
                    pixelSize: 18
                }
                anchors.baseline: parent.bottom
                color: "#363636"
                text: "И вдруг ты оказался за границей этот мира"
            }
        }

        Text {
            id: messageText

            width: parent.width
            font {
                pixelSize: 15
            }

            color: "#6A768E"
            wrapMode: Text.WordWrap
            text: "А в самом деле, почему? С чего это я решил написать ещё одну книгу о Haskell? Причина первая: меня достало! Достало, что почти все известные мне руко­водства по Haskell начинаются с демонстрации того, как реализовать алгоритм быстрой сортировки. И ещё что-то там про факториал и числа Фибоначчи. Мне за все годы практики ни разу не приходилось реализовывать алгоритм быстрой сортировки. Поэтому я даже не знаю, что это такое. Исторически сложилось так, что большинство из нас начали свой профессио­нальный путь именно с императивных языков. И вот вместо того, чтобы пока­зать нам красоту функциональных языков в свете их реального применения, настыкают носом в числа Фибоначчи и в почти нами забытую математическуюнотацию... Естественно, читая подобные материалы, обычный программистначинает чувствовать себя дебилом, и это чувство отбивает в нём всякую охотуосваивать эту непонятную функциональщину. Именно поэтому я расскажу о Haskell нормальным, человеческим языком, сминимумом академизма и действительно понятными примерами. "
        }

        Row {
            width: parent.width
            height: 48
            spacing: 30

            Button {
                width: 200
                height: parent.height
                text: "Кнопка"
                onClicked: root.clicked();
            }

//            Rectangle {
//                width: 1
//                color: "#CCCCCC"
//                height: parent.height
//            }


        }
    }
}
