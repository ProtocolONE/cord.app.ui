/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import qGNA.Library 1.0
import Tulip 1.0

import "../Elements" as Elements
import "../Delegates" as Delegates
import ".."

Rectangle {

 //HACK
//    Item {
//        id: mainWindow
//        property string emptyString: ""
//        signal torrentListenPortChanged();
//    }

//    Item {
//        id: gameSettingsModel

//        property string installPath: "value"
//        property string downloadPath: "value"
//        property bool hasDownloadPath: true
//        function switchGame(serviceId) {}
//    }

//    Item {
//        id: settingsViewModel
//        property string downloadSpeed: "50"
//        property string uploadSpeed: "50"
//        property string numConnections: "50"
//        property string incomingPort: "50"
//        function setNumConnections(q){}
//        function setIncomingPort(q){}
//    }
//    property string installPath: "../"

    width: 800
    height: 400

    id: settingsPageId
    color: "#00000000"

    state: "GeneralPage"

    signal finishAnimation();
    property int globalAnimationSpeed: 200

    states: [
        State {
            name: "GeneralPage"
            PropertyChanges { target: pageLoader; source: "SettingsGeneralPage.qml" }
        },
        State {
            name: "DownloadPage"
            PropertyChanges { target: pageLoader; source: "SettingsDownloadPage.qml" }
        }
    ]

    // undone: перенести куда-то куда коля хотел
    Connections {
        target: mainWindow
        onTorrentListenPortChanged:{
            settingsViewModel.setIncomingPort(port);
        }
    }

    function navigationTextClicked(index){
        switch (index){
        case 0: { settingsPageId.state = "GeneralPage"; break }
        case 1: { settingsPageId.state = "DownloadPage"; break }
        }

    }

    Item {
        anchors { left: parent.left; top: parent.top; leftMargin: 38; topMargin: 5 }

        Text {
            id: mainClickText

            text: qsTr("TITLE_SETTINGS_SCREEN")
            style: Text.Normal
            anchors.fill: parent
            font { family: "Segoe UI Light"; pixelSize: 46 }
            smooth: true
            color: "#FFFFFF"

            SequentialAnimation{
                running: true;

                ParallelAnimation{
                    NumberAnimation{ target: mainClickText; easing.type: Easing.OutQuad; property: "anchors.topMargin"; from: 40; to: 15; duration: 250 }
                    NumberAnimation{ target: mainClickText; easing.type: Easing.OutQuad; property: "opacity"; from: 0; to: 1; duration: 250 }
                }
            }
        }
    }

    Item {
        id: menuBar
        anchors.left: parent.left
        anchors.leftMargin: 31
        anchors.top: parent.top
        anchors.topMargin: 110
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        width: 208

        Flickable {
            id: menuBarContent

            clip: true
            anchors.fill: parent
            contentHeight: listViewId.height + gameSettingsMenuBlock.height + menuBarContentColumn.spacing

            Column {
                id: menuBarContentColumn

                anchors.fill: parent
                spacing: 10

                ListView {
                    id: listViewId

                    width: 228
                    height: 70
                    currentIndex: 0
                    interactive: false
                    clip: true
                    spacing: 3
                    focus: true
                    delegate: Delegates.SettingsMenuDelegate {
                        buttonText: qsTr(itemText)

                        onTextClicked: {
                            generalSettings.visible = true;
                            gameSettings.visible = false;
                            if (listViewId.currentIndex != index) {
                                if (listViewId.currentIndex != -1) {
                                    listViewId.currentItem.state = "Normal";
                                }

                                navigationTextClicked(index);
                                listViewId.currentIndex = index;
                            }

                            if (gameSettingsListView.currentIndex !== -1) {
                                gameSettingsListView.currentItem.state = "Normal";
                                gameSettingsListView.currentIndex = -1;
                            }

                        }
                    }

                    model: ListModel{
                        ListElement{
                            itemText: QT_TR_NOOP("MENU_ITEM_GENERAL");
                            itemState: "Active";
                            animationPause: 0
                        }
                        ListElement{
                            itemText: QT_TR_NOOP("MENU_ITEM_DOWNLOAD");
                            itemState: "Normal"
                            animationPause: 100
                        }
                    }
                }

                Item {
                    id: gameSettingsMenuBlock

                    width: 228
                    height: crossBar.height + gameSettingsRowCaption.height + gameSettingsListView.height + 20

                    Column {
                        spacing: 10
                        anchors.fill: parent

                        Rectangle {
                            id: crossBar

                            height: 1
                            width: 181
                            anchors.left: parent.left
                            color: "#404040"
                        }

                        Row {
                            id: gameSettingsRowCaption

                            Item {
                                height: 1
                                width: 8
                            }

                            Elements.TextH1 {
                                text: qsTr("MENU_GAMES_SECTION_TITLE")
                                color: "#FE9901"
                            }
                        }

                        ListView {
                            id: gameSettingsListView

                            width: 228
                            height: (32 + gameSettingsListView.spacing) * gameSettingsListView.count - gameSettingsListView.spacing
                            currentIndex: -1
                            interactive: false
                            clip: true
                            spacing: 3

                            delegate: Delegates.SettingsMenuDelegate {
                                property string serviceIdAlias: serviceId
                                buttonText: qsTr(itemText)
                                onTextClicked: {
                                    generalSettings.visible = false;
                                    gameSettings.visible = true;
                                    if (gameSettingsListView.currentIndex != index){
                                        if (gameSettingsListView.currentIndex != -1) {
                                            gameSettingsListView.currentItem.state = "Normal";
                                        }

                                        gameSettingsListView.currentIndex = index;
                                        gameSettings.hasOverlay = model.hasOverlay;
                                        gameSettings.serviceId = model.serviceId;
                                        overlayEnabledCheckBox.resetValue();
                                        gameSettingsModel.switchGame(serviceId);
                                    }

                                    if (listViewId.currentIndex !== -1) {
                                        listViewId.currentItem.state = "Normal";
                                        listViewId.currentIndex = -1;
                                    }
                                }
                            }


                            model: ListModel{
                                ListElement{
                                    itemText: QT_TR_NOOP("MENU_ITEM_AIKA");
                                    serviceId: "300002010000000000"
                                    itemState: "Normal";
                                    animationPause: 0
                                    hasOverlay: false
                                }
                                ListElement{
                                    itemText: QT_TR_NOOP("MENU_ITEM_WARINC");
                                    serviceId: "300005010000000000"
                                    itemState: "Normal"
                                    animationPause: 100
                                    hasOverlay: false
                                }
                                ListElement{
                                    itemText: QT_TR_NOOP("MENU_ITEM_BS");
                                    serviceId: "300003010000000000"
                                    itemState: "Normal"
                                    animationPause: 150
                                    hasOverlay: true
                                }
                                ListElement{
                                    itemText: QT_TR_NOOP("MENU_ITEM_COMBATARMS");
                                    serviceId: "300009010000000000"
                                    itemState: "Normal"
                                    animationPause: 100
                                    hasOverlay: false
                                }
                                ListElement{
                                    itemText: QT_TR_NOOP("MENU_ITEM_MW2");
                                    serviceId: "300006010000000000"
                                    itemState: "Normal"
                                    animationPause: 150
                                    hasOverlay: false
                                }
                            }

                        }
                    }
                }
            }
        }

        Elements.ScrollBar {
            id: settingListScrollBar

            height: menuBar.height
            anchors { left : menuBar.right; top: menuBar.top; leftMargin: 5 }
            visible: gameSettingsMenuBlock.visible && gameSettingsListView.count > 2
            flickable: menuBarContent
        }
    }

    Item {
        id: generalSettings

        anchors.fill: parent
        visible: true

        Elements.Button2 {
            anchors { left: parent.left; bottom: parent.bottom; leftMargin: 300; bottomMargin: 49 }
            width: 70
            onButtonClicked: qGNA_main.state = qGNA_main.lastState;
        }

        Elements.Button3{
            anchors { left: parent.left; bottom: parent.bottom; leftMargin: 380; bottomMargin: 49 }
            buttonText: qsTr("BUTTON_DEFAULT_SETTINGS")

            onButtonClicked: {
                globalAnimationSpeed = 1;
                settingsViewModel.setDefaultSettings();
                mainWindow.selectLanguage("ru");
                var pageSource = pageLoader.source;
                pageLoader.source = "";
                pageLoader.source = pageSource;
            }
        }

        Item {
            id: pageLoaderItem

            anchors { fill: parent; leftMargin: 301; topMargin: 116; bottomMargin: 100 }

            Loader { id: pageLoader; focus: true; }
            NumberAnimation {
                running: pageLoader.status == Loader.Ready;
                target: pageLoaderItem;
                easing.type: Easing.OutQuad;
                property: "opacity";
                from: 0;
                to: 1;
                duration: 200
            }
        }
    }


    Item {
        id: gameSettings

        property string serviceId
        property bool hasOverlay: false

        anchors.fill: parent
        visible: false

        Item {
            anchors { fill: parent; leftMargin: 301; topMargin: 116; bottomMargin: 100 }

            Column {
                spacing: 10

                Elements.TextH3 {
                    text: qsTr("SUBTITLE_FOLDERS_GAME_SETTING")
                    color: "#E68A03"
                }

                Column {
                    spacing: 5

                    Elements.TextH3 {
                        text: qsTr("LABEL_INSTALL_PATH_INPUT")
                    }

                    Row {
                        spacing: 10

                        Elements.FileInput {
                            width: 317
                            textElement.readOnly: true
                            textElement.text: gameSettingsModel.installPath
                        }

                        Elements.Button2 {
                            buttonText: qsTr("BUTTON_SET_PATH")
                            onButtonClicked: gameSettingsModel.browseInstallPath()
                        }
                    }
                }

                Column {
                    visible: gameSettingsModel.hasDownloadPath
                    spacing: 5

                    Elements.TextH3 {
                        text: qsTr("LABEL_DISTR_PATH_INPUT")
                    }

                    Row {
                        spacing: 10

                        Elements.FileInput {
                            width: 317
                            textElement.readOnly: true
                            textElement.text: gameSettingsModel.downloadPath
                        }

                        Elements.Button2 {
                            buttonText: qsTr("BUTTON_SET_PATH")
                            onButtonClicked: gameSettingsModel.browseDownloadPath()
                        }
                    }
                }

                Elements.CheckBox {
                    id: overlayEnabledCheckBox

                    function resetValue() {
                        if (!gameSettings.serviceId || !gameSettings.hasOverlay) {
                            return;
                        }

                        var overlayEnabled = Settings.value(
                                    'gameExecutor/serviceInfo/' + gameSettings.serviceId + "/",
                                    "overlayEnabled",
                                    1) != 0;

                        overlayEnabledCheckBox.setValue(!!overlayEnabled);
                    }

                    function save(overlayEnabled) {
                        Settings.setValue('gameExecutor/serviceInfo/' + gameSettings.serviceId + "/",
                                          'overlayEnabled',
                                          overlayEnabled ? 1 : 0);
                    }

                    visible: gameSettings.hasOverlay
                    buttonText: qsTr("ENABLE_OVERLAY_TITLE")
                    onChecked: overlayEnabledCheckBox.save(true);
                    onUnchecked: overlayEnabledCheckBox.save(false);
                }

                Row {
                    spacing: 10

                    Elements.Button2 {
                        buttonText: qsTr("BUTTON_CREATE_DESKTOP_SHORTCUT")
                        onClicked: gameSettingsModel.createShortcutOnDesktop()
                    }

                    Elements.Button2 {
                        buttonText: qsTr("BUTTON_CREATE_START_MENU_SHORTCUT")
                        onClicked: gameSettingsModel.createShortcutInMainMenu()
                    }
                }
            }
        }

        Elements.Button2 {
            anchors { left: parent.left; bottom: parent.bottom; leftMargin: 300; bottomMargin: 49}
            width: 70

            onButtonClicked: {
                gameSettingsModel.submitSettings();
                qGNA_main.state = qGNA_main.lastState;
            }
        }

        Elements.Button3 {
            anchors { left: parent.left; bottom: parent.bottom; leftMargin: 430; bottomMargin: 49 }
            buttonText: qsTr("BUTTON_RESTORE_GAME_CLIENT")
            onButtonClicked: {
                if (gameSettingsListView.currentItem) {
                    qGNA_main.selectService(gameSettingsListView.currentItem.serviceIdAlias);
                }

                gameSettingsModel.restoreClient();
            }
        }
    }
}
