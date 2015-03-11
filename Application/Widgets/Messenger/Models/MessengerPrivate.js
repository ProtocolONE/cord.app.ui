/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
.pragma library

// INFO see Messenger.js
var USER_INFO_FULL = 1;
var USER_INFO_JID = 2;

var DISCONNECTED     = 0;
var CONNECTING       = 1;
var ROSTER_RECEIVING = 2;
var ROSTER_RECEIVED  = 3;
var RECONNECTING     = 4;

var lastTalkDateMap = {}
    , unreadMessageCountMap;
