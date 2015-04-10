/**
  * Вспомогательный класс для работы с версиями таблиц в SQLLite.
  *
  * <example>
  * var meta = new MetaStorage(db, 'Accounts');
  * if (meta.version === 0)  {
  *    ... create tables and so on
  * }
  *
  * if (meta.version === 1)  {
  *    ... migrate from version 0 to 1
  * }
  * <example>
  *
  * @param LocalStorage db
  * @param string name
  *
  * @throws Error В случае любых ошибок во время записи версии.
  */
var MetaStorage = function(db, name) {
    db.executeSql("CREATE TABLE IF NOT EXISTS DbMeta(`name` TEXT, `version` INTEGER)");
    db.executeSql("CREATE UNIQUE INDEX IDX_DbMeta_Name ON DbMeta(`name`)");

    this.__defineGetter__("version", function() {
        var res = db.executeSql("SELECT `version` FROM DbMeta WHERE `name` = '" + name + "'");
        if (res.rows.length === 0) {
            return 0;
        }

        return res.rows[0].version || 0;
    });

    this.__defineSetter__("version", function(value) {
        var res = db.executeSql(
            "INSERT OR REPLACE INTO DbMeta (`name`, `version`) VALUES('" + name + "', " + value + ")"
        );

        checkDataBaseResult(res);
    });

    this.migrate = function(from, to, sql) {
        if (this.version === from) {
            sql.forEach(function(e) {
                db.executeSql(e);
            });
            this.version = to;
        }
    }
}

function checkDataBaseResult(res) {
    if (res.error) {
        throw new Error(res.errorText + " - " + res.errorNumber);
    }
}
