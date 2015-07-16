import QtQuick 2.4
import Tulip 1.0

QtObject {
    function getDb(jid) {
        return LocalStorage.openDatabaseSync('/Account/' + jid, 'main', 1, 'Main', 0);
    }
}
