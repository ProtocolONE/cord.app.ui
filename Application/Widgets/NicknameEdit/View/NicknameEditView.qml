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
import GameNet.Controls 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import "../../../Core/Styles.js" as Styles
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

    Connections {
        target: model

        onNickNameError: {
            if (!d.nickNameLowBoundReached) {
                nickName.error = false;
                return;
            }

            if (error != "") {
                nickName.errorMessage = error;
                nickName.style.text = Styles.style.inputError;
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
                techName.style.text = Styles.style.inputError;
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

    Text {
        anchors {
            left: parent.left
            right: parent.right
        }

        height: 30
        wrapMode: Text.WordWrap
        text: qsTr("NO_NICKNAME_TIP")
        font {
            family: 'Arial'
            pixelSize: 15
        }
        color: root.defaultTextColor
    }

    InputWithError {
        id: nickName

        focus: true
        anchors {
            left: parent.left
            right: parent.right
        }
        icon: installPath + "Assets/Images/Application/Widgets/NicknameEdit/nickname.png"
        showLanguage: true
        maximumLength: 25
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

        Image {
            width: 30
            height: 30
            fillMode: Image.PreserveAspectFit
            visible: d.nickNameOk
            source: installPath + "Assets/Images/Application/Widgets/NicknameEdit/ok.png"
            anchors {
                right: parent.right
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }
        }
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
        }

        height: techName.height

        Input {
            style {
                normal: "#FFFFFF"
                hover: "#FFFFFF"
                active: "#FFFFFF"
                disabled: "#FFFFFF"
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

            anchors {
                left: parent.left
                leftMargin: 240
                right: parent.right
            }

            maximumLength: 32
            placeholder: qsTr("PROFILE_LINK_PLACEHOLDER")
            onTextChanged: {
                manuallyEdited = !d.generatingTechName;
                d.techNameOk = false;
            }
            onValidate: {
                model.validateTechName(value);
            }

            Image {
                width: 30
                height: 30
                fillMode: Image.PreserveAspectFit
                visible: d.techNameOk
                source: installPath + "Assets/Images/Application/Widgets/NicknameEdit/ok.png"
                anchors {
                    right: parent.right
                    rightMargin: 5
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    PrimaryButton {
        id: saveButton

        width: 200
        text: qsTr("SAVE_BUTTON_CAPTION")
        enabled: (model.nickNameValid && model.techNameValid)
        onClicked: {
            nickName.readOnly = true;
            techName.readOnly = true;
            saveButton.inProgress = true;

            model.saveNickName(nickName.text);
            model.saveTechName(techName.text);
        }
        analytics {
            page: 'NicknameEdit'
            category: 'Auth'
            action: 'Save nickname'
        }
    }
}
