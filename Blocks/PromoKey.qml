import QtQuick 1.1

import "." as Blocks
import "../Elements" as Elements
import "../js/restapi.js" as RestApi
import "../js/Core.js" as Core
import "../js/GoogleAnalytics.js" as GoogleAnalytics

Blocks.MoveUpPage {
    id: page

    property string errorString
    property string previousState

    property bool isError: false
    property bool isInProgress: false

    signal keyActivated()

    //Раскомментируйте строки ниже, чтобы отлаживать экран в QmlViewer

    //property string installPath: "../"

    //    Component.onCompleted: {
    //        RestApi.Core.setup({url: "http://api.bondarenko.dev/restapi", lang: 'ru'})
    //        RestApi.Core.setUserId("400001000000000230");
    //        RestApi.Core.setAppKey("cc66bedb76ee73d839318372ede91da671dc3511");
    //        page.switchAnimation()
    //    }

    openHeight: 550
    onFinishOpening: sendGoogleStat('show')

    function sendGoogleStat(action) {
        var game = Core.currentGame();
        if (game) {
            GoogleAnalytics.trackEvent('/game/' + game.gaName, 'PromoKey', action);
        }
    }

    Elements.WorkInProgress {
        active: page.isInProgress
        interval: 50
    }

    Rectangle {
        id: mainBlock

        color: "#353945"
        anchors.fill: parent
        focus: true

        Item {
            anchors.fill: parent
            anchors.margins: 42

            Column {
                spacing: 2

                Elements.TextH2 { text: qsTr("TITLE_PROMOKEY") }
                Elements.TextH4 {
                    width: 200
                    color: page.isError ? "#EBEC63" : "#FFFFFF"
                    text: qsTr("SUBTITLE_PROMOKEY")
                }
            }

            Item {
                anchors { top: parent.top; left: parent.left; topMargin: 2; leftMargin: 200 }

                Column {
                    spacing: 25

                    Column {
                        spacing: 8

                        Elements.TextH3 {
                            color: "#FFFFFF"
                            text: qsTr("SUBTITLE_PROMOKEY_ACTIVATION")
                        }

                        Rectangle {
                            width: 165
                            height: 32
                            color: '#FFFFFF'

                            Elements.Input {
                                id: promoKeyInput

                                x: 11
                                editFocus: true
                                readOnly: page.isInProgress
                                width: 415
                                validator: RegExpValidator { regExp: /^[\w-]{36}$/ }
                                textEchoMode: TextInput.Normal
                                editDefaultText: qsTr("PLACEHOLDER_PROMOKEY")
                                maximumLength: 36
                                textEditComponent.text: page.phoneNumber
                                focus: true
                                onEnterPressed: {
                                    if (confirmButton.isEnabled) {
                                        confirmButton.trigger();
                                    }
                                }
                            }
                        }

                        Item { height: 5; width: 1 }

                        Elements.TextH3 {
                            id: activationResutText
                            color: page.isError ? "#EBEC63" : "#00FF00"
                        }

                        Row {
                            spacing: 7

                            Elements.Button4 {
                                id: confirmButton

                                function trigger() {
                                    page.isInProgress = true;
                                    RestApi.User.activatePromoKey(
                                        promoKeyInput.textEditComponent.text,
                                        function(response) {
                                            page.isInProgress = false;

                                            if (response.result === 1) {
                                                page.isError = false;
                                                page.keyActivated();
                                                page.closeMoveUpPage();
                                                return;
                                            }

                                            if (response.error) {
                                                page.isError = true;
                                                activationResutText.text = response.error.message;
                                            }
                                        },
                                        function(httpError) { page.isInProgress = false; });
                                }

                                isEnabled: promoKeyInput.textEditComponent.text.length
                                           && promoKeyInput.acceptableInput
                                           && !page.isInProgress

                                buttonText: qsTr("BUTTON_ACTIVATE_KEY")
                                onButtonClicked: trigger();
                            }

                            Elements.Button4 {
                                isEnabled: true
                                buttonText: qsTr("BUTTON_CANCEL")
                                onButtonClicked: page.closeMoveUpPage();
                            }
                        }
                    }
                }
            }
        }
    }
}
