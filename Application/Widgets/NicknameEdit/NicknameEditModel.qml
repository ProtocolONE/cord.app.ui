import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    property bool nickNameValid: false

    signal nickNameError(string error)
    signal nickNameOk()
    signal nickNameSaved()

    function validateNickName(nickName) {
        if (!nickName) {
            root.nickNameValid = false;
            d.nickNameError = "";
            root.nickNameError(d.nickNameError);
            return;
        }

        RestApi.User.validateNickname(encodeURIComponent(nickName),
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

    function saveNickName(nickName) {
        if (!nickName) {
            root.nickNameValid = false;
            d.nickNameError = "";
            root.nickNameError(d.nickNameError);
            return;
        }

        RestApi.User.saveNickname(nickName,
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
                                        User.setNickname(nickName);
                                        root.nickNameSaved();
                                    },
                                    function(error) {
                                        root.nickNameValid = false;
                                        d.nickNameError = qsTr("VALIDATE_NICK_NAME_DEFAULT_ERROR");
                                        root.nickNameError(d.nickNameError);
                                    });
    }

    QtObject {
        id: d

        property bool nickNameSaved: false
        property string nickNameError: ""
    }
}
