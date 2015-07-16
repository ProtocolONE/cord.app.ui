/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4

Rectangle {
    id: control

    property variant dictionary
    property string filter
    property int max: 5
    property variant proxyModel: ListModel {}

    onDictionaryChanged: d.updateDictionary(dictionary);
    onFilterChanged: d.refreshFilters(filter);

    function filterFunction(pattern, testedValue) {
        if (pattern === "" || testedValue === "") {
            return false;
        }
        if (pattern.length > testedValue.length) {
            return false;
        }
        if (testedValue.substring(0, pattern.length) === pattern) {
            return true;
        }
    }

    function sortFunction(a, b) {
        if (a.value > b.value) {
            return 1;
        }

        return -1;
    }

    QtObject {
        id: d

        function updateDictionary(newDictionary) {
            var i = 0;
            var sortdata = [];

            suggestionsModel.clear();

            if (newDictionary instanceof Array) {
                newDictionary.forEach(function(elem) {
                    if (!elem) {
                        return;
                    }

                    sortdata.push({value: elem});
                });
            } else {
                Object.keys(newDictionary).forEach(function(elem) {
                    if (!elem) {
                        return;
                    }

                    sortdata.push({value: elem, data: newDictionary[elem]});
                });
            }

            sortdata.sort(sortFunction);

            for (i = 0; i < sortdata.length; ++i) {
                suggestionsModel.append({value: sortdata[i].value, active: false});
            }
        }

        function refreshFilters(newFilter) {
            var i = 0, item, filteredItems = 0;

            proxyModel.clear();

            for (i = 0; i < suggestionsModel.count; ++i) {
                item = suggestionsModel.get(i);

                item.active = false;

                if (filterFunction(newFilter, item.value) && filteredItems < control.max) {
                    filteredItems++;
                    proxyModel.append({value: item.value, active: false});
                }
            }
        }
    }

    ListModel {
        id: suggestionsModel
    }
}
