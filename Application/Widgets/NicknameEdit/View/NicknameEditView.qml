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
import Application.Blocks.Popup 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

PopupBase {
    id: root

    property alias nickname: nickName.text

    function checkAndFinish() {
        if (d.nickNameSaved && d.techNameSaved) {
            root.save();
        }
    }

    width: 630
    title: qsTr("CREATE_NICKNAME_TITLE")
    clip: true

    QtObject {
        id: d

        property bool nickNameLowBoundReached: false
        property bool nickNameOk: false
        property bool techNameOk: false
        property bool nickNameSaved: false
        property bool techNameSaved: false
        property bool needGenerateTechName: true
        property bool generatingTechName: false

        function tryClose() {
            if (d.nickNameSaved && d.techNameSaved) {
                root.close();
            }
        }
    }


    Item {
        id: body
        anchors {
            left: parent.left
            leftMargin: 20
        }
        width: root.width - 40
        height: childrenRect.height

        Column {
            spacing: 20

            Text {
                width: body.width
                height: 30

                wrapMode: Text.WordWrap
                text: qsTr("NO_NICKNAME_TIP")
                font {
                    family: 'Arial'
                    pixelSize: 15
                }
                color: '#5c6d7d'
            }

            Connections {
                target: model

                onNickNameError: {
                    if (!d.nickNameLowBoundReached) {
                        nickName.error = false;
                        return;
                    }

                    if (error != "") {
                        nickName.errorMessage = error;
                        nickName.style.text = "#FF2E44";
                        nickName.error = true;
                    }
                }
                onNickNameOk: {
                    nickName.errorMessage = qsTr("NICKNAME_OK");
                    nickName.error = false;
                    d.nickNameOk = true;
                }
                onTechNameError: {
                    if (error != "") {
                        techName.errorMessage = error;
                        techName.style.text = "#FF2E44";
                        techName.error = true;
                        d.needGenerateTechName = true;
                    }
                }
                onTechNameOk: {
                    techName.errorMessage = qsTr("NICKNAME_OK");
                    techName.error = false;
                    d.techNameOk = true;
                    if (techName.manuallyEdited) {
                        d.needGenerateTechName = false;
                    }
                }
                onNickNameSaved: {
                    d.nickNameSaved = true;

                    d.tryClose();
                }
                onTechNameSaved: {
                    d.techNameSaved = true;

                    d.tryClose();
                }
            }

            Item {
                width: nickName.width
                height: nickName.height

                InputWithError {
                    id: nickName

                    focus: true
                    width: body.width
                    icon: installPath + "Assets/Images/Application/Widgets/NicknameEdit/nickname.png"
                    showLanguage: true
                    placeholder: qsTr("YOUR_NICKNAME_PLACEHOLDER")

                    onTextChanged: {
                        d.nickNameOk = false;

                        if (!d.nickNameLowBoundReached && nickName.text.length > 4) {
                            d.nickNameLowBoundReached = true;
                        }

                        if (d.needGenerateTechName) {
                            //   хак нужен чтбы различать - нагенерили или ввели вручную
                            d.generatingTechName = true;
                            techName.text = model.generateTechNick(nickName.text);
                            d.generatingTechName = false;
                        }
                    }
                    onValidate: {
                        if (!d.nickNameLowBoundReached) {
                            return;
                        }

                        model.validateNickName(nickName.text);
                    }
                }

                Image {
                    width: 30
                    height: 30
                    fillMode: Image.PreserveAspectFit
                    visible: d.nickNameOk
                    source: installPath + "Assets/Images/Application/Widgets/NicknameEdit/ok.png"
                    anchors {
                        right: nickName.right
                        rightMargin: 5
                        verticalCenter: nickName.verticalCenter
                    }
                }
            }

            Item {
                width: body.width
                height: techName.height

                Input {
                    style {
                        normal: "#CCCCCC"
                        hover: "#CCCCCC"
                        active: "#CCCCCC"
                        disabled: "#CCCCCC"
                    }
                    width: 240
                    height: 48
                    enabled: false
                    showCapslock: false
                    showLanguage: false
                    placeholder: "https://www.gamenet.ru/users/"
                }

                InputWithError {
                    id: techName

                    property bool manuallyEdited: false

                    x: 238
                    width: 352
                    placeholder: qsTr("PROFILE_LINK_PLACEHOLDER")
                    onTextChanged: {
                        manuallyEdited = !d.generatingTechName;

                        d.techNameOk = false;
                    }
                    onValidate: {
                        model.validateTechName(value);
                    }
                }

                Image {
                    width: 30
                    height: 30
                    fillMode: Image.PreserveAspectFit
                    visible: d.techNameOk
                    source: installPath + "Assets/Images/Application/Widgets/NicknameEdit/ok.png"
                    anchors {
                        right: techName.right
                        rightMargin: 5
                        verticalCenter: techName.verticalCenter
                    }
                }
            }
        }
    }

    PopupHorizontalSplit {
        width: root.width
    }

    Button {
        id: saveButton

        width: 200
        height: 48
        anchors {
            left: parent.left
            leftMargin: 20
        }
        text: qsTr("SAVE_BUTTON_CAPTION")
        enabled: (model.nickNameValid && model.techNameValid)
        onClicked: {
            nickName.readOnly = true;
            techName.readOnly = true;
            saveButton.inProgress = true;

            model.saveNickName(nickName.text);
            model.saveTechName(techName.text);

            GoogleAnalytics.trackEvent('NicknameEdit',
                                       'Auth',
                                       'Save nickname');
        }
    }
}
