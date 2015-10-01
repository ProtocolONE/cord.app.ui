/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

PopupBase {
    id: root

    property alias nickname: nickName.text

    function checkAndFinish() {
        if (d.nickNameSaved) {
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
        property bool nickNameSaved: false

        function tryClose() {
            if (d.nickNameSaved) {
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
                nickName.error = true;
                nickName.style.text = Styles.inputError;
            }
        }
        onNickNameOk: {
            nickName.errorMessage = qsTr("NICKNAME_OK");
            nickName.error = false;
            d.nickNameOk = true;
        }

        onNickNameSaved: {
            d.nickNameSaved = true;
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

    Item {
        anchors {
            left: parent.left
            right: parent.right
        }

        height: nickName.height

        InputWithError {
            id: nickName

            focus: true
            anchors {
                left: parent.left
                right: parent.right
            }
            icon: installPath + Styles.nicknameEditIcon
            showLanguage: true
            maximumLength: 25
            placeholder: qsTr("YOUR_NICKNAME_PLACEHOLDER")

            onTextChanged: {
                d.nickNameOk = false;

                if (!d.nickNameLowBoundReached && nickName.text.length > 3) {
                    d.nickNameLowBoundReached = true;
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
                right: parent.right
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }
        }
    }

    PrimaryButton {
        id: saveButton

        width: 200
        text: qsTr("SAVE_BUTTON_CAPTION")
        enabled: model && model.nickNameValid
        onClicked: {
            nickName.readOnly = true;
            saveButton.inProgress = true;

            model.saveNickName(nickName.text);
        }
        analytics {
            category: 'NicknameEdit'
            action: 'submit'
            label: 'Save nickname'
        }
    }
}
