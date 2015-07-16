import QtQuick 2.4
import Tulip 1.0
import GameNet.Core 1.0
import Application.Core.Settings 1.0
import "./SmilesPrivate.js" as Smiles

Item {

    function saveShortName(smileShortName) {
        if (!Smiles.mostUsedSmilesMap.hasOwnProperty(smileShortName)) {
            Smiles.mostUsedSmilesMap[smileShortName] = 0;
            Smiles.recentSmilesList.unshift(smileShortName);
        } else {
            var index = Smiles.recentSmilesList.indexOf(smileShortName);

            if (index > -1) {
                Smiles.recentSmilesList.splice(index, 1);
            }

            Smiles.recentSmilesList.unshift(smileShortName);
        }

        Smiles.mostUsedSmilesMap[smileShortName]++;
    }

    function processSmiles(jid, body) {
        var found,
            smileShortName,
            index,
            sortedMostUsedSmiles = [],
            mappedUnicode,
            regExp = /:([^:]+):/gi;

        while (found = regExp.exec(body)) {
            if (!EmojiOne.ns.emojioneList.hasOwnProperty(found[0])) {
                continue;
            }

            smileShortName = found[1];
            saveShortName(smileShortName);
        }

        regExp = new RegExp(EmojiOne.ns.asciiRegexp, "gi");
        mappedUnicode = EmojiOne.ns.mapShortToUnicode();

        while (found = regExp.exec(body)) {
            if (!EmojiOne.ns.asciiList.hasOwnProperty(found[0])) {
                continue;
            }

            smileShortName = EmojiOne.ns.asciiList[found[0]].toUpperCase();

            if (!mappedUnicode.hasOwnProperty(smileShortName)) {
                continue;
            }

            smileShortName = mappedUnicode[smileShortName];

            saveShortName(smileShortName);
        }

        for (var key in Smiles.mostUsedSmilesMap) {
            sortedMostUsedSmiles.push(key);
        }

        Smiles.sortedRecentSmiles = sortedMostUsedSmiles.sort(function(a,b){
            return Smiles.mostUsedSmilesMap[b] - Smiles.mostUsedSmilesMap[a];
        });

        AppSettings.setValue('qml/messenger/mostUsedSmilesMap/', jid, JSON.stringify(Smiles.mostUsedSmilesMap));
        AppSettings.setValue('qml/messenger/recentSmilesList/', jid, JSON.stringify(Smiles.recentSmilesList));
        AppSettings.setValue('qml/messenger/sortedRecentSmiles/', jid, JSON.stringify(Smiles.sortedRecentSmiles));
    }

    function loadRecentSmiles(jid) {
        try {
            Smiles.mostUsedSmilesMap = JSON.parse(AppSettings.value('qml/messenger/mostUsedSmilesMap/',
                                                                             jid,
                                                                             "{}"));
        } catch (e) {
            Smiles.mostUsedSmilesMap = {};
        }

        try {
            Smiles.sortedRecentSmiles = JSON.parse(AppSettings.value('qml/messenger/sortedRecentSmiles/',
                                                                             jid,
                                                                             "[]"));
        } catch (e) {
            Smiles.sortedRecentSmiles = [];
        }

        try {
            Smiles.recentSmilesList = JSON.parse(AppSettings.value('qml/messenger/recentSmilesList/',
                                                                             jid,
                                                                             "[]"));
        } catch (e) {
            Smiles.recentSmilesList = [];
        }
    }

    function mostUsedSmilesMap() {
        return Smiles.mostUsedSmilesMap;
    }

    function recentSmilesList() {
        return Smiles.recentSmilesList;
    }

    function sortedRecentSmiles() {
        return Smiles.sortedRecentSmiles;
    }
}
