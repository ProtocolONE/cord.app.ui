function startOfDay(value) {
    var tmp = new Date(value || Date.now());
    tmp.setHours(0);
    tmp.setMinutes(0);
    tmp.setSeconds(0);
    tmp.setMilliseconds(0);

    return +tmp;
}

function subtractTime(date, num, name) {
    var tmp = new Date(date),
        map = {
            'week': 604800000,
            'day': 86400000,
            'hour': 3600000,
            'minute': 60000,
            'seconds': 1000,
        };

    if (name == 'month') {
        tmp.setMonth(tmp.getMonth() - num);
    } else {
        tmp.setTime(tmp.getTime() - map[name] * num);
    }

    return +tmp;
}
