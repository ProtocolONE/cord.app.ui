// todo: можно использовать moment.js вместо него. Если появится необходимость в использовании форматирования дат ещё

var _monthNames = [];

function toLocaleFormat(self, format) {
    var k,
        f = {
            y : self.getYear() + 1900,
            m : _monthNames[self.getMonth()],
            d : self.getDate(),
            H : self.getHours(),
            M : self.getMinutes(),
            S : self.getSeconds()}

    for (k in f)
        format = format.replace('%' + k, f[k] < 10 ? "0" + f[k] : f[k]);
    return format;
}

function setMonthNames(names) {
    _monthNames = names;
}

