import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0
import Dev 1.0

import "../../../Application/Blocks/Auth/Controls/Inputs"

Rectangle {
    id: root

    //color: "#FFFFFF"
    color: "green"
    width: 600
    height: 400

//    Rectangle {
//        x: 100
//        y: 100

//        antialiasing: true
//        radius: 10
//        color: "blue"
//        width: 100
//        height: 100

//        //rotation: 45
//        border {
//            color: "#30FF0000"
//            width: 1
//        }
//    }

    Column {
        x: 200
        y: 30
        spacing: 10

        Input {
            width: 350
            height: 40
            z: 300
            placeholder: "qqqqqqq"
        }

        Input {
            id: qqqqq_1

            width: parent.width
            height: 40

            icon: installPath + "Assets/Images/ProtocolOne/Controls/Input/email.png"
            showLanguage: true
            showCapslock: true
            capsLock: true
            language: "FR"
            passwordType: false
            placeholder: "qqqqqqq"

            typeahead: TypeaheadBehaviour {
                dictionary: ["nikita.gorbunov@syncopate.ruaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                    "nikolay.bondarenko@syncopate.ru",
                    "nikita.kravchuk@syncopate.ru",
                    "nikita.gorbunov@syncopate.ru",
                    "nikolay.bondarenko@syncopate.ru",
                    "nikita.kravchuk@syncopate.ru",
                    "nikita.gorbunov@syncopate.ru",
                    "nikolay.bondarenko@syncopate.ru",
                    "nikita.kravchuk@syncopate.ru",
                    "nikita.gorbunov@syncopate.ru",
                    "nikolay.bondarenko@syncopate.ru",
                    "nikita.kravchuk@syncopate.ru"
                ]
            }
        }

        ErrorContainer {
            width: 350
            z: 201

            Input {
                id: q

                width: parent.width
                height: 26

                icon: installPath + "Assets/Images/ProtocolOne/Controls/Input/email.png"
                showLanguage: true

                typeahead: TypeaheadBehaviour {
                    dictionary: ["nikita.gorbunov@syncopate.ruaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                        "nikolay.bondarenko@syncopate.ru",
                        "nikita.kravchuk@syncopate.ru",
                        "nikita.gorbunov@syncopate.ru",
                                            "nikolay.bondarenko@syncopate.ru",
                                            "nikita.kravchuk@syncopate.ru",
                        "nikita.gorbunov@syncopate.ru",
                                            "nikolay.bondarenko@syncopate.ru",
                                            "nikita.kravchuk@syncopate.ru",
                        "nikita.gorbunov@syncopate.ru",
                                            "nikolay.bondarenko@syncopate.ru",
                                            "nikita.kravchuk@syncopate.ru"
                    ]
                }
            }

            errorMessage: q.text
            error: q.text.length > 0
        }

        Input {
            id: q1

            width: parent.width
            height: 48

            z: 200//q1.activeFocus ? 200 : 0

            icon: installPath + "Assets/Images/ProtocolOne/Controls/Input/email.png"
            showLanguage: true

            typeahead: TypeaheadBehaviour {
                dictionary: ["nikita.gorbunov@syncopate.ruaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                    "nikolay.bondarenko@syncopate.ru",
                    "nikita.kravchuk@syncopate.ru",
                    "nikita.gorbunov@syncopate.ru",
                                        "nikolay.bondarenko@syncopate.ru",
                                        "nikita.kravchuk@syncopate.ru",
                    "nikita.gorbunov@syncopate.ru",
                                        "nikolay.bondarenko@syncopate.ru",
                                        "nikita.kravchuk@syncopate.ru",
                    "nikita.gorbunov@syncopate.ru",
                                        "nikolay.bondarenko@syncopate.ru",
                                        "nikita.kravchuk@syncopate.ru"
                ]
            }
        }


//        //  Пример использования пользовательсокй функции сравнения
//        /*Input {
//                width: 350
//                height: 40

//                showCapslock: false
//                showLanguage: true
//                typeahead: TypeaheadBehaviour {
//                dictionary: {"nikita.gorbunov@syncopate.ru": 1,
//                       "nikolay.bondarenko@syncopate.ru": 2,
//                        "nikita.kravchuk@syncopate.ru": 3}

//                    function sortFunction(a, b) {
//                        if (a.value < b.value) {
//                            return 1;
//                        }

//                        return -1;
//                    }
//                }
//            }
//        */

        PasswordInput {
            width: 350
            //height: 40
            z: 100
        }

        Input {
            width: 350
            height: 40
        }
    }


//    GlobalProgress {
//        id: global

//        anchors.fill: parent
//        visible: false
//    }

//    Timer {
//        running: true
//        repeat: false
//        interval: 2000
//        onTriggered: {
//            console.log('----- global turned on')
//            global.visible = true
//        }
//    }

//    Timer {
//        running: true
//        repeat: false
//        interval: 12000
//        onTriggered: {
//            console.log('----- global turned off')
//            global.visible = false
//        }
//    }
}
