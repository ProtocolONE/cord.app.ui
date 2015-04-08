var _jabber = null,
    _signalBus;

function init(jabber, signalBus) {
    if (_jabber !== null) {
        throw new Error('[Events] Already initialized');
    }

    console.log('[Events] Init plugin');

    _jabber = jabber;
    _signalBus = signalBus;

    _jabber.eventReceived.connect(function(event) {
        switch (event.name) {
        case 'profileUpdated':
            _signalBus.profileUpdated();
            break;
        default:
            console.log('[Events] Unhandled event received ' + event.name);
        }
    });
}
