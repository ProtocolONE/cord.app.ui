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

    property color trayPopupBackground: '#475671'
    property color trayPopupBackgroundBorder: '#303947'
    property color trayPopupTextHeader: '#97aacd'
    property color trayPopupPlayText: '#8c9fc1'
    property color trayPopupText: '#ffffff'

    property color secondAccountBaseBackground: "#082135"
    property color secondAccountAddAccountBackground: "#082135"
    property color secondAccountAddAccountButtonHormal: "#1ABC9C"
    property color secondAccountAddAccountButtonHover: "#019074"
    property color secondAccountAddAccountButtonText: "#FFFFFF"
    property color secondAccountAuthedBackground: "#253149"
    property color secondAccountBackground: "#253149"
    property color secondAccountTitle: "#597082"
    property color secondAccountNickname: "#ffffff"
    property color secondAccountPlayButtonNormal: "#1ABC9C"
    property color secondAccountPlayButtonHover: "#019074"
    property color secondAccountPlayButtonDisabled: "#888888"
    property color secondAccountPlayButtonText: "#FFFFFF"

    property color secondAccountPopupAuthDelimiter: "#CCCCCC"
    property color secondAccountPopupAuthTitleText: "#363636"
    property color secondAccountPopupAuthSubTitleText: "#66758F"

    property color inputNormal: "#66758F"
    property color inputHover: "#3498DB"
    property color inputActive: "#3498DB"
    property color inputDisabled: "#66758F"
    property color inputError: "#FF6555"
    property color inputPlaceholder: "#d6d6d6"
    property color inputBackground: "#FFFFFF"
    property color inputText: "#000000"
    property color errorContainerText: "#FF2E44"
    property color errorContainerBackground: "#00000000"

    //FACTS WIDGET
    property color factsWidgetBackground: "#092135"
    property color factsWidgetValue: "#ff6555"
    property color factsWidgetText: "#fafafa"

    //AD BANNER WIDGET
    property color gameAdWidgetBackground: "#092135"
    property color gameAdWidgetText: "#fafafa"

    //GAME INFO
    property color gameInfoBackground: "#001825"
    property color gameInfoImageBackground: '#001825'
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
    property color gameInstallBackground: "#082135"
    property color gameInstallGameName: "#ffffff"
    property color gameInstallGameShortDescription: "#597082"
    property color gameInstallDownloadStatusText: "#597082"
    property color gameInstallButtonErrorNormal: "#cc0000"
    property color gameInstallButtonErrorHover: "#ee0000"
    property color gameInstallButtonNormal: "#ff4f02"
    property color gameInstallButtonHover: "#ff7902"
    property color gameInstallButtonDisabled: "#888888"

    //  GAME UNINSTALLWIDGET
    property color gameUninstallWidgetBackground: "#00000000"
    property color gameUninstallWidgetBorder: "#e1e5e8"
    property color gameUninstallWidgetProgressBackground: "#0d5144"
    property color gameUninstallWidgetProgressLine: "#32cfb2"

    //HEADER
    property color headerBackground: "#092135"
    property color headerButtonNormal: "#092135"
    property color headerButtonHover: "#243148"
    property color headerButtonText: "#FFFFFF"

    //USER PROFILE
    property color profileBackground: "#243148"
    property color profileBackgroundTop: "#0d2e40"
    property color profilePremiumBackground: "#31415D"
    property color profileLevelBackground: "#364D76"
    property color profileNicknameTextNormal: "#ffffff"
    property color profileNicknameTextNotValid: "#7c99a9"
    property color profileLevelText: "#FAFAFA"
    property color profileBalanceText: "#FAFAFA"
    property color profileBaseText: "#7c99a9"
    property color profileAddMoneyNormal: "#19384a"
    property color profileAddMoneyHover: "#ff4f03"
    property color profileAddMoneyTextHover: "#fada66"
    property color profileAddMoneyButtonText: "#FFFFFF"
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
    property color settingsCaptionText: '#FFFFFF'
    property color settingsCategoryButtonNormal: "#3498BD"
    property color settingsCategoryButtonHover: "#3670DC"
    property color settingsCategoryButtonActive: "#000000"
    property color settingsSpecialButtonNormal: "#1ADC9C"
    property color settingsSpecialButtonHover: "#019074"
    property color settingsSpecialButtonDisabled: "#FF4F02"
    property color settingsControlNormal: "#1ADC9C"
    property color settingsControlHover: "#019074"
    property color settingsControlDisabled: "#FF4F02"
    property color settingsButtonNormal: "#3498BD"
    property color settingsButtonHover: "#3670DC"

    // AUTH / REGISTRATION
    property color authBackground: '#fafafa'
    property color authHeaderBackground: '#fafafa'
    property color authDelimiter: "#CCCCCC"
    property color authTitleText: "#363636"
    property color authSubTitleText: "#66758F"
    property color authSupportButtonNormal: "#ffae02"
    property color authSupportButtonHover: "#ffcc02"
    property color authSupportButtonText: "#FFFFFF"
    property color authLicenseButtonTextNormal: "#3498db"
    property color authLicenseButtonTextHover: "#3670DC"
    property color authAmnesiaButtonTextNormal: "#3498db"
    property color authAmnesiaButtonTextHover: "#3670DC"
    property color authSwitchPageButtonHormal: "#3498db"
    property color authSwitchPageButtonHover: "#3670DC"
    property color authRememberCheckBoxNormal: "#1ADC9C"
    property color authRememberCheckBoxHover: "#019074"
    property color authVkButtonNormal: "#4D739E"
    property color authVkButtonHover: "#3378c7"
    property color authVkButtonText: "#FFFFFF"
    property color authSendCodeButtonNormal: "#1ABC9C"
    property color authSendCodeButtonHover: "#019074"
    property color authCancelCodeHormal: "#3498db"
    property color authCancelCodeHover: "#3670DC"
    property color authRegistrationNavigateItem: '#fffffd'
    property color authRegistrationNavigateItemHover: '#ff4f03'
    property color authRegistrationNavigateItemDisabled: '#818c92'

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

    //MESSENGER SEARCH
    property color messengerSearchInputNormal: "#3e7090"
    property color messengerSearchInputActive: "#3e7090"
    property color messengerSearchInputHover: "#3e7090"
    property color messengerSearchInputBackground: "#324e5e"
    property color messengerSearchInputBackgroundHover: "#183240"
    property color messengerSearchInputPlaceholder: "#3e7090"
    property color messengerSearchInputText: "#3e7090"
    property color messengerSearchInputTextHover: "#ffffff"

    //GRID INFO !!! эти стили к мессенджеру отношения не имеют
    property color messangerGridBackground: '#000c13'
    property color messengerAllButtonGridHover: "#113344"
    property color messengerAllButtonGridTextHover: "#f3d173"
    property color messengerAllButtonGridTextNormal: "#ff6555"
    property color messengerGameItemText: '#ddc071'
    property color messengerGameItemTextNormal: '#ffffff'
    property color messengerGridBackgroud: '#092135'
    property color messengerGridHightlight: '#dec37b'
    property color messengerGridProgressRect: '#247f71'
    property color messengerGridGenreText: '#8e9ca7'
    property color messengerGridStickText: '#ffffff'

    // Images header
    property string headerGameNetLogo: "Assets/Images/Application/Blocks/Header/GamenetLogo.png"
    property string headerAllGames: "Assets/Images/Application/Blocks/Header/AllGames.png"
    property string headerMyGames: "Assets/Images/Application/Blocks/Header/MyGames.png"
    property string headerSupport: "Assets/Images/Application/Blocks/Header/Support.png"
    property string headerThemes: "Assets/Images/Application/Blocks/Header/Themes.png"

    // Images game menu
    property string gameMenuNewsIcon: "Assets/Images/Application/Blocks/GameMenu/News.png"
    property string gameMenuAboutIcon: "Assets/Images/Application/Blocks/GameMenu/About.png"
    property string gameMenuBlogIcon: "Assets/Images/Application/Blocks/GameMenu/Blog.png"
    property string gameMenuGuidesIcon: "Assets/Images/Application/Blocks/GameMenu/Guides.png"
    property string gameMenuForumIcon: "Assets/Images/Application/Blocks/GameMenu/Forum.png"
    property string gameMenuSettingsIcon: "Assets/Images/Application/Blocks/GameMenu/Settings.png"
    property string gameMenuExtendedAccIcon: "Assets/Images/Application/Blocks/GameMenu/Accounts.png"
    property string gameMenuAccessIcon: "Assets/Images/Application/Blocks/GameMenu/Access.png" //INFO GN-8631

    // GameNet 3.4
    property double baseBackgroundOpacity: 0.75
    property double darkBackgroundOpacity: 0.90
    property double blockInnerOpacity: 0.10 //block_inner

    property color light: "#FFFFFF"
    property color dark: "#000000"

    property color primaryButtonNormal: '#ff4f02'
    property color primaryButtonHover: '#ff6102'

    property color checkedButtonActive: "#31bca0"
    property color checkedButtonInactive: "#24475a"

    property color primaryBorder: "#FFDD82"

    property color primaryButtonNormal: '#ff4f02'
    property color primaryButtonHover: '#ff6102'
    property color primaryButtonDisabled: '#888888'

    //Teach english ;) auxiliary = secondary ;)
    property color auxiliaryButtonNormal: "#1ABC9C"
    property color auxiliaryButtonHover: "#019074"
    property color auxiliaryButtonDisabled: "#888888"

    property color errorButtonNormal: "#cc0000"
    property color errorButtonHover: "#ee0000"

    property color checkedButtonActive: "#31bca0"
    property color checkedButtonInactive: "#24475a"

    property color lightText: '#FFFFFF'
    property color titleText: '#45bef6'
    property color infoText: '#7e8f9e'
    property color textBase: '#a1c1d2' // text
    property color textAttention: '#ff4f02'
    property color textTime: '#577889' // chat_time
    property color menuText: "#FFFFFF"
    property color mainMenuText: "#FFFFFF"
    property color chatInactiveText: "#577889"
    property color bannerInfoText: "#FFDD82"
    property color chatButtonText: "#FFFFFF"
    property color linkText: "#45bef6"
    property color fieldText: "#363636"

    // Базовый фон самого рута приложения
    //property color applicationBackground: "red" //"#002336"
    property color applicationBackground: "#002336" // bg
    property color contentBackground: "#031d2b" // bg_blue​
    property color contentBackgroundDark: "#00111A" // bg_darkblue
    property color contentBackgroundLight: "#4ca8db" // bg_lightblue
    property color popupBlockBackground: "#19384A" // названия нет, вероятно переименовать надо

    property color trayMenuHeaderBackground: "#0A1C26"
    property color trayMenuBorder: "#324E5E"

    // Конкретные цвета разных иконок
    property color messengerContactPresenceOnline: "#1ABC9C"
    property color messengerContactPresenceDnd: "#FFCC00"
    property color messengerContactPresenceOffline: "#CCCCCC"

    property color messengerRecentContactsUnreadIcon: "#189A19"

    property color detailedUserInfoGameCharsPlayingIcon: "#1abc9c"
    property color detailedUserInfoGameCharsTableFriendText: "#1abc9c"

    property color detailedUserInfoMainInfoLevelProgressLine: "#1abc9c"

    // Если будет использоваться еще, то вероятно переименовать:
    property color searchBorder: "#3498db"
    // End of GameNet 3.4

    //PRIVATE PART
    property variant styleList
    property string styleListOriginal

    property string currentStyle
    property alias settingsModel: data

    property int version: 1

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
