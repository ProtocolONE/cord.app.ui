/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
.pragma library

var _quoteCache = {};

function clearQuoteCache() {
    _quoteCache = [];
}


function MessageItem(isQoute, source) {
    this.isQuote = isQoute;
    this.source = source;
}

function QuoteProcessing(message, render, onFinish, options) {
    this.render = render;
    this.onFinish = onFinish;
    this.options = options;
    this.MessageItems = [];
    this.index = -1;
    this.parse(message);
    if (this.MessageItems.length > 0) {
        this.grabNextImage();
    }
}

QuoteProcessing.prototype.parse = function(message) {

    var startIndex = 0;
    var finishIndex = 0;

    var regExp = new RegExp(/\[quote([^\]]+)\]([\s\S]*?)\[\/quote\]/g);
    var match = regExp.exec(message);

    while (match != null) {

        finishIndex = match.index;
        this.MessageItems.push({ isQuote: false, source: message.substring(startIndex, finishIndex) });

        var text = match[2];
        var author = "";
        var date = "";

        var quoteAuthor = match[1].match(/author\s*?=\s*?\"([^"]+)/);
        if (quoteAuthor) {
            author = quoteAuthor[1];
        }
        var quoteDate = match[1].match(/date\s*?=\s*?\"([^"]+)/);
        if (quoteDate) {
            date = quoteDate[1];
        }

        var quote = makeQuote(text, author, date);
        this.MessageItems.push({ isQuote: true, source: quote });
        startIndex = finishIndex + match[0].length;

        match = regExp.exec(message);
    }

    if (message.length > startIndex)
        this.MessageItems.push({ isQuote: false, source: message.substring(startIndex) });
}

QuoteProcessing.prototype.currentItem = function() {
    return this.MessageItems[this.index];
}

QuoteProcessing.prototype.nextItem = function() {
    if (this.index >= this.MessageItems.length)
        return null;
    return this.MessageItems[++this.index];
}

QuoteProcessing.prototype.grabNextImage = function() {

    var item = this.nextItem();
    if (!item) {
        this.grabFinished();
        return;
    }

    if (!item.isQuote) {
        this.grabNextImage();
        return;
    }

    this.render.text = "<p></p>" + quoteToHtml(item.source, this.options.quoteAuthorColor, this.options.installPath);
    var self = this;

    this.render.grabToImage(function(result) {

        var details = getQuoteDetails(item.source);
        if (details) {

            _quoteCache[result.url] = {
                image: result,
                author: details.author,
                date: details.date,
                text: details.text
            }

            item.source = makeQuoteImage(result.url);
        }
        self.grabNextImage();
    });
}

QuoteProcessing.prototype.grabFinished = function() {

    var inputText = "";

    this.MessageItems.forEach(function(item) {
        inputText += item.source;
    });

    this.onFinish(inputText);
}

function makeQuote(text, author, date) {
    return "[quote author=\"" + author + "\" date=\"" + date + "\"]" + text + "[/quote]";
}

function makeQuoteImage(url) {
    return "<img src='" + url + "'></img>";
}

function makeQuoteHtml(text, author, date, quoteAuthorColor, installPath) {
    return "<table><tr><td><img src='" + installPath + "/Assets/Images/Application/Widgets/Messenger/quote.ico'></td><td>" +
        "<i>" + text + "</i><span> </span><img src='" + installPath + "/Assets/Images/Application/Widgets/Messenger/quote.ico'><br/><b>" +
        author + "</b><span> </span><span style='color:" + quoteAuthorColor + "'>" + Qt.formatDateTime(new Date(+date), "d MMMM yyyy, hh:mm") +
        "</span></td></tr><tr><td> </td><td> </td></tr></table>";
}

function quoteToHtml(message, quoteAuthorColor, installPath) {

    var regExp = new RegExp(/\[quote([^\]]+)\]([\s\S]*?)\[\/quote\]/g);
    var match = regExp.exec(message);
    var result = message;

    while (match != null) {

        var text = match[2];
        var author = "";
        var date = "";

        var quoteAuthor = match[1].match(/author\s*?=\s*?\"([^"]+)/);
        if (quoteAuthor) {
            author = quoteAuthor[1];
        }
        var quoteDate = match[1].match(/date\s*?=\s*?\"([^"]+)/);
        if (quoteDate) {
            date = quoteDate[1];
        }

        var newMessage = makeQuoteHtml(text, author, date, quoteAuthorColor, installPath);
        result = result.replace(match[0], newMessage);
        match = regExp.exec(message);
    }

    return result;
}

function removeQuote(message) {

    var regExp = new RegExp(/\[quote([^\]]+)\]([\s\S]*?)\[\/quote\]/g);
    var match = regExp.exec(message);
    var result = message;

    while (match != null) {
        var text = match[2];
        result = result.replace(match[0], text);
        match = regExp.exec(message);
    }
    return result;
}

function htmlToQuote(message) {

    var regExp = new RegExp(/<img\s+src\s*=\s*"(.+?)"(["'][^"']+["']|[^>]+)>/gi);
    var match = regExp.exec(message);
    var result = message;

    while (match != null) {

        var url = match[1];
        var quote = _quoteCache[url];
        if (!quote)
            continue;

        var newMessage = makeQuote(quote.text, quote.author, quote.date);

        result = result.replace(match[0], newMessage);
        match = regExp.exec(message);
    }

    return result;
}

function getQuoteDetails(message) {

    var regExp = new RegExp(/\[quote([^\]]+)\]([\s\S]*?)\[\/quote\]/);
    var match = regExp.exec(message);

    if (match != null) {

        var text = match[2];
        var author = "";
        var date = "";

        var quoteAuthor = match[1].match(/author\s*?=\s*?\"([^"]+)/);
        if (quoteAuthor) {
            author = quoteAuthor[1];
        }
        var quoteDate = match[1].match(/date\s*?=\s*?\"([^"]+)/);
        if (quoteDate) {
            date = quoteDate[1];
        }

        var result = {
            author: author,
            date: date,
            text: text
        };
        return result;
    }

    return null;
}
