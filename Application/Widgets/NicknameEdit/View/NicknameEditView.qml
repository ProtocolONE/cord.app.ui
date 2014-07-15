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

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    property alias nickname: nickName.text

    function checkAndFinish() {
        if (d.nickNameSaved && d.techNameSaved) {
            root.save();
        }
    }

    width: 630
    height: allContent.height + 40
    clip: true


    QtObject {
        id: d

        property bool nickNameLowBoundReached: false
        property bool nickNameSaved: false
        property bool techNameSaved: false

        function tryClose() {
            if (d.nickNameSaved && d.techNameSaved) {
                root.close();
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#F0F5F8"
    }

    Column {
        id: allContent

        y: 20
        spacing: 20

        Text {
            anchors {
                left: parent.left
                leftMargin: 20
            }
            font {
                family: 'Arial'
                pixelSize: 20
            }
            color: '#343537'
            smooth: true
            text: qsTr("CREATE_NICKNAME_TITLE")
        }

        HorizontalSplit {
            width: root.width

            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
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
                        nickName.error = true;
                        nickName.style.text = "#1ABC9C";
                    }
                    onTechNameError: {
                        if (!d.nickNameLowBoundReached) {
                            nickName.error = false;
                            return;
                        }

                        if (error != "") {
                            techName.errorMessage = error;
                            techName.style.text = "#FF2E44";
                            techName.error = true;
                        }
                    }
                    onTechNameOk: {
                        techName.errorMessage = qsTr("NICKNAME_OK");
                        techName.error = true;
                        techName.style.text = "#1ABC9C";
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

                InputWithError {
                    id: nickName

                    width: body.width
                    icon: installPath + "Assets/Images/Application/Widgets/NicknameEdit/nickname.png"
                    showLanguage: true
                    placeholder: qsTr("YOUR_NICKNAME_PLACEHOLDER")

                    onTextChanged: {
                        if (!d.nickNameLowBoundReached && nickName.text.length > 4) {
                            d.nickNameLowBoundReached = true;
                        }

                        techName.text = model.generateTechNick(nickName.text);
                    }
                    onValidate: {
                        if (!d.nickNameLowBoundReached) {
                            return;
                        }

                        model.validateNickName(nickName.text);
                    }
                }

                Item {
                    width: body.width
                    height: techName.height

                    Input {
                        style: InputStyleColors {
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
                        placeholder: "http://www.gamenet.ru/users/"
                    }

                    InputWithError {
                        id: techName

                        x: 238
                        width: 352
                        placeholder: qsTr("PROFILE_LINK_PLACEHOLDER")
                        onValidate: {
                            if (!d.nickNameLowBoundReached) {
                                return;
                            }

                            model.validateTechName(value);
                        }
                    }
                }
            }
        }

        HorizontalSplit {
            width: root.width
            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
            }
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
}
