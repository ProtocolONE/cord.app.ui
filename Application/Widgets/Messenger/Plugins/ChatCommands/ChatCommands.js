function init(jabber) {
    function showHelp() {
        // UNDONE надо бы как-то добавить в соответсвующий разговор
        // новое сообщение от псевдопользователя system
        // и в отображении добавить соответсвующий внешний вид

        console.log('Set topic: /topic <subject>');
        console.log('Destroy room: /destroy');
        console.log('Invite user to room: /invite <jid> <reason>');
        console.log('Leave room: /leave');
        console.log('Kick user from room: /kick <jid> <reason>');
        console.log('Ban user: /ban <jid> <reason>');
    }

    function onCommand(jid, body) {
        var args = body.split(' ');
        switch(args[0]) {
          case '/topic':
              jabber.setRoomTopic(jid, args[1]);
              break;

          case '/destroy':
              jabber.mucManager.destroyRoom(jid, args[1] || "");
              break;

          case '/invite':
              jabber.invite(jid, args[1], args[2] || "")
              break;

          case '/queryrooms':
              jabber.discoveryManager.requestItems(jabber.conferenceUrl());
              break

          case '/queryitems':
              jabber.discoveryManager.requestItems(jid);
              break

          case '/queryinfo':
              jabber.discoveryManager.requestInfo(jid);
              break

          case '/config':
              jabber.mucManager.requestConfiguration(jid);
              break

          case '/permissions':
              jabber.mucManager.requestPermissions(jid);
              break

          case '/leave':
              jabber.leaveGroup(jid);
              break;

          case '/kick':
              jabber.mucManager.kick(jid, args[1] || "", args[2] || "");
              break;

          case '/ban':
              jabber.mucManager.ban(jid, args[1] || "", args[2] || "");
              break;

          default:
            showHelp();
            break;
        }
    }

    jabber.chatCommand.connect(onCommand);
}
