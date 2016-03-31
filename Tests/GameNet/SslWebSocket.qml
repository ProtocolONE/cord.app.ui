import QtQuick 2.4

import GameNet.Controls 1.0
import Tulip 1.0

Rectangle {
    width: 1000
    height: 600
    color: "black"

    QtObject {
        id: d

        property string sslCertificate: "-----BEGIN CERTIFICATE-----
MIIFQjCCBCqgAwIBAgIJAIyTi9bLuFSnMA0GCSqGSIb3DQEBCwUAMIG0MQswCQYD
VQQGEwJVUzEQMA4GA1UECBMHQXJpem9uYTETMBEGA1UEBxMKU2NvdHRzZGFsZTEa
MBgGA1UEChMRR29EYWRkeS5jb20sIEluYy4xLTArBgNVBAsTJGh0dHA6Ly9jZXJ0
cy5nb2RhZGR5LmNvbS9yZXBvc2l0b3J5LzEzMDEGA1UEAxMqR28gRGFkZHkgU2Vj
dXJlIENlcnRpZmljYXRlIEF1dGhvcml0eSAtIEcyMB4XDTE2MDMzMDA3MzkzOFoX
DTE3MDMzMDA3MzkzOFowQDEhMB8GA1UECxMYRG9tYWluIENvbnRyb2wgVmFsaWRh
dGVkMRswGQYDVQQDExJjb25uZWN0LmdhbWVuZXQucnUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDBiYNTQO46PW5k9S9H9GVbMtGoLaW+vvx/doAjtHJI
hGLvgxe16VMhWoUoigZYd6HcXFYQQ6sswrgiW+7UKAvOXhZhipoH+CtC5O7x7sE2
ta3OltmYpJwdhboSqII443D2WQXwsKzYrmPNLESqtKk9lWCPhTKtPeme/Bv/773g
2PqhvjCEiyOoTYAwohXUU69t3Ilj9c3fX+XEiIZe2zuJu3xWx64h6uzdvCEdrbb3
/jJdAqYuy7QdlsSUHAkSDHMez3ZqcMnNCeECR685ZywJMe2BRgIYZWWKJkTuOD3t
5FuK+cExQ8UtlLYUYp6zjz42oepwIFtI4lQCZJy6HXOVAgMBAAGjggHIMIIBxDAM
BgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAOBgNV
HQ8BAf8EBAMCBaAwNwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NybC5nb2RhZGR5
LmNvbS9nZGlnMnMxLTIxNi5jcmwwXQYDVR0gBFYwVDBIBgtghkgBhv1tAQcXATA5
MDcGCCsGAQUFBwIBFitodHRwOi8vY2VydGlmaWNhdGVzLmdvZGFkZHkuY29tL3Jl
cG9zaXRvcnkvMAgGBmeBDAECATB2BggrBgEFBQcBAQRqMGgwJAYIKwYBBQUHMAGG
GGh0dHA6Ly9vY3NwLmdvZGFkZHkuY29tLzBABggrBgEFBQcwAoY0aHR0cDovL2Nl
cnRpZmljYXRlcy5nb2RhZGR5LmNvbS9yZXBvc2l0b3J5L2dkaWcyLmNydDAfBgNV
HSMEGDAWgBRAwr0njsw0gzCiM9f7bLPwtCyAzjA1BgNVHREELjAsghJjb25uZWN0
LmdhbWVuZXQucnWCFnd3dy5jb25uZWN0LmdhbWVuZXQucnUwHQYDVR0OBBYEFOSC
F3MwLht/0CiOsKky0r/sw5SJMA0GCSqGSIb3DQEBCwUAA4IBAQCI5OBfJLiVhiuq
B7ewz3O+ewb+pdWY0IbIag3eOsSLYdzkr9qy76QXM6/f1kt+UCArvyXOsVc7t1T7
/pK41EWR0kHeUWI2hTfHHEdtup/lLOZd4XedCteDpDOEFJsLd95lx83pN3k6dP9v
4f4DwqBCMKQbuiKMPrPB6TDXti96qof6ZPFwOngeQAcccpSNFv8kexkUkkHqrpCA
f/HX4Ho+/E1PxcsDS7Ha00BElw/EYhzp0SpIfNV0aeibvZO/jBr2Lft1GUPDmNlb
rFxZI0/vVl4bbq0XPdcZUPNpPW4jvF+J1pHfXNpk9ZxhX2NdWz7GZsAUUx9JxAMR
hYl1yWQL
-----END CERTIFICATE-----
"

        property string sslKey: "-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDBiYNTQO46PW5k
9S9H9GVbMtGoLaW+vvx/doAjtHJIhGLvgxe16VMhWoUoigZYd6HcXFYQQ6sswrgi
W+7UKAvOXhZhipoH+CtC5O7x7sE2ta3OltmYpJwdhboSqII443D2WQXwsKzYrmPN
LESqtKk9lWCPhTKtPeme/Bv/773g2PqhvjCEiyOoTYAwohXUU69t3Ilj9c3fX+XE
iIZe2zuJu3xWx64h6uzdvCEdrbb3/jJdAqYuy7QdlsSUHAkSDHMez3ZqcMnNCeEC
R685ZywJMe2BRgIYZWWKJkTuOD3t5FuK+cExQ8UtlLYUYp6zjz42oepwIFtI4lQC
ZJy6HXOVAgMBAAECggEASjhfOZVEBue6J1Nz32dVW2UgzBs9XepGUOdz+r1funmy
q2GdvTCOpdLeEA7mohS26RgsFS6uPYsrLFoPPCNja6/fa2bI7Vd517yN+g/y3vVL
g1eMeSJfkF7RXghrcD+g+YhoY8aNcsdmFK/uYXzJDonzrvaI2bFNn5/VaRBaxBgm
sAoZ8ZHx8aLa1lBQ2QvuNHSHBmwvX788CskT/hom+TnaD5b3DppxaNPJ8LPblwFI
lRLblNLHbqkSeUXFJqUbmhfN0z7zZB3+1JbTtl+Ca5DJl7M3in3cqTcRh7JVSkGi
wt+/RkQtBAY7wZlEfoWhs58aAA5LgTtR83KKiGyZoQKBgQDxsQzowVYEgAfrJvJV
q0OKxNaBWJVPBLn20f1d7cAQeO7pemE9wdcnhs+5FcvERvhltQYSX34u8lCvTA15
H0m3XWIF/dXL0jY1ZROKsiphqim7DEgRFDdsIWoK707dYoJBTNu/oQE9kS4USHXB
2SZw7lC1fs3jichAiFMhziznfQKBgQDM/qjOT20wejqY2HoxJd3x6R2Lqn9e7Bm3
uEJXhNBvJMuvQSXS4v2I/GE4OUktoMRzk+AXV6gW/qzWEzNB6RoVnN3R7riljlqs
dBuACRqzYY5VGqqHA/thON1dE/zKmnLjd+Vph6stBsdrejRI4DbJiq4GFhmgDntO
15RGwBFn+QKBgAh7ajSQ9G/b/msmRsLy67/nAJAxh6vqQoyC+h1dxqvNUrUm8lq0
ftSISqn4NdqBkx4eqEPkzgzfvC0qwh5KFtA0msgTDHnGuthM386ySgJ7clN6Lt1K
lFdbJNmVZHMojeG0zNGA2QZMHg3gLSHMeSjldDeqZ5dgsoJxRlmdXr4RAoGASBIM
RSR1jgKbEVuich8PDdrYcV8LEtNNI2Nbp6thIII+PipYYvE9E+kvQPYa/Ti1eLD3
qx09UoBNQaJUdgq/CfQxpHoaXtJSnKjhdj09Lu3Qfak3ZOqIeaDlarD5Qj3UwJZJ
iLWS/+yPNgEr2qdBe9AO6MLiVXxh69EtJ0all/kCgYEAi0Hakj8zY3Nv9hOsjxD9
1ssoe1n99sxFxv7oPwn0x7bBpsdgoyd8f6fWElIGnfH6bOg++lrLIwnHvOGicoPu
4jkKwSQvBKikJH68+JUlwgaFVMImW+WPx2KbE6tmctnJ1spiPc3piekj69BnH5Lw
jfHFNaWGV390aeecxcy7HTU=
-----END PRIVATE KEY-----
"
    }

    Row {
        spacing: 10
        x: 10
        y: 10

        Button {
            text: "startListen"
            onClicked: {
                console.log('----')
                loader.sourceComponent = testServer
            }
        }
    }

    Component {
        id: testServer


        SslWebSocketServer {
            id: server

            function webSocketStatusChanged(status) {
                console.log('sslWebSocket status', status);
            }

            function webSocketTextMessageReceived(message) {
                console.log('sslWebSocket message', message);
            }

            port: 1235
            listen: true
            ssl: SslWebSocketServer.SecureMode
            sslCertificate: d.sslCertificate
            sslKey:d.sslKey

            onClientConnected: {
                webSocket.statusChanged.connect(webSocketStatusChanged);
                webSocket.textMessageReceived.connect(webSocketTextMessageReceived);
            }
        }
    }

    Loader {
        id: loader
    }
}
