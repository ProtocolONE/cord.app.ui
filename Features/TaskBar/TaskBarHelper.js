.pragma library

var activeServices = {},
    overallStatus = "",
    overallProgress = 0;

function updateProgress(gameItem) {
    var serviceId = gameItem.serviceId;
    var count = 0
    var pausedCount = 0;
    var isPause = false;
    var isError = false;
    var totalProgress = 0
    var curProgress = 0;

    if (!gameItem)
        return;

    if (gameItem.gameType != "standalone")
        return;

    if (!activeServices[serviceId] && !gameItem.allreadyDownloaded) {
        activeServices[serviceId] = gameItem;
    } else {
        if (gameItem.status === 'DownloadFinished' && gameItem.allreadyDownloaded)
            delete activeServices[serviceId];
    }

    for (var curServiceId in activeServices) {
        var curGame = activeServices[curServiceId];
        curProgress += (curGame.progress >= 0) ? curGame.progress : 0;
        count++;
        if (curGame.status === "Paused") {
            pausedCount++;
        }
        if (curGame.status === "Error") {
            isError = true;
        }
    }

    totalProgress = count * 100;

    if (isError) {
        overallStatus = "Error";
    } else if (pausedCount == count) {
        overallStatus = "Paused";
    } else {
        overallStatus = "Normal";
    }
    overallProgress = curProgress/totalProgress * 100;
}

function getOverallProgress() {
    return overallProgress;
}

function getOverallStatus() {
    return overallStatus;
}
