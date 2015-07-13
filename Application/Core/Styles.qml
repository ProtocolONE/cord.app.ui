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

    property color focusOverlay: "#bdbdbd"
    property real focusOverlayOpacity: 0.15

    property color trayPopupBackground: "#00111A" // bg_darkblue
    property color trayPopupHeaderBackground: "#c44b33"
    property color trayPopupButtonNormal: "#c44b33"
    property color trayPopupButtonHover: "#e94d2f"
    property color trayPopupTextHeader: "#a1c1d2"
    property color trayPopupPlayText: '#a1c1d2' // на макетах нигде нет - оставил == trayPopupTextHeader
    property color trayPopupText: "#FFFFFF"

    // Images header
    property string headerGameNetLogo: "Assets/Images/Application/Blocks/Header/GamenetLogo.png"
    property string headerAllGames: "Assets/Images/Application/Blocks/Header/AllGames.png"
    property string headerMyGames: "Assets/Images/Application/Blocks/Header/MyGames.png"
    property string headerSupport: "Assets/Images/Application/Blocks/Header/Support.png"
    property string headerThemes: "Assets/Images/Application/Blocks/Header/Themes.png"
    property string headerClose: "Assets/Images/Application/Blocks/Header/Close.png"
    property string headerLogout: "Assets/Images/Application/Blocks/Header/Logout.png"
    property string headerSettings: "Assets/Images/Application/Blocks/Header/Settings.png"

    // Images game menu
    property string gameMenuNewsIcon: "Assets/Images/Application/Blocks/GameMenu/News.png"
    property string gameMenuAboutIcon: "Assets/Images/Application/Blocks/GameMenu/About.png"
    property string gameMenuBlogIcon: "Assets/Images/Application/Blocks/GameMenu/Blog.png"
    property string gameMenuGuidesIcon: "Assets/Images/Application/Blocks/GameMenu/Guides.png"
    property string gameMenuForumIcon: "Assets/Images/Application/Blocks/GameMenu/Forum.png"
    property string gameMenuSettingsIcon: "Assets/Images/Application/Blocks/GameMenu/Settings.png"
    property string gameMenuExtendedAccIcon: "Assets/Images/Application/Blocks/GameMenu/Accounts.png"
    property string gameMenuAccessIcon: "Assets/Images/Application/Blocks/GameMenu/Access.png" //INFO GN-8631

    property string popupCloseIcon: "Assets/Images/Application/Core/Popup/close.png"

    property string accountActivationLockIcon: "Assets/Images/Application/Widgets/AccountActivation/lock.png"
    property string accountActivationPhoneIcon: "Assets/Images/Application/Widgets/AccountActivation/phone_plus.png"

    property string applicationSettingsStyleIcon: "Assets/Images/Application/Widgets/ApplicationSettings/style.png"
    property string applicationSettingsLanguageIcon: "Assets/Images/Application/Widgets/ApplicationSettings/language.png"
    property string applicationSettingsDefaultSettingsIcon: "Assets/Images/Application/Widgets/ApplicationSettings/defaultSettings.png"

    property string messengerChatSearchIcon: "Assets/Images/Application/Widgets/Messenger/chat_search.png"
    property string messengerChatClose: "Assets/Images/Application/Widgets/Messenger/close_chat.png"
    property string messengerGroupIcon: "Assets/Images/Application/Widgets/Messenger/groupIcon.png"
    property string messengerHeaderGroupIcon: "Assets/Images/Application/Widgets/Messenger/ContactItem/editGroupChatIcon.png"
    property string messengerNotificationsIcon: "Assets/Images/Application/Widgets/Messenger/notifications.png"
    property string messengerSearchCloseIcon: "Assets/Images/Application/Widgets/Messenger/searchClose.png"
    property string messengerSmileButtonIcon: "Assets/Images/Application/Widgets/Messenger/smileButton.png"
    property string messengerLocalSearchIcon: "Assets/Images/Application/Widgets/Messenger/localSearch.png"
    property string messengerWebSearchIcon: "Assets/Images/Application/Widgets/Messenger/webSearch.png"
    property string messengerGroupCountIcon: "Assets/Images/Application/Widgets/Messenger/ContactItem/groupCountIcon.png"

    property string secondAccountAuthLogoutIcon: "Assets/Images/Application/Widgets/SecondAccountAuth/logout.png"

    property string userProfilePremiumIcon: "Assets/Images/Application/Widgets/UserProfile/premium.png"
    property string promoCodeIcon: "Assets/Images/Application/Widgets/PromoCode/promo.png"
    property string nicknameEditIcon: "Assets/Images/Application/Widgets/NicknameEdit/nickname.png"

    //GameNet Input
    property string inputCaptchaIcon: "Assets/Images/GameNet/Controls/Input/captcha.png"
    property string inputEmailIcon: "Assets/Images/GameNet/Controls/Input/email.png"
    property string inputPasswordIcon: "Assets/Images/GameNet/Controls/Input/password.png"
    property string inputUpdateIcon: "Assets/Images/GameNet/Controls/Input/update.png"

    property string allGamesDropDown: "Assets/Images/Application/Widgets/AllGames/crossButton.png"

    // GameNet 3.4
    property double baseBackgroundOpacity: 0.75
    property double darkBackgroundOpacity: 0.90
    property double blockInnerOpacity: 0.10 //block_inner

    property color light: "#FFFFFF"
    property color dark: "#000000"

    property color primaryButtonNormal: '#ff4f02'
    property color primaryButtonHover: '#ff6102'
    property color primaryButtonDisabled: '#888888'
    property color primaryButtonText: "#FFFFFF"
    property color primaryBorder: "#FFDD82"

    property color primaryButtonNormal: '#ff4f02'
    property color primaryButtonHover: '#ff6102'
    property color primaryButtonDisabled: '#888888'

    //Teach english ;) auxiliary = secondary ;)
    property color auxiliaryButtonNormal: "#1ABC9C"
    property color auxiliaryButtonHover: "#019074"
    property color auxiliaryButtonDisabled: "#888888"
    property color auxiliaryButtonText: "#FFFFFF"

    property color minorButtonNormal: "#02141d"
    property color minorButtonHover: "#020e15"
    property color minorButtonDisabled: "#031824"
    property color minorButtonActive: "#02141d"
    property color minorButtonText: "#7e8f9e"

    property color errorButtonNormal: "#cc0000"
    property color errorButtonHover: "#ee0000"

    property color checkedButtonActive: "#31bca0"
    property color checkedButtonInactive: "#24475a"

    property color radioButtonNormal: "#7e8f9e"
    property color radioButtonHover: "#a1c1d2"
    property color radioButtonDisabled: "#031824"
    property color radioButtonActive: "#fada66"
    property color radioButtonActiveHover: "#FDEDB3"

    property color checkboxNormal: "#7e8f9e"
    property color checkboxHover: "#a1c1d2"
    property color checkboxDisabled: "#7e8f9e"
    property color checkboxActive: "#31bca0"
    property color checkboxActiveHover: "#3cccb6"

    property color lightText: '#FFFFFF'
    property color titleText: '#45bef6' // title
    property color infoText: '#7e8f9e' // info
    property color textBase: '#a1c1d2' // text
    property color textAttention: '#ff4f02' // popup_title
    property color textTime: '#577889' // chat_time
    property color menuText: "#FFFFFF" // menu
    property color mainMenuText: "#FFFFFF" // main_menu
    property color chatInactiveText: "#577889" // chat_inactive
    property color bannerTitleText: "#FFFFFF" //banner_title
    property color bannerInfoText: "#FFDD82" // big_banner_info, banner_info
    property color chatButtonText: "#FFFFFF" // chat_btn
    property color linkText: "#45bef6" // link
    property color fieldText: "#363636" // field
    property color premiumInfoText: "#FFDD82" //premium_info

    // Базовый фон самого рута приложения
    property color applicationBackground: "#002336"
    //property color applicationBackground: "#002336"
    property color contentBackgroundDark: "#00111A" // bg_darkblue
    property color contentBackgroundLight: "#4ca8db" // bg_lightblue

    property color popupBlockBackground: "#19384A" // названия нет, вероятно переименовать надо

    property color trayMenuHeaderBackground: "#0A1C26"
    property color trayMenuBorder: "#324E5E"

    // Конкретные цвета разных иконок
    property color messengerContactPresenceOnline: "#1ABC9C"
    property color messengerContactPresenceDnd: "#FFCC00"
    property color messengerContactPresenceOffline: "#CCCCCC"
    property color messengerContactUnreadContact: "#FFDD82"

    property color messengerRecentContactsUnreadIcon: "#189A19"

    property color detailedUserInfoGameCharsPlayingIcon: "#1abc9c"
    property color detailedUserInfoGameCharsTableFriendText: "#1abc9c"
    property color detailedUserInfoMainInfoLevelProgressLine: "#1abc9c"

    property color gameGridHightlight: '#dec37b'
    property color gameGridProgress: "#1abc9c"

    // Если будет использоваться еще, то вероятно переименовать:
    property color searchBorder: "#3498db"

    property color inputNormal: "#363636"
    property color inputHover: "#3498db"
    property color inputActive: "#3498db"
    property color inputDisabled: "#66758F"
    property color inputBackground: "#FFFFFF"
    property color errorContainerText: "#FF3b30"
    property color errorContainerBackground: "#00000000"
    property color inputError: "#FF3b30"
    property color inputPlaceholder: "#a1c1d2"
    property color inputText: "#363636"

    property color comboboxBackground: "#FFFFFF"
    property color comboboxNormal: "#ffffff"
    property color comboboxHover: "#3498db"
    property color comboboxActive: "#3498db"
    property color comboboxDisabled: "#66758F"
    property color comboboxSelectHover: "#EBEBEB"
    property color comboboxText: "#363636"
    property color comboboxScrollBarCursor: "#00000000"
    property color comboboxScrollBarCursorHover: '#95999b'

    //MESSAGE BOX (ALERT ADAPTER WIDGET)
    property color messageBoxBorder: "#ffdd82"
    property color messageBoxBackground: "#031d2b"
    property color messageBoxHeaderText: "#ff4f02"
    property color messageBoxText: "#7c99a9"

    //POPUP BOX (GENERIC COLORS)
    property color popupBorder: "#ffdd82"
    property color popupBackground: "#031d2b"
    property color popupTitleText: "#ff4f02"
    property color popupText: "#7c99a9"
    property color popupSplitter: "#ffffff"

    //Progress bar control
    property color downloadProgressBackground: "#0d5043"
    property color downloadProgressLine: "#35cfb1"

    // End of GameNet 3.4

    //PRIVATE PART
    property variant styleList
    property string styleListOriginal

    property string currentStyle
    property alias settingsModel: data

    property int version: 2

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

    function readStyleObject() {
        var realPath = installPath.replace('file:///', '');
        return StyleReader.read(realPath + "Assets/Styles/")
    }

    function readStyles() {
        var rawStyles = readStyleObject()
            , currentLang = App.language()
            , tmpMap = {}
            , tmpStyles;

        tmpStyles = rawStyles.filter(function(e) {
            var hasValidProperties = e.hasOwnProperty('id')
                && e.hasOwnProperty('name')
                && e.name.hasOwnProperty('en')
                && e.name.hasOwnProperty(currentLang)
                && e.hasOwnProperty('styles')
                && e.hasOwnProperty('version')
                && e.hasOwnProperty('default');

            return hasValidProperties && e['version'] >= root.version;
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
        styleListOriginal = JSON.stringify(rawStyles);
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

    Shortcut {
        key: "Ctrl+Shift+Z"
        onActivated: {
            dev.running = !dev.running
            console.log('WARNING! Style realoadign ' + dev.running)
        }
    }

    Timer {
        id: dev

        interval: 250
        repeat: true
        onTriggered: {
            var rawStyles = readStyleObject();
            if (JSON.stringify(rawStyles) != styleListOriginal) {
                updateStyle()
            }
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
                , tmpTargetColors = {}
                , tmpProps;

            tmpProps = Object.keys(styleList[currentStyle]).filter(function(prop){
                return root.hasOwnProperty(prop)
                    && root[prop] != styleList[currentStyle][prop];
            });

            tmpProps.filter(function(prop) {
                var type = typeof(root[prop]);
                return type === 'number' || type === 'string';
            }).forEach(function(prop) {
                root[prop] = styleList[currentStyle][prop];
            });

            blendProperties = tmpProps.filter(function(prop){
                return typeof(root[prop]) === 'object'
                    && root[prop].toString()[0] === '#';
            });

            blendProperties.forEach(function(field) {
                tmpSourceColors[field] = hexToRgba(root[field]);
                tmpTargetColors[field] = hexToRgba(styleList[currentStyle][field]);
            });

            sourceColors = tmpSourceColors;
            targetColors = tmpTargetColors;

            blendTimer.frame = 0;
            blendTimer.start();
        }

        function hexToRgba(hex) {
            var value = hex.toString().replace('#','')
                , a = 255
                , offset = 0
                , r
                , g
                , b;

            if (value.length === 8) {
                a = parseInt(value.substring(0, 2), 16);
                offset = 2;
            }

            r = parseInt(value.substring(0 + offset, 2 + offset), 16);
            g = parseInt(value.substring(2 + offset, 4 + offset), 16);
            b = parseInt(value.substring(4 + offset, 6 + offset), 16);

            return [r, g, b, a];
        }

        onTriggered: {
            var delta = Math.min(1.0, ++frame * (blendTimer.interval / 250));
            blendProperties.forEach(function(field) {
                var sourceColor = sourceColors[field];
                var targetColor = targetColors[field];
                var currentR = sourceColor[0] + (targetColor[0] - sourceColor[0]) * delta;
                var currentG = sourceColor[1] + (targetColor[1] - sourceColor[1]) * delta;
                var currentB = sourceColor[2] + (targetColor[2] - sourceColor[2]) * delta;
                var currentA = sourceColor[3] + (targetColor[3] - sourceColor[3]) * delta;
                var color = Qt.rgba(currentR / 255, currentG / 255, currentB / 255, currentA / 255);

                root[field] = color;
            });

            if (delta >= 1.0) {
                blendTimer.stop();
            }
        }
    }
}
