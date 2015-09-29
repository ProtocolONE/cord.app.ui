/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
var MessageState = function() {};
MessageState.None = 0;       ///< The message does not contain any chat state information.
MessageState.Active = 1;     ///< User is actively participating in the chat session.
MessageState.Inactive = 2;   ///< User has not been actively participating in the chat session.
MessageState.Gone = 3;       ///< User has effectively ended their participation in the chat session.
MessageState.Composing = 4;  ///< User is composing a message.
MessageState.Paused = 5;     ///< User had been composing but now has stopped.

var MessageType = function() {};
MessageType.Error = 0;
MessageType.Normal = 1;
MessageType.Chat = 2;
MessageType.GroupChat = 3;
MessageType.Headline = 4;

function Message(model, index) {
    var _item = model.get(index),
        _model = model,
        _index = index;

    this.__defineGetter__("index", function() {
        return _index;
    });

    this.__defineGetter__("jid", function() {
        return _item.jid;
    });

    this.__defineSetter__("jid", function(val) {
        _model.setProperty(_index, 'jid', val);
    });

    this.__defineGetter__("isStatusMessage", function() {
        return _item.isStatusMessage;
    });

    this.__defineSetter__("isStatusMessage", function(val) {
        _model.setProperty(_index, 'isStatusMessage', val);
    });

    this.__defineGetter__("text", function() {
        return _item.text;
    });

    this.__defineSetter__("text", function(val) {
        _model.setProperty(_index, 'text', val);
    });

    this.__defineGetter__("date", function() {
        return _item.date;
    });

    this.__defineSetter__("date", function(val) {
        _model.setProperty(_index, 'date', val);
    });

    this.__defineGetter__("day", function() {
        return _item.day;
    });

    this.__defineSetter__("day", function(val) {
        _model.setProperty(_index, 'day', val);
    });

    this.finishComposing = function(body, date, id) {
        this.isStatusMessage = false;
        this.date = date || Date.now();
        this.text = body;
        _model.setProperty(_index, 'id', id || "_");
    }
}

function startOfDay(value) {
    var tmp = new Date(value || Date.now());
    tmp.setHours(0);
    tmp.setMinutes(0);
    tmp.setSeconds(0);
    tmp.setMilliseconds(0);

    return +tmp;
}

function createRawMessage(from, isStatus, body, date, id, type) {
    var result = {
        id: String(id || "_"),
        jid: from,
        text: body || "",
        date: +(date || Date.now()),
        isStatusMessage: isStatus,
        day: startOfDay(date),
        type: type || "text"
    };

    return result;
}

function stateMessage(state) {
    var result = "";
    if (state === MessageState.Composing) {
        result = qsTr("MESSAGE_STATE_COMPOSING");
    }

    if (state === MessageState.Paused) {
        result = qsTr("MESSAGE_STATE_PAUSED");
    }

    if (state === MessageState.Inactive) {
        result = qsTr("MESSAGE_STATE_INACTIVE");
    }

    return result;
}

function canShowState(state) {
    var result = (state === MessageState.Composing)
        || (state === MessageState.Paused)
        || (state === MessageState.Inactive);

    return result;
}
