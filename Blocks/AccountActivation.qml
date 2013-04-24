import QtQuick 1.1

import "." as Blocks
import "../Elements" as Elements
import "../js/restapi.js" as RestApi

Blocks.MoveUpPage {
    id: page

    property string phoneNumber
    property string errorString
    property string previousState
    property bool isReturnAfterError: false
    property bool isInProgress: false
    property QtObject pageContent

    signal phoneLinked()

    //Раскомментируйте строки ниже, чтобы отлаживать экран в QmlViewer

//    property string installPath: "../"

//    Component.onCompleted: {
//        RestApi.Core.setup({url: "http://api-trunk.sabirov.dev/restapi", lang: 'ru'})
//        RestApi.Core.setUserId("400001000130070790");
//        RestApi.Core.setAppKey("5cdf3fe592a21d7d3833489005ff6facedda1c03");
//        page.switchAnimation()
//    }

    state: "main"
    openHeight: 550

    onVisibleChanged: {
        if (!visible) {
            state = "main";
        }
    }

    function showError(message) {
        page.errorString = message;
        page.previousState = page.state;
        page.state = 'error';
        page.isReturnAfterError = true;
    }

    function back() {
        page.state = page.previousState;
    }

    Elements.WorkInProgress {
        active: page.isInProgress
        interval: 50
    }

    Rectangle {
        id: mainBlock

        color: "#353945"
        anchors.fill: parent

        Component {
            id: errorPage

            Item {
                Elements.TextH2 { text: qsTr("TITLE_ACCOUNT_ACTIVATION") }
                Column {
                    spacing: 8
                    anchors { top: parent.top; left: parent.left; topMargin: 2; leftMargin: 200 }

                    Elements.TextH2 {
                        color: "#ebec63"
                        width: 450
                        text: page.errorString
                    }

                    Elements.Button4 {
                        isEnabled: true
                        buttonText: "ОК"
                        onButtonClicked: back();
                    }
                }
            }
        }

        Component {
            id: main

            Item {
                Column {
                    spacing: 2

                    Elements.TextH2 { text: qsTr("TITLE_ACCOUNT_ACTIVATION") }
                    Elements.TextH4 {
                        width: 200
                        color: page.isReturnAfterError ? "#EBEC63" : "#FFFFFF"
                        text: phoneVerification.visible && vkVerification.visible
                            ? qsTr("SUBTITLE_VK_AND_MOBILE")
                            : phoneVerification.visible
                            ? qsTr("SUBTITLE_MOBILE")
                            : qsTr("SUBTITLE_VK")
                    }
                }

                Item {
                    anchors { top: parent.top; left: parent.left; topMargin: 2; leftMargin: 200 }

                    Column {
                        spacing: 25

                        Column {
                            id: phoneVerification

                            spacing: 8

                            Elements.TextH3 {
                                color: page.isReturnAfterError ? "#EBEC63" : "#FFFFFF"
                                text: qsTr("SUBTITLE_MOBILE_ACTIVATION")
                            }

                            Rectangle {
                                width: 165
                                height: 32

                                color: '#ffffff'

                                Text {
                                    x: 7
                                    y: 5
                                    z: 1
                                    font { family: "Century Gothic"; pixelSize: 16 }
                                    text: '+'
                                }

                                Elements.Input {
                                    id: nickNameInput

                                    x: 11

                                    editFocus: true
                                    readOnly: page.isInProgress
                                    width: 165
                                    validator: RegExpValidator { regExp: /^[\(\)\[\]]*([0-9][ \-(\)\[\]]*){6,19}$/ }
                                    textEchoMode: TextInput.Normal
                                    editDefaultText: qsTr("PLACEHOLDER_MOBILE_NUMBER_INPUT")
                                    maximumLength: 17
                                    textEditComponent.text: page.phoneNumber
                                    focus: true
                                }
                            }

                            Item { height: 5; width: 1 }

                            Row {
                                spacing: 7

                                Elements.Button4 {
                                    function isDefaultNumber(str) {
                                        var result = '';

                                        for (var i = 0; i < str.length; ++i) {
                                            var c = str[i];
                                            if (c >= '0' && c <= '9')
                                                result += c
                                        }

                                        return result == '79001234567';
                                    }

                                    isEnabled: nickNameInput.textEditComponent.text.length
                                               && nickNameInput.acceptableInput && !page.isInProgress

                                    buttonText: qsTr("BUTTON_GET_CODE")

                                    onButtonClicked: {
                                        if (isDefaultNumber(nickNameInput.textEditComponent.text)) {
                                            showError(qsTr("ACCOUNT_ACTIVATION_PHONE_NOT_FOUND"));
                                            return;
                                        }

                                        page.isInProgress = true;
                                        RestApi.User.sendMobileActivationCode(
                                            nickNameInput.textEditComponent.text,
                                            function(response) {
                                                page.isInProgress = false;
                                                page.phoneNumber = nickNameInput.textEditComponent.text

                                                if (response.result === 1) {
                                                    page.state = "confirmation"
                                                    return;
                                                }

                                                if (response.error) {
                                                    console.debug(response.error.code)
                                                    showError(response.error.message)
                                                }
                                            },
                                            function(httpError) { page.isInProgress = false; });
                                    }
                                }

                                Elements.Button4 {
                                    isEnabled: true
                                    buttonText: qsTr("BUTTON_CANCEL")
                                    onButtonClicked: page.closeMoveUpPage();
                                }
                            }
                        }

                        Rectangle {
                            visible: phoneVerification.visible && vkVerification.visible
                            width: 500
                            height: 1
                            color: "#535761"
                        }

                        Column {
                            id: vkVerification

                            visible: false
                            spacing: 8

                            Elements.TextH2 {
                                text: qsTr("SUBTITLE_VK_ACTIVATION")
                            }

                            Elements.ButtonVk {
                                buttonColorHover: "#ff9800"
                                buttonColor: "#535761"

                                onButtonPressed: switchAnimation();
                            }
                        }
                    }
                }
            }
        }

        Component {
            id: codeConfirmation

            Item {
                property bool requestInProgress: false

                Elements.TextH2 { text: qsTr("TITLE_ACCOUNT_ACTIVATION") }
                Column {
                    spacing: 8
                    anchors { top: parent.top; left: parent.left; topMargin: 2; leftMargin: 200 }

                    Elements.TextH3 {
                        width: 350
                        text: qsTr("TEXT_CODE_IS_SENT").arg(page.phoneNumber)
                    }

                    Elements.Input {
                        id: codeInput

                        width: 165
                        validator: RegExpValidator { regExp: /[0-9]{,10}/ }
                        readOnly: requestInProgress
                        textEchoMode: TextInput.Normal
                        editDefaultText: qsTr("PLACEHOLDER_ACTIVATION_CODE_INPUT")
                        maximumLength: 10
                        focus: true
                    }

                    Row {
                        spacing: 10

                        Elements.Button4 {
                            isEnabled: true
                            buttonText: qsTr("BUTTON_CODE_CONFIRM")
                            onButtonClicked: {
                                page.isInProgress = true;
                                RestApi.User.validateMobileActivationCode(
                                    codeInput.textEditComponent.text,
                                    function(response) {
                                        page.isInProgress = false;
                                        if (response.error) {
                                            showError(response.error.message)
                                            return;
                                        }

                                        if (response.result === 1) {
                                            phoneLinked();
                                            page.switchAnimation();
                                        }
                                    },
                                    function(httpError) { page.isInProgress = false;});
                            }
                        }

                        Elements.Button4 {
                            isEnabled: true
                            buttonText: qsTr("BUTTON_CANCEL")
                            onButtonClicked: page.state = "main"
                        }
                    }
                }
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 42

            Loader {
                sourceComponent: page.pageContent;
                onLoaded: forceActiveFocus();
            }
        }
    }


    states: [
        State {
            name: "main"
            PropertyChanges { target: page; pageContent: main }
        },
        State {
            name: "confirmation"
            PropertyChanges { target: page; pageContent: codeConfirmation }
        },
        State {
            name: "error"
            PropertyChanges { target: page; pageContent: errorPage }
        }
    ]
}
