/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "../Elements" as Elements
import "../Blocks" as Blocks
import "../js/restapi.js" as RestApi

Blocks.MoveUpPage {
    id: alertModule

    openHeight: 550

    property string nickname
    property string nametech
    property bool isAuthed
    property bool isCancelEnabled: false

    signal nickNameChanged(string nickName);
    signal techNickChanged(string techName);
    signal success();
    signal failed();

    function startCheck() {
        mainBlock.nickNameError = "";
        mainBlock.techNameError = "";

        if (!isAuthed || !nickname) {
            alertModule.failed();
            alertModule.closeMoveUpPage();
            return;
        }

        if (nickname.indexOf('@') != -1) {
            mainBlock.isNickNameSaved = false;
            mainBlock.isNickNameValid = false;
        } else {
            mainBlock.isNickNameSaved = true;
        }

        if (!nametech) {
            mainBlock.isTechNameSaved = false;
            mainBlock.isTechNameValid = false;
        } else {
            mainBlock.isTechNameSaved = true;
        }

        if (mainBlock.isNickNameSaved && mainBlock.isTechNameSaved) {
            alertModule.success();
            alertModule.closeMoveUpPage();
            return;
        }

        if (mainBlock.isTechNameSaved) {
            techNameInput.textEditComponent.text = nametech;
        }

        if (mainBlock.isNickNameSaved) {
            nickNameInput.textEditComponent.text = nickname;
        }

        alertModule.openMoveUpPage();
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }

    Rectangle {
        id: mainBlock

        property bool isNickNameValid: false
        property bool isTechNameValid: false

        property bool isNickNameSaved: false
        property bool isTechNameSaved: false

        property string nickNameError : ""
        property string techNameError : ""

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

            for (var a=0; a < nickname.length; a++) {
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
            RestApi.User.validateNickname(nickName,
                                          function(response) {
                                              if (response.hasOwnProperty('error')){
                                                  var error = response.error;
                                                  mainBlock.isNickNameValid = false;
                                                  mainBlock.nickNameError =
                                                    (error != undefined && error.message != undefined)
                                                        ? error.message
                                                        : qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");

                                                  return;
                                              }

                                              mainBlock.isNickNameValid = true;
                                              mainBlock.nickNameError = "";
                                          },
                                          function(error) {
                                              mainBlock.isNickNameValid = false;
                                              mainBlock.nickNameError = qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");
                                          });

        }

        function validateTechName(techName) {
            RestApi.User.validateTechNickname(techName,
                                          function(response) {
                                              if (response.hasOwnProperty('error')){
                                                  var error = response.error;
                                                  mainBlock.isTechNameValid = false;
                                                  mainBlock.techNameError =
                                                    (error != undefined && error.message != undefined)
                                                        ? error.message
                                                        : qsTr("VALIDATE_TECH_NAME_DEFAULT_ERROR");
                                                  return;
                                              }

                                              mainBlock.isTechNameValid = true;
                                              mainBlock.techNameError = "";
                                          },
                                          function() {
                                              mainBlock.isTechNameValid = false;
                                              mainBlock.techNameError = qsTr("VALIDATE_TECH_NAME_DEFAULT_ERROR");
                                          });

        }

        function checkAndFinish() {
            if (mainBlock.isNickNameSaved && mainBlock.isTechNameSaved) {
                alertModule.success();
                alertModule.closeMoveUpPage();
            }
        }

        function saveNickName(nickName) {
            if (!nickName) {
                mainBlock.isNickNameValid = false;
                mainBlock.nickNameError = qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");
                return;
            }

            RestApi.User.saveNickname(nickName,
                                          function(response) {
                                              if (response.hasOwnProperty('error')){
                                                  var error = response.error;
                                                  mainBlock.isNickNameValid = false;
                                                  mainBlock.nickNameError =
                                                    (error != undefined && error.message != undefined)
                                                        ? error.message
                                                        : qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");
                                                  return;
                                              }

                                              mainBlock.isNickNameValid = true;
                                              mainBlock.isNickNameSaved = true;
                                              mainBlock.nickNameError = "";
                                              alertModule.nickNameChanged(nickName);
                                              checkAndFinish();
                                          },
                                          function(error) {
                                              mainBlock.isNickNameValid = false;
                                              mainBlock.nickNameError = qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");
                                          });
        }

        function saveTechName(techName) {
            if (!techName) {
                mainBlock.isTechNameValid = false;
                mainBlock.techNameError = qsTr("VALIDATE_TECH_NAME_DEFAULT_ERROR");
                return;
            }

            RestApi.User.saveTechNickname(techName,
                                          function(response) {
                                              if (response.hasOwnProperty('error')){
                                                  var error = response.error;
                                                  mainBlock.isTechNameValid = false;
                                                  mainBlock.techNameError =
                                                    (error != undefined && error.message != undefined)
                                                        ? error.message
                                                        : qsTr("VALIDATE_TECH_NAME_DEFAULT_ERROR");
                                                  return;
                                              }

                                              mainBlock.isTechNameValid = true;
                                              mainBlock.isTechNameSaved = true;
                                              mainBlock.techNameError = "";
                                              alertModule.techNickChanged(techName);
                                              checkAndFinish();
                                          },
                                          function(error) {
                                              mainBlock.isTechNameValid = false;
                                              mainBlock.techNameError = qsTr("VALIDATE_TECH_NAME_DEFAULT_ERROR");
                                          });
        }

        color: "#353945"
        anchors.fill: parent

        Timer {
            id: checkNickName;

            interval: 300
            onTriggered: mainBlock.validateNickName(nickNameInput.textEditComponent.text);
        }

        Timer {
            id: checkTechName

            interval: 300
            onTriggered: mainBlock.validateTechName(techNameInput.textEditComponent.text);
        }

        Column {
            anchors { top: parent.top; left: parent.left; leftMargin: 42; topMargin: 42 }
            spacing: 2

            Text {
                width: 200
                font { family: "Tahoma"; pixelSize: 18 }
                text: qsTr("TITLE_SET_NICKNAME")
                wrapMode: Text.WordWrap
                color: "#FFFFFF"
                smooth: true
            }

            Text {
                width: 200
                font { family: "Tahoma"; pixelSize: 12}
                text: qsTr("SUBTITLE_SET_NICKNAME")
                wrapMode: Text.WordWrap
                color: "#FFFFFF"
                smooth: true
            }
        }

        Column {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors { topMargin: 44; leftMargin: 275; rightMargin: 60 }
            spacing: 10

            Text {
                id: mainAlertText

                font { family: "Arial"; pixelSize: 16 }
                text: qsTr("LABEL_NICKNAME_INPUT")
                wrapMode: Text.WordWrap
                color: "#FFFFFF"
                smooth: true
            }

            Elements.Input {
                id: nickNameInput

                readOnly: mainBlock.isNickNameSaved
                width: 230
                textEchoMode: TextInput.Normal
                editDefaultText: qsTr("PLACEHOLDER_NICKNAME_INPUT")

                focus: true
                textEditComponent.onTextChanged: {
                    if (!mainBlock.isTechNameSaved) {
                        techNameInput.textEditComponent.text = mainBlock.generateTechNick(textEditComponent.text);
                    }

                    if (!mainBlock.isNickNameSaved) {
                        checkNickName.restart();
                    }
                }

                onTabPressed: {
                    techNameInput.editFocus = true;
                    nickNameInput.editFocus = false;
                }
            }

            Text {
                id: nickNameErrorText

                width: 450
                font { family: "Arial"; pixelSize: 11 }
                text: mainBlock.nickNameError
                wrapMode: Text.WordWrap
                color: "#ebec63"
                smooth: true
            }
        }

        Rectangle {
            anchors { top: parent.top; left: parent.left; right: parent.right}
            anchors { topMargin: 150; leftMargin: 275; rightMargin: 60 }
            height: 1
            color: "#535761"
        }

        Column {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors { topMargin: 155; leftMargin: 275; rightMargin: 60 }
            spacing: 10

            Text {
                font { family: "Arial"; pixelSize: 16 }
                text: qsTr("LABEL_PROFILE_LINK_INPUT")
                wrapMode: Text.WordWrap
                color: "#FFFFFF"
                smooth: true
            }

            Row {
                spacing: 10

                Text {
                    anchors { top: parent.top; topMargin: 8 }
                    font { family: "Arial"; pixelSize: 14 }
                    text: qsTr("PREFIX_PROFILE_LINK_INPUT")
                    wrapMode: Text.WordWrap
                    color: "#FFFFFF"
                    smooth: true
                }

                Column {
                    spacing: 5

                    Elements.Input {
                        id: techNameInput

                        readOnly: mainBlock.isTechNameSaved
                        width: 230
                        textEchoMode: TextInput.Normal
                        editDefaultText: qsTr("PLACEHOLDER_PROFILE_LINK_INPUT")
                        textEditComponent.onTextChanged: {
                            if (!mainBlock.isTechNameSaved) {
                                checkTechName.restart();
                            }
                        }

                        onTabPressed: {
                            techNameInput.editFocus = false;
                            nickNameInput.editFocus = true;
                        }
                    }

                    Text {
                        id: techNameErrorText

                        width: 300
                        font { family: "Arial"; pixelSize: 11 }
                        text: mainBlock.techNameError;
                        wrapMode: Text.WordWrap
                        color: "#ebec63"
                        smooth: true
                    }
                }
            }
        }

        Row {
            anchors { top: parent.top; topMargin: 275; left: parent.left; leftMargin: 275}
            spacing: 10

            Elements.Button4 {
                isEnabled: (mainBlock.isNickNameSaved || mainBlock.isNickNameValid)
                           && (mainBlock.isTechNameSaved || mainBlock.isTechNameValid)
                buttonText: qsTr("BUTTON_SAVE_AND_GO")

                onButtonClicked: {
                    if (!mainBlock.isNickNameSaved) {
                        mainBlock.saveNickName(nickNameInput.textEditComponent.text);
                    }

                    if (!mainBlock.isTechNameSaved) {
                        mainBlock.saveTechName(techNameInput.textEditComponent.text);
                    }

                    mainBlock.checkAndFinish();
                }
            }

            Elements.Button4 {
                isEnabled: true
                visible: alertModule.isCancelEnabled
                buttonText: qsTr("BUTTON_CANCEL")
                onButtonClicked: {
                    alertModule.closeMoveUpPage();
                    alertModule.failed();
                }
            }

        }



        Text {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors { topMargin: 330; leftMargin: 275; rightMargin: 100 }
            font { family: "Arial"; pixelSize: 11 }
            text: qsTr("NOTICE_CANT_SKIP")
            wrapMode: Text.WordWrap
            color: "#848891"
            smooth: true
        }

    }
}
