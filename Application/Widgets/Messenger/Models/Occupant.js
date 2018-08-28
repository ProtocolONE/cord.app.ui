.pragma library


function createRawOccupant(jid) {
    return {
        jid: jid,
        presenceState: "",
        affiliation: "",
    };
}
