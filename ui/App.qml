import QtQuick
import QtQuick.Controls
import QtQuick.Window


Window {
    id: appWin
    width: 900
    height: 560
    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"

    Material.theme: Material.Dark

    Rectangle {
        id: mainShape
        anchors.fill: parent
        radius: 15
        color: "#1a222d"
        border.color: "#00ffffff"
        clip: true


        Item {
            id: host
            anchors.fill: parent

            property bool switching: false
            property var queuedNav: null

            Loader {
                id: newPage
                anchors.fill: parent
                z: 2
                asynchronous: true
                opacity: 0
                visible: opacity > 0
                source: "BrowsePage.qml"

                onStatusChanged: {
                    if (status === Loader.Ready && host.switching) {
                        crossFade.start()
                    }
                }
            }

            Loader {
                id: oldPage
                anchors.fill: parent
                z: 1
                asynchronous: true
                opacity: 0
                visible: opacity > 0
            }

            ParallelAnimation {
                id: crossFade
                running: false
                onStopped: {
                    oldPage.source = ""
                    host.switching = false

                    if (host.queuedNav) {
                        const n = host.queuedNav
                        host.queuedNav = null
                        host.go(n.url, n.props)
                    }
                }

                NumberAnimation {
                    target: oldPage; property: "opacity"; from: 1; to: 0
                    duration: 280; easing.type: Easing.InOutQuad
                    alwaysRunToEnd: true
                }
                NumberAnimation {
                    target: newPage; property: "opacity"; from: 0; to: 1
                    duration: 280; easing.type: Easing.InOutQuad
                    alwaysRunToEnd: true
                }
            }

            function go(url, props) {
                if (host.switching) {
                    host.queuedNav = { url: url, props: props }
                    return
                }
                host.switching = true
                oldPage.source = newPage.source
                if (oldPage.source !== "") oldPage.opacity = 1

                newPage.opacity = 0
                if (props) newPage.setSource(url, props)
                else       newPage.source = url

                if (oldPage.source === "" && newPage.status === Loader.Ready) {
                    crossFade.start()
                }
            }

            Component.onCompleted: {
                if (newPage.status === Loader.Ready) {
                    newPage.opacity = 0
                    crossFade.start()
                } else {
                    host.switching = true
                }
            }

            Connections {
                target: backend

                function onProceedMain(data) {
                    host.go("Main.qml", { inputData: data })
                }

                function onCalcMode(data) {
                    host.go("Calc.qml", { dataList: data })
                }

                function onProceedHome() {
                    host.go("BrowsePage.qml")
                }
            }
        }

        CustomDialog {
            id: msgDialog
            onAccepted: {
                if (newPage.item && newPage.item.resetAndFocus) {
                    newPage.item.resetAndFocus()
                }
            }
        }

        Connections {
            target: backend

            function onErrorOccurred(msg) {
                msgDialog.kind = "error"
                msgDialog.title = "Error"
                msgDialog.messageText = String(msg)
                msgDialog.open()
            }

            function onInfoOccurred(msg) {
                msgDialog.kind = "info"
                msgDialog.title = "Information"
                msgDialog.messageText = String(msg)
                msgDialog.open()
            }

            function onWarnOccurred(msg) {
                msgDialog.kind = "warn"
                msgDialog.title = "Warning"
                msgDialog.messageText = String(msg)
                msgDialog.open()
            }
        }
    }

    Rectangle {
        id: titlebar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 65
        color: "transparent"
        z: 0
        
        DragHandler {
            target: null
            grabPermissions: PointerHandler.TakeOverForbidden
            onActiveChanged: if (active) appWin.startSystemMove()
        }

        Row {
            id : captionButtons
            x: 724
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenterOffset: -1
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            padding: 8

            ToolButton {
                text: "—"
                display: AbstractButton.IconOnly
                icon.source: "images/minus.svg"
                icon.width: 15; icon.height: 15
                icon.color: "#2dbcd6"
                onClicked: appWin.showMinimized()
            }

            ToolButton {
                opacity: 1
                text: appWin.visibility === Window.Maximized ? "❐" : "▢"
                display: AbstractButton.IconOnly
                icon.source: appWin.visibility === Window.Maximized ? "images/minimize.svg" : "images/maximize.svg"
                icon.width: 15; icon.height: 15
                icon.color: "#2dbcd6"
                onClicked: appWin.visibility === Window.Maximized ? appWin.showNormal() : appWin.showMaximized()
            }

            ToolButton {
                text: "✕"
                display: AbstractButton.IconOnly
                icon.source: "images/x.svg"
                icon.width: 15; icon.height: 15
                icon.color: "#2dbcd6"
                onClicked: appWin.close()
            }
        }
    }
}

