.pragma library
Qt.include("../../GameNet/Core/Strings.js")

/**
 * Заменяет ссылку вида gamenet://startservice/<serviceId> на гиперссылку
 * <a href="gamenet://startservice/<serviceId>">Имя игры</a>
 */
function replaceGameNetHyperlinks(message, makeHyperlink, getServiceItemFn, style) {
    return message.replace(/(gamenet:\/\/startservice\/(\d+)\/?)/ig, function(str, gnLink, serviceId) {
        var serviceItem = getServiceItemFn(serviceId)
            , serviceName;

        if (!serviceItem) {
            return str;
        }

        serviceName = serviceItem.name;

        if (makeHyperlink) {
            return "<a style='color:" +
                (style || "#FFFFFF") +
                "' href='" + gnLink + "'>" + serviceName + "</a>"
        }

        return serviceName;
    });
}

function replaceMessengerSubscriptionRequestLink(message, style) {
    return message.replace(/(gamenet:\/\/subscription\/(decline|accept))/ig, function(str, gnLink, request) {
        return "<a style='color:" +
                (style || "#FFFFFF") +
                "' href='" + gnLink + "'>" + (request == "accept" ? qsTr("MESSENGER_SUBSCRIPTION_REQUEST_ACCEPT") : qsTr("MESSENGER_SUBSCRIPTION_REQUEST_DECLINE")) + "</a>";
    });
}

function replaceHyperlinks(message, style) {
    return message.replace(/(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\x{00a1}\-\x{ffff}0-9]+-?)*[a-z\x{00a1}\-\x{ffff}0-9]+)(?:\.(?:[a-z\x{00a1}\-\x{ffff}0-9]+-?)*[a-z\x{00a1}\-\x{ffff}0-9]+)*(?:\.(?:[a-z\x{00a1}\-\x{ffff}]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?/ig, function(e) {
        return "<a style='color:" +
                (style || "#FFFFFF") +
                "' href='" + e + "'>" + e + "</a>";
    });
}

function replaceNewLines(message) {
    return message.replace(/(?:\r\n|\r|\n)/g, '<br/>');
}

function escapeHtml(s) {
    return s ? s.replace(
        /[&<>]/g,
        function (c, offset, str) {
            if (c === "&") {
                var substr = str.substring(offset, offset + 6);
                if (/&(amp|lt|gt);/.test(substr)) {
                    // already escaped, do not re-escape
                    return c;
                }
            }
            return "&" + {
                "&": "amp",
                "<": "lt",
                ">": "gt"
            }[c] + ";";
        }
    ) : "";
}

function replaceQuote(message, quoteAuthorColor) {

    var regExp = new RegExp(/\[quote([^\]]+)\]([\s\S]*?)\[\/quote\]/g);
    var match = regExp.exec(message);
    var result = message;

    while (match != null) {

        var text = match[2];
        var author = "";
        var date = "";

        var quoteAuthor = match[1].match(/author\s*?=\s*?\"([^"]+)/);
        if (quoteAuthor)
            author = quoteAuthor[1];
        var quoteDate = match[1].match(/date\s*?=\s*?\"([^"]+)/);
        if (quoteDate)
            date = quoteDate[1];

        var newMessage = "<blockquote><i>" + text + "</i><br/><b>" +
                author + "</b><span> </span><span style='color:" + quoteAuthorColor + "'>" + date + "</span></blockquote>";

        result = result.replace(match[0], newMessage);
        match = regExp.exec(message);
    }

    return result;
}

function prepareText(message, options) {
    var text = escapeHtml(message);
    text = options.smileResolver(text);
    text = replaceQuote(text, options.quoteAuthorColor);
    text = replaceHyperlinks(text, options.hyperLinkStyle);
    text = replaceGameNetHyperlinks(text, true, options.serviceResolver, options.hyperLinkStyle);
    text = replaceMessengerSubscriptionRequestLink(text, options.hyperLinkStyle);
    text = replaceNewLines(text);
    return text;
}
