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

QtObject {
    //BASE
    property real darkerFactor: 1.2
    property real lighterFactor: 1.2
    property color base: "#092135"

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
    property color gameMeneSelectedIndicator: "#FFCA02"

    //MESSENGER
    property color messengerBottomBarBackground: "#FAFAFA"
    property color messengerBottomBarButtonNormal: "#1ABC9C"
    property color messengerBottomBarButtonHover: "#019074"
    property color messengerBottomBarButtonNotificationBackground: "#374E78"
    property color messengerBottomBarButtonNotificationText: "#FFFFFF"

    //MESSENGER
    property color messengerSearchBackground: "#FAFAFA"
    property color messengerSearchButtonNormal: "#1ABC9C"
    property color messengerSearchButtonHover: "#019074"
    property color messengerSearchInputNormal: "#e5e5e5"
    property color messengerSearchInputActive: "#3498db"
    property color messengerSearchInputHover: "#3498db"
    property color messengerSearchInputPlaceholder: "#a4b0ba"
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
    property color messengerContactNewMessageStatusText: "#FFCC00"
    property color messengerMessageInputBackground: "#FFFFFF"
    property color messengerMessageInputBorder: "#FFFFFF"
    property color messengerMessageInputTextBackground: "#FFFFFF"
    property color messengerMessageInputText: "#252932"
    property color messengerMessageInputSendButtonNormal: "#1ABC9C"
    property color messengerMessageInputSendButtonHover: "#019074"
    property color messengerMessageInputSendButtonText: "#FAFAFA"
    property color messengerMessageInputSendHotkeyText: "#8596A6"
}