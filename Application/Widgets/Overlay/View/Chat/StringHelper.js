/**
 * Заменяет ссылку вида gamenet://startservice/<serviceId> на гиперссылку
 * <a href="gamenet://startservice/<serviceId>">Имя игры</a>
 */
function replaceGameNetHyperlinks(message, makeHyperlink, getServiceItemFn) {
    return message.replace(/(gamenet:\/\/startservice\/(\d+))/ig, function(str, gnLink, serviceId) {
        var serviceItem = getServiceItemFn(serviceId)
            , serviceName;

        serviceName = serviceItem ? serviceItem.name : gnLink;

        if (makeHyperlink) {
            return "<a style='color:" +
                Styles.style.messengerChatDialogHyperlinkColor +
                "' href='" + gnLink + "'>" + serviceName + "</a>";
        }
        return serviceName;
    });
}
