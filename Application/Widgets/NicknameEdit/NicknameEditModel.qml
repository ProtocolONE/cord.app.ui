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
import GameNet.Components.Widgets 1.0
import "../../Core/restapi.js" as RestApiJs

WidgetModel {
    id: root

    property bool nickNameValid: false
    property bool techNameValid: false

    signal nickNameError(string error)
    signal nickNameOk()
    signal techNameError(string error)
    signal techNameOk()
    signal nickNameSaved()
    signal techNameSaved()

    function generateTechNick(nickname) {
        var words = {
            "а": "a",	"б": "b",	"в": "v",	"г": "g",	"д": "d",	"е": "e",	"ё": "e",	"ж": "zh",
            "з": "z",	"и": "i",	"й": "i",	"к": "k",	"л": "l",	"м": "m",	"н": "n",	"о": "o",
            "п": "p",	"р": "r",	"с": "s",	"т": "t",	"у": "u",	"ф": "f",	"х": "h",	"ц": "ts",
            "ч": "ch",	"ш": "sh",	"щ": "sch",	"ы": "y",	"э": "e",	"ю": "yu",	"я": "ya"
        };
        var technick = '';
        var re = new RegExp('[0-9a-z-]{1}');
        nickname = nickname.toLowerCase();

        for (var a = 0; a < nickname.length; a++) {
            if (words[nickname.charAt(a)] !== undefined) {
                technick += words[nickname.charAt(a)];
            } else if (re.test(nickname.charAt(a))) {
                technick += nickname.charAt(a);
            } else {
                technick += '';
            }
        }

        return technick;
    }

    function validateNickName(nickName) {
        if (!nickName) {
            root.nickNameValid = false;
            d.nickNameError = "";
            root.nickNameError(d.nickNameError);
            return;
        }

        RestApiJs.User.validateNickname(nickName,
                                        function(response) {
                                            if (response.hasOwnProperty('error')){
                                                var error = response.error;
                                                root.nickNameValid = false;
                                                d.nickNameError =
                                                        (error != undefined && error.message != undefined)
                                                        ? error.message
                                                        : qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");

                                                //  HACK: раскомментировать для тестирования положительного поведения
                                                //root.nickNameValid = true;
                                                //root.nickNameOk();
                                                //return;

                                                root.nickNameError(d.nickNameError);
                                                return;
                                            }

                                            root.nickNameValid = true;
                                            d.nickNameError = "";
                                            root.nickNameOk();
                                        },
                                        function(error) {
                                            root.nickNameValid = false;
                                            d.nickNameError = qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");
                                            root.nickNameError(d.nickNameError);
                                        });

    }

    function validateTechName(techName) {
        if (!techName) {
            root.techNameValid = false;
            d.techNameError = "";
            root.techNameError(d.techNameError);
            return;
        }

        RestApiJs.User.validateTechNickname(techName,
                                            function(response) {
                                                if (response.hasOwnProperty('error')){
                                                    var error = response.error;
                                                    root.techNameValid = false;
                                                    d.techNameError =
                                                            (error != undefined && error.message != undefined)
                                                            ? error.message
                                                            : qsTr("VALIDATE_TECH_NAME_DEFAULT_ERROR");

                                                    //  HACK: раскомментировать для тестирования положительного поведения
                                                    //root.techNameValid = true;
                                                    //root.techNameOk();
                                                    //return;

                                                    root.techNameError(d.techNameError);
                                                    return;
                                                }

                                                root.techNameValid = true;
                                                d.techNameError = "";
                                                root.techNameOk();
                                            },
                                            function() {
                                                root.techNameValid = false;
                                                d.techNameError = qsTr("VALIDATE_TECH_NAME_DEFAULT_ERROR");
                                                root.techNameError(d.techNameError);
                                            });
    }

    function saveNickName(nickName) {
        if (!nickName) {
            root.nickNameValid = false;
            d.nickNameError = "";
            root.nickNameError(d.nickNameError);
            return;
        }

        RestApiJs.User.saveNickname(nickName,
                                    function(response) {
                                        if (response.hasOwnProperty('error')){
                                            var error = response.error;
                                            root.nickNameValid = false;
                                            d.nickNameError =
                                                    (error != undefined && error.message != undefined)
                                                    ? error.message
                                                    : qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");
                                            root.nickNameError(d.nickNameError);
                                            return;
                                        }

                                        root.nickNameValid = true;
                                        d.nickNameSaved = true;
                                        d.nickNameError = "";
                                        root.nickNameSaved();
                                    },
                                    function(error) {
                                        root.nickNameValid = false;
                                        d.nickNameError = qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");
                                        root.nickNameError(d.nickNameError);
                                    });
    }

    function saveTechName(techName) {
        if (!techName) {
            root.techNameValid = false;
            d.techNameError = "";
            root.techNameError(d.techNameError);
            return;
        }

        RestApiJs.User.saveTechNickname(techName,
                                        function(response) {
                                            if (response.hasOwnProperty('error')){
                                                var error = response.error;
                                                root.techNameValid = false;
                                                d.techNameError =
                                                        (error != undefined && error.message != undefined)
                                                        ? error.message
                                                        : qsTr("VALIDATE_TECH_NAME_DEFAULT_ERROR");
                                                root.techNameError(d.techNameError);
                                                return;
                                            }

                                            root.techNameValid = true;
                                            d.techNameSaved = true;
                                            d.techNameError = "";
                                            root.techNameSaved();
                                        },
                                        function(error) {
                                            root.techNameValid = false;
                                            d.techNameError = qsTr("VALIDATE_TECH_NAME_DEFAULT_ERROR");
                                            root.techNameError(d.techNameError);
                                        });
    }


    QtObject {
        id: d

        property bool nickNameSaved: false
        property bool techNameSaved: false

        property string nickNameError: ""
        property string techNameError: ""
    }
}
