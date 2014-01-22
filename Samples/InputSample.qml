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

import "../Controls" as Controls

Rectangle {
    id: root

    color: "#FFFFFF"
    width: 600
    height: 400

    Column {
        x: 200
        y: 30
        spacing: 40

        Controls.LoginInput {
            width: 350
            height: 40
            z: 300
        }

        Controls.Input {
            width: 350
            height: 40
            z: 200

            icon: installPath + "Samples/images/mail.png"
            showLanguage: true

            typeahead: Controls.TypeaheadBehaviour {
                dictionary: ["nikita.gorbunov@syncopate.ru",
                    "nikolay.bondarenko@syncopate.ru",
                    "nikita.kravchuk@syncopate.ru"]
            }
        }

        //  Пример использования пользовательсокй функции сравнения
        /*Controls.Input {
                width: 350
                height: 40

                showCapslock: false
                showLanguage: true
                typeahead: Controls.TypeaheadBehaviour {
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

        Controls.PasswordInput {
            width: 350
            height: 40
            z: 100
        }
    }
}
