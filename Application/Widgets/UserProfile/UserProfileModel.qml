import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0
import Application.Core 1.0

WidgetModel {
    id: root

    property bool isPremium: User.isPremium()
    property bool isLoginConfirmed: User.isLoginConfirmed()
    property int premiumDuration: User.getPremiumDuration()
    property int balance: User.getBalance()

    property string nickname: User.getNickname()
    property string level: User.getLevel()
    property string avatarMedium: User.getAvatarMedium()

    property bool isPromoActionActive: User.isPromoActionActive()
}
