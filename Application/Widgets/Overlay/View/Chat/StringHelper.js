.pragma library
Qt.include("../../../../../GameNet/Core/Strings.js")

/**
 * Заменяет ссылку вида gamenet://startservice/<serviceId> на гиперссылку
 * <a href="gamenet://startservice/<serviceId>">Имя игры</a>
 */
function replaceGameNetHyperlinks(message, makeHyperlink, getServiceItemFn, style) {
    return message.replace(/(gamenet:\/\/startservice\/(\d+))/ig, function(str, gnLink, serviceId) {
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
                style +
                "' href='" + e + "'>" + e + "</a>";
    });
}

function replaceNewLines(message) {
    return message.replace(/(?:\r\n|\r|\n)/g, '<br/>');
}

function prepareText(message, options) {
    var text = stripTags(message);
    text = options.smileResolver(text);
    text = replaceHyperlinks(text, options.hyperLinkStyle);
    text = replaceGameNetHyperlinks(text, true, options.serviceResolver, options.hyperLinkStyle);
    text = replaceMessengerSubscriptionRequestLink(text, options.hyperLinkStyle);
    text = replaceNewLines(text);
    return text;
}


