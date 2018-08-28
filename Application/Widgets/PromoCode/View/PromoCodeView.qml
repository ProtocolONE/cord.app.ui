import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

PopupBase {
    id: root

    property variant gameItem

    Component.onCompleted: {
        root.gameItem = App.currentGame();
        d.requestSettings();
    }

    QtObject {
        id: d

        property bool loading: true
        property bool promocodeInputActive: false

        property string title: ""
        property string message: ""
        property bool isTurnedOff: true
        property string getPromoLink: ""
        property bool hasPromoLink: !!d.getPromoLink

        function activateCode() {
            activateButton.inProgress = true;

            RestApi.User.activatePromoKey(
                        promoCode.text,
                        function(response) {
                            activateButton.inProgress = false;

                            if (response.result === 1) {
                                App.downloadButtonStart(root.gameItem.serviceId)
                                root.close();
                                return;
                            }

                            if (response.error) {
                                promoCode.errorMessage = response.error.message;
                                promoCode.error = true;


                            } else {
                                promoCode.errorMessage = qsTr("UNKNOWN_PROMO_VALIDATION_ERROR");
                                promoCode.error = true;
                            }

                        },
                        function(httpError) {
                            activateButton.inProgress = false;
                            promoCode.errorMessage = qsTr("UNKNOWN_PROMO_VALIDATION_ERROR");
                            promoCode.error = true;

                            Ga.trackException(promoCode.errorMessage, false);
                        });
        }

        function requestSettings() {
            RestApi.Service.getPromoKeysSettings(root.gameItem.serviceId, d.settingsResultCallback, d.settingsResultCallbacks);
        }

        function settingsResultCallback(response) {
            if (!!!response) {
                return;
            }

            d.message = response.description || "";
            d.title = response.title || "";
            d.isTurnedOff = !!response.isTurnedOff;
            d.getPromoLink = response.link || "";
            d.loading = false;
        }

        function activatePromoInput() {
            promoCode.focus = true;
            d.promocodeInputActive = true
        }

    }

    title: qsTr("Активация ключа")
    clip: true

    Behavior on implicitHeight {
        NumberAnimation { duration: 250 }
    }

    Item {
        width: parent.width
        height: childrenRect.height

        Text {
            id: messageText

            text: d.message
            width: parent.width
            font.pixelSize: 16
            color: defaultTextColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            visible: !!text
        }
    }

    Item {
        id: promoCode1

        visible: false
        width: parent.width
        height: childrenRect.height

        InputWithError {
            id: promoCode

            width: parent.width
            icon: installPath + Styles.promoCodeIcon
            showLanguage: true
            placeholder: qsTr("Введите ключ")
        }
    }

    Row {
        height: 48
        width: parent.width
        spacing: 30

        PrimaryButton {
            id: showPromoInputButton

            visible: false
            width: Math.max(implicitWidth, 200)
            text: qsTr("Ввести ключ")
            onClicked: d.activatePromoInput();
        }

        PrimaryButton {
            id: activateButton

            visible: false
            width: Math.max(implicitWidth, 200)
            text: qsTr("ACIVATE_BUTTON_CAPTION")
            enabled: promoCode.text.length > 0
            analytics {
                category: 'PromoCode'
                action: 'submit'
                label: root.gameItem ? root.gameItem.gaName : ""
            }

            onClicked: d.activateCode();
        }

        PrimaryButton {
            id: getPromoCodeButton

            visible: false
            width: Math.max(implicitWidth, 200)
            text: qsTr("Получить ключ")
            onClicked: {
                App.openExternalUrlWithAuth(d.getPromoLink);
                d.activatePromoInput();
            }
        }

        PrimaryButton {
            id: closeButton

            visible: false
            width: Math.max(implicitWidth, 200)
            text: qsTr("Закрыть")
            onClicked: root.close();
        }
    }

    StateGroup {
        state: ""
        states: [
            State {
                name: ""
                when: d.loading
            },
            State {
                name: "TurnedOff"
                when: d.isTurnedOff
                PropertyChanges { target: closeButton; visible: true }
                PropertyChanges { target: root; title: d.title || qsTr("На текущий момент игра недоступна.") }
                PropertyChanges { target: messageText; text: d.message || qsTr("Следите за новостями.") }
            },
            State {
                name: "TurnedOn"
                PropertyChanges { target: root; title: d.title || qsTr("Закрытый доступ") }
                PropertyChanges { target: messageText; text: d.message || qsTr("Запуск игры возможен только при наличии промо ключа.") }
            },
            State {
                when: !d.isTurnedOff && !d.hasPromoLink && !d.promocodeInputActive
                name: "NoPromoLink"
                extend: "TurnedOn"

                PropertyChanges { target: showPromoInputButton; visible: true }
                PropertyChanges { target: closeButton; visible: true }
            },
            State {
                when: !d.isTurnedOff && d.hasPromoLink && !d.promocodeInputActive
                name: "HasPromoLink"
                extend: "TurnedOn"

                PropertyChanges { target: showPromoInputButton; visible: true }
                PropertyChanges { target: getPromoCodeButton; visible: true }
            },
            State {
                when: !d.isTurnedOff && !d.hasPromoLink && d.promocodeInputActive
                name: "NoPromoLinkActive"
                extend: "TurnedOn"

                PropertyChanges { target: promoCode1; visible: true }
                PropertyChanges { target: activateButton; visible: true }
                PropertyChanges { target: closeButton; visible: true }
            },
            State {
                when: !d.isTurnedOff && d.hasPromoLink && d.promocodeInputActive
                name: "HasPromoLinkActive"
                extend: "TurnedOn"

                PropertyChanges { target: promoCode1; visible: true }
                PropertyChanges { target: activateButton; visible: true }
                PropertyChanges { target: getPromoCodeButton; visible: true }
            }
        ]
    }
}
