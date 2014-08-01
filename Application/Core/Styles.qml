/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0

import "App.js" as App

Item {
    id: root

    //BASE
    property real darkerFactor: 1.2
    property real lighterFactor: 1.2
    property color base: "#092135"

    property color focusOverlay: "#bdbdbd"
    property real focusOverlayOpacity: 0.15

    property color popupBackground: "#F0F5F8"
    property color popupTitleText: "#343537"
    property color popupText: "#343537"

    //GAME INFO
    property color gameInfoBackground: "#f0f5f8"
    property color gameInfoAboutText: "#000000"

    //MESSAGE BOX (ALERT ADAPTER WIDGET)
    property color messageBoxShadowBorder: "#111111"
    property color messageBoxBackground: "#027aca"
    property color messageBoxHeaderText: "#fafafa"
    property color messageBoxText: "#fafafa"
    property color messageBoxPositiveButtonNormal: "#1abc9c"
    property color messageBoxPositiveButtonHover: "#47c9af"
    property color messageBoxNegativeButtonNormal: "#cccccc"
    property color messageBoxNegativeButtonHover: "#ffffff"

    //DOWNLOAD STATUS BLOCK
    property color downloadStatusProgressBackground: "#0d5043"
    property color downloadStatusProgressLine: "#35cfb1"
    property color downloadStatusText: "#eff0f0"

    //GAME INSTALL BLOCK
    property color gameInstallButtonErrorNormal: "#cc0000"
    property color gameInstallButtonErrorHover: "#ee0000"
    property color gameInstallButtonNormal: "#ff4f02"
    property color gameInstallButtonHover: "#ff7902"
    property color gameInstallButtonDisabled: "#888888"

    //HEADER
    property color headerBackground: "#092135"
    property color headerButtonNormal: "#092135"
    property color headerButtonHover: "#243148"
    property color headerButtonText: "#FFFFFF"

    //USER PROFILE
    property color profileBackground: "#243148"
    property color profilePremiumBackground: "#31415D"
    property color profileLevelBackground: "#364D76"
    property color profileNicknameText: "#1ABC9C"
    property color profileLevelText: "#FAFAFA"
    property color profileBalanceText: "#FAFAFA"
    property color profileAddMoneyButtonNormal: "#567DD8"
    property color profileAddMoneyButtonHover: "#305ec8"

    //GAME MENU
    property color gameMenuBackground: "#082135"
    property color gameMenuButtonNormal: "#092135"
    property color gameMenuButtonHover: "#243148"
    property color gameMenuButtonSelectedNormal: "#071828"
    property color gameMenuButtonSelectedHover: "#243148"
    property color gameMenuButtonText: "#FFFFFF"
    property color gameMenuSelectedIndicator: "#FFCA02"
    property color gameMenuText: '#5d7081'

    // SETTINGS
    property color settingsBackground: '#fafafa'
    property color settingsTitleText: '#343537'
    property color settingsCaptionText: '#5c6d7d'
    property color settingsCategoryButtonNormal: "#3498BD"
    property color settingsCategoryButtonHover: "#3670DC"
    property color settingsCategoryButtonActive: "#000000"
    property color settingsSpecialButtonNormal: "#1ADC9C"
    property color settingsSpecialButtonHover: "#019074"
    property color settingsCheckBoxNormal: "#1ADC9C"
    property color settingsCheckBoxHover: "#019074"
    property color settingsRadioButtonNormal: "#1ADC9C"
    property color settingsRadioButtonHover: "#019074"
    property color settingsButtonNormal: "#3498BD"
    property color settingsButtonHover: "#3670DC"

    // AUTH / REGISTRATION
    property color authBackground: '#fafafa'
    property color authHeaderBackground: '#fafafa'

    // NEWS
    property color newsBackground: '#f0f5f8'
    property color newsCommentCountText: '#f5755a'
    property color newsAnnouncementTextNormal: '#5e7182'
    property color newsAnnouncementTextHover: '#38434e'
    property color newsTitleTextNormal: '#2B6A9D'
    property color newsTitleTextHover: '#193f5e'
    property color newsTimeTextNormal: '#7e99ae'
    property color newsTimeTextHover: '#4b5b68'
    property color newsGameTextNormal: '#4ac6aa'
    property color newsGameTextHover: '#2c7666'

    // MAINTENANCE BLOCK
    property color maintenanceBackground: '#082135'

    //MESSENGER BOTTOM BAR
    property color messengerBottomBarBackground: "#FAFAFA"
    property color messengerBottomBarButtonNormal: "#1ABC9C"
    property color messengerBottomBarButtonHover: "#019074"
    property color messengerBottomBarButtonNotificationBackground: "#374E78"
    property color messengerBottomBarButtonNotificationText: "#FFFFFF"

    //MESSENGER SEARCH
    property color messengerSearchBackground: "#FAFAFA"
    property color messengerSearchButtonNormal: "#1ABC9C"
    property color messengerSearchButtonHover: "#019074"
    property color messengerSearchInputNormal: "#e5e5e5"
    property color messengerSearchInputActive: "#3498db"
    property color messengerSearchInputHover: "#3498db"
    property color messengerSearchInputPlaceholder: "#a4b0ba"
    property color messengerWebSearchBackground: '#9fa2a4'
    property color messengerWebSearchBackgroundText: '#ffffff'

    //MESSENGER CONTACT
    property color messengerContactBackground: "#FAFAFA"
    property color messengerContactBackgroundUnread: "#189A19"
    property color messengerContactBackgroundSelected: "#243148"
    property color messengerContactNickname: "#243148"
    property color messengerContactNicknameUnread: "#FAFAFA"
    property color messengerContactNicknameSelected: "#FAFAFA"
    property color messengerContactPresenceOnline: "#1ABC9C"
    property color messengerContactPresenceDnd: "#FFCC00"
    property color messengerContactPresenceOffline: "#CCCCCC"
    property color messengerContactStatusText: "#5B6F81"

    //MESSENGER CONTACT GROUP
    property color messengerContactGroupBackground: "#E5E9EC"
    property color messengerContactGroupName: "#8297a9"
    property color messengerContactGroupUnread: "#FAFAFA"
    property color messengerContactGroupUnreadBackground: "#189A19"

    //MESSENGER RECENT CONTACT GROUP
    property color messengerRecentContactGroupBackground: "#E5E9EC"
    property color messengerRecentContactGroupName: "#8297a9"
    property color messengerRecentContactEmptyInfo: "#000000"

    //MESSENGER CONTACT INPUT
    property color messengerMessageInputBackground: "#FFFFFF"
    property color messengerMessageInputBorder: "#b2b2b2"
    property color messengerMessageInputTextBackground: "#FFFFFF"
    property color messengerMessageInputText: "#252932"
    property color messengerMessageInputSendButtonNormal: "#1ABC9C"
    property color messengerMessageInputSendButtonHover: "#019074"
    property color messengerMessageInputSendButtonText: "#FAFAFA"
    property color messengerMessageInputSendHotkeyText: "#8596A6"
    property color messengerMessageInputPin: '#8badbb'

    //MESSENGER CHAT DIALOG HEADER
    property color messengerChatDialogHeaderBackground: "#253149"
    property color messengerChatDialogHeaderNicknameText: "#FAFAFA"

    //MESSENGER CHAT DIALOG BODY
    property color messengerChatDialogBodyBackground: "#F0F5F8"

    //MESSENGER MESSAGE ITEM
    property color messengerChatDialogMessageNicknameText: "#243148"
    property color messengerChatDialogMessageDateText: "#A4B0BA"
    property color messengerChatDialogMessageText: "#5B6F81"
    property color messengerChatDialogMessageStatusText: "#A4B0BA"

    //MESSENGER CONTACTS
    property color messengerContactsBackground: "#EEEEEE"

    //PRIVATE PART
    property variant styleList
    property string currentStyle
    property alias settingsModel: data

    function setCurrentStyle(value) {
        if (value !== currentStyle) {
            App.setSettingsValue('qml/settings/', 'style', value);
            currentStyle = value;
            apply();
        }
    }

    function updateStyle(value) {
        console.log('WARNING! Use `UpdateStyle` in dev only');

        currentStyle = value || currentStyle;
        readStyles();
        apply(true);
    }

    function getCurrentStyle() {
        return currentStyle;
    }

    function init() {
        currentStyle = App.settingsValue('qml/settings/', 'style', 'mainStyle');
        readStyles();
        apply(true);
    }

    function readStyles() {
        var realPath = installPath.replace('file:///', '')
            , rawStyles = StyleReader.read(realPath + "Assets/Styles/")
            , currentLang = App.language()
            , tmpMap = {}
            , tmpStyles;

        tmpStyles = rawStyles.filter(function(e) {
            return e.hasOwnProperty('id')
                && e.hasOwnProperty('name')
                && e.name.hasOwnProperty('en')
                && e.name.hasOwnProperty(currentLang)
                && e.hasOwnProperty('styles')
                && e.hasOwnProperty('default');
        });

        tmpStyles.sort(function(a, b) {
            if (a['default']) {
                return 1;
            }

            return a.name[currentLang].localeCompare(b.name[currentLang]);
        });

        data.clear();
        tmpStyles.forEach(function(e) {
            tmpMap[e.id] = e.styles;
            data.append({
                value: e.id,
                text: e.name[currentLang]
            });
        });

        styleList = tmpMap;
    }

    function apply(applyNow) {
        if (!styleList.hasOwnProperty(currentStyle)) {
            return;
        }

        if (applyNow) {
            Object.keys(styleList[currentStyle]).forEach(function(prop) {
                if (root.hasOwnProperty(prop) && root[prop] !== styleList[currentStyle][prop]) {
                    root[prop] = styleList[currentStyle][prop];
                }
            });
        } else {
            blendTimer.startAnimation();
        }
    }

    ListModel {
        id: data
    }

    Timer {
        id: blendTimer

        property int frame: 0;
        property variant sourceColors;
        property variant targetColors;
        property variant blendProperties;

        interval: 33
        repeat: true

        function startAnimation() {
            var tmpSourceColors = {}
                , tmpTargetColors = {};

            blendProperties = Object.keys(styleList[currentStyle]).filter(function(prop){
                return root.hasOwnProperty(prop)
                    && typeof(root[prop]) === 'object'
                    && root[prop].toString()[0] === '#'
                    && root[prop] != styleList[currentStyle][prop];
            });

            blendProperties.forEach(function(field) {
                tmpSourceColors[field] = hexToRgb(root[field]);
                tmpTargetColors[field] = hexToRgb(styleList[currentStyle][field]);
            });

            sourceColors = tmpSourceColors;
            targetColors = tmpTargetColors;

            blendTimer.frame = 0;
            blendTimer.start();
        }

        function hexToRgb(hex) {
            var bigint = parseInt(hex.toString().replace('#',''), 16);
            var r = (bigint >> 16) & 255;
            var g = (bigint >> 8) & 255;
            var b = bigint & 255;
            return [r , g, b];
        }

        onTriggered: {
            var delta = Math.min(1.0, ++frame * (blendTimer.interval / 250));
            blendProperties.forEach(function(field) {
                var sourceColor = sourceColors[field];
                var targetColor = targetColors[field];
                var currentR = sourceColor[0] + (targetColor[0] - sourceColor[0]) * delta;
                var currentG = sourceColor[1] + (targetColor[1] - sourceColor[1]) * delta;
                var currentB = sourceColor[2] + (targetColor[2] - sourceColor[2]) * delta;
                var color = Qt.rgba(currentR / 255, currentG / 255, currentB / 255, 1.0);

                root[field] = color;
            });

            if (delta >= 1.0) {
                blendTimer.stop();
            }
        }
    }
}
