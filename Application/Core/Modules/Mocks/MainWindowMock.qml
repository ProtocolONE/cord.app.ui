import QtQuick 1.1

QtObject {
    id: fakeMainWindowsInstance

    signal closeMainWindow();
    signal windowDeactivated();
    signal windowActivated();

    signal downloaderStarted(string service, int startType);
    signal downloaderFinished(string service);
    signal downloaderStopped(string service);
    signal downloaderStopping(string service);
    signal downloaderFailed(string service);
    signal downloaderServiceStatusMessageChanged(string service, string message);

    signal serviceStarted(string service);
    signal serviceFinished(string service, int serviceState);
    signal serviceInstalled(string serviceId);
    signal wrongCredential(string userId);

    signal navigate(string name);
    signal leftMousePress(int x, int y);
    signal leftMouseRelease(int x, int y);
    signal selectService();
    signal needPakkanenVerification();
    signal restartUIRequest();
    signal shutdownUIRequest();
}
