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
import Tulip 1.0
import GameNet.Controls 1.0

import "../../../Application/Blocks/Auth/Controls/Inputs"

Rectangle {
    id: root

    color: "#FFFFFF"
    width: 600
    height: 400

    Column {
        x: 200
        y: 30
        spacing: 10

        LoginInput {
            width: 350
            height: 40
            z: 300

        }

        ErrorContainer {
            width: 350
            z: 201

            Input {
                id: q

                width: parent.width
                height: 26

                icon: installPath + "Assets/Images/GameNet/Controls/Input/email.png"
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

            //errorMessage: q.text
            //error: q.text.length > 0
        }

        Input {
            id: q1

            width: parent.width
            height: 48

            z: 200//q1.activeFocus ? 200 : 0

            icon: installPath + "Assets/Images/GameNet/Controls/Input/email.png"
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


        //  Пример использования пользовательсокй функции сравнения
        /*Input {
                width: 350
                height: 40

                showCapslock: false
                showLanguage: true
                typeahead: TypeaheadBehaviour {
                dictionary: {"nikita.gorbunov@syncopate.ru": 1,
                       "nikolay.bondarenko@syncopate.ru": 2,
                        "nikita.kravchuk@syncopate.ru": 3}

                    function sortFunction(a, b) {
                        if (a.value < b.value) {
                            return 1;
                        }

                        return -1;
                    }
                }
            }
        */

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
}
