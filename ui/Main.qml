import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Studio.DesignEffects

Item {
    id: root
    anchors.fill: parent
    layer.enabled: true

    function askAsync(message) {
        return new Promise(function(resolve) {
            msgDialog.kind = "ask"
            msgDialog.title = "Confirm"
            msgDialog.messageText = message
            msgDialog.open()

            function okHandler()    { cleanup(); resolve(true) }
            function rejHandler()   { cleanup(); resolve(false) }
            function closeHandler() { cleanup(); resolve(false) }

            function cleanup() {
                msgDialog.accepted.disconnect(okHandler)
                msgDialog.rejected.disconnect(rejHandler)
                msgDialog.closed.disconnect(closeHandler)
            }

            msgDialog.accepted.connect(okHandler)
            msgDialog.rejected.connect(rejHandler)
            msgDialog.closed.connect(closeHandler)
        })
    }

    property var inputData: []
    property string selectedX: ""
    property var selectedY: []

    Item{
        id: mainContents
        anchors.fill: parent

        Rectangle {
            id: rectangleSamp
            z: 0
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.topMargin:50
            height: 75
            color: "#121821"
            border.color: "#00000000"
        }

        ToolButton {
            id: menuButton
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 50
            anchors.topMargin: 65
            icon.color: "#2dbcd6"
            icon.source: "images/menu.svg"
            onClicked: sidebar.open()
        }
    
        Column {
            id: columnX
            anchors.fill: parent
            anchors.leftMargin: 120
            anchors.rightMargin: (parent.width+50)/2
            anchors.topMargin: 46
            anchors.bottomMargin: 94
            spacing: 8
            padding: 12
    
            Frame {
                y: 12
                height: parent.height - 50
                opacity: 1
                visible: true
                width: parent.width
                font.pointSize: 18
                font.family: "Microsoft Uighur"
                transformOrigin: Item.Center
                background: Rectangle { color: "transparent"; border.width: 0 }
    
                Text {
                    id: columnTextX
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    color: "#2dbcd6"
                    text: qsTr("Choose horizontal axis: ")
                    font.pixelSize: 25
                    font.family: "Microsoft UIghur"
                }
    
                TextField {
                    id: searchFieldX
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: columnTextX.bottom
                    anchors.leftMargin: 21
                    anchors.rightMargin: 21
                    anchors.topMargin: 15
                    placeholderText: "Search…"
                    color: "#2dbcd6"
                    selectionColor: "#2dbcd6"
                    selectedTextColor: "#070059"
                    placeholderTextColor: "#2dbcd6"
                    font.family: "Microsoft Uighur"
                    font.pointSize: 16
                }
    
                ListView {
                    id: listView
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.top: searchFieldX.bottom
                    anchors.leftMargin: 21
                    anchors.rightMargin: 21
                    anchors.topMargin: 10
                    anchors.bottomMargin: 5
                    orientation: ListView.Vertical 
                    model: searchFieldX.text.length === 0
                           ? inputData
                           : inputData.filter(function(item) {
                                 var s = String(item);
                                 return s.toLowerCase().indexOf(searchFieldX.text.toLowerCase()) !== -1;
                             })
                    clip: true
    
                    delegate: RadioDelegate {
                        id : xList
                        background: Rectangle { color: "transparent"; border.width: 0 }
                        width: ListView.view.width-10
                        text: modelData
    
                        contentItem: Text {
                            text: xList.text
                            color: xList.checked ? "#05f50d" : "#2dbcd6"
                            font: xList.font
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
    
                        onToggled: {if (checked) selectedX = modelData}
                        checked:  selectedX === modelData
                    }
    
                    ScrollBar.vertical: ScrollBar { id: scrollBar; width: 10; policy: ScrollBar.AsNeeded }
                }
            }
        }
    
        Column {
            id: columnY
            anchors.fill: parent
            anchors.leftMargin: (parent.width+50)/2
            anchors.rightMargin: 120
            anchors.topMargin: 46
            anchors.bottomMargin: 94
            spacing: 8
            padding: 12
            Frame {
                y: 12
                height: parent.height - 50
                opacity: 1
                visible: true
                width: parent.width
                transformOrigin: Item.Center
                font.pointSize: 18
                font.family: "Microsoft Uighur"
                background: Rectangle { color: "transparent"; border.width: 0 }
    
                Text {
                    id: columnTextY
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    color: "#2dbcd6"
                    text: qsTr("Choose vertical axis: ")
                    font.pixelSize: 25
                    font.family: "Microsoft UIghur"
                }
    
                TextField {
                    id: searchFieldY
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: columnTextY.bottom
                    anchors.leftMargin: 21
                    anchors.rightMargin: 21
                    anchors.topMargin: 15
                    placeholderText: "Search…"
                    color: "#2dbcd6"
                    selectionColor: "#2dbcd6"
                    selectedTextColor: "#070059"
                    placeholderTextColor: "#2dbcd6"
                    font.family: "Microsoft Uighur"
                    font.pointSize: 16
                }
    
                ListView {
                    id: listView1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.top: searchFieldY.bottom
                    anchors.leftMargin: 21
                    anchors.rightMargin: 21
                    anchors.topMargin: 10
                    anchors.bottomMargin: 5
                    orientation: ListView.Vertical
                    model: searchFieldY.text.length === 0
                           ? inputData
                           : inputData.filter(function(item) {
                                 var s = String(item);
                                 return s.toLowerCase().indexOf(searchFieldY.text.toLowerCase()) !== -1;
                             })
                    delegate: CheckDelegate {
                        id : yList
                        background: Rectangle { color: "transparent"; border.width: 0 }
                        width: ListView.view.width-10
                        text: modelData
                        contentItem: Text {
                            text: yList.text
                            color: yList.checked ? "#05f50d" : "#2dbcd6"
                            font: yList.font
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
    
                        onToggled: {
                            const i = selectedY.indexOf(modelData)
                            if (checked && i === -1) selectedY.push(modelData)
                            else if (!checked && i !== -1) selectedY.splice(i, 1)
                        }
                        checked: selectedY.indexOf(modelData) !== -1
                    }
                    clip: true
                    ScrollBar.vertical: ScrollBar {
                        id: scrollBar1
                        width: 10
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
        }
    
        Button {
            id: plotButton
            anchors.left: parent.left
            anchors.leftMargin: 120
            y: parent.height - 150
            text: qsTr("View Waveform")
            display: AbstractButton.TextOnly
            focusPolicy: Qt.ClickFocus
            icon.color: "#00070059"
            font.pointSize: 14
            font.family: "Microsoft Uighur"
            onClicked: backend.plotSignal(selectedY, selectedX, holdOnSwitch.checked)
            background: Rectangle {
                radius: 12
                color:  Qt.rgba(18/255,24/255,33/255,0.5)
            }
            contentItem: Text {
                text: plotButton.text
                font: plotButton.font
                color: "#2dbcd6"
                verticalAlignment: Text.AlignVCenter
            }
        }
    
        Switch {
            id: holdOnSwitch
            anchors.left: parent.left
            anchors.leftMargin: 120
            y: parent.height - 100
            text: qsTr("HoldOn mode")
            font.pointSize: 16
            font.family: "Microsoft Uighur"
    
            contentItem: Text {
                text: holdOnSwitch.text
                font: holdOnSwitch.font
                color: holdOnSwitch.checked ? "#05f50d" : "#2dbcd6"
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: -50
            }
        }
    
        Button {
            id: calcButton 
            anchors.right: parent.right
            anchors.rightMargin: 120
            y: parent.height - 100
            text: qsTr("Go to Calculator")
            display: AbstractButton.TextOnly
            focusPolicy: Qt.ClickFocus
            font.pointSize: 14
            font.family: "Microsoft Uighur"
            onClicked: backend.goCalc()
            background: Rectangle {
                radius: 12
                color:  Qt.rgba(18/255,24/255,33/255,0.5)
            }
            contentItem: Text {
                text: calcButton.text
                font: calcButton.font
                color: "#2dbcd6"
                verticalAlignment: Text.AlignVCenter
            }
        }
    }


    Drawer {
        id: sidebar
        width: 300
        height: root.height
        edge: Qt.LeftEdge
        modal: true
        interactive: true
        clip: true

        onOpened: {
            const src = designEffect.backgroundLayer
            designEffect.backgroundLayer = null
            Qt.callLater(() => designEffect.backgroundLayer = src)
        }

        background: Item {
            anchors.fill: parent
            Rectangle {
                anchors.fill: parent
                radius: 15
                color: "#44121821"

                DesignEffect {
                    id: designEffect
                    backgroundLayer: mainShape
                    backgroundBlurRadius: 17
                }
            }
        }

        Overlay.modal: Rectangle {
            anchors.fill: parent
            color: "#88000000"
            radius: 15
        }

        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            Label {
                text: "HScope"
                color: "#2dbcd6"
                font.family: "Microsoft Uighur"
                font.pointSize: 24
                Layout.alignment: Qt.AlignLeft
            }


            Component {
                id: coloredIcon
                Item {
                    property alias source: iconImg.source
                    property color tint: "#2dbcd6"
                    width: 20; height: 20
                    Image { id: iconImg; anchors.fill: parent; fillMode: Image.PreserveAspectFit; smooth: true }
                    ColorOverlay { anchors.fill: parent; source: iconImg; color: parent.tint }
                }
            }

            ToolButton {
                id: homeButton
                background: Rectangle { color: "transparent" }
                Layout.fillWidth: true
                contentItem: Row {
                    spacing: 10
                    anchors.fill: parent
                    anchors.margins: 6
                    Loader { sourceComponent: coloredIcon; onLoaded: item.source = "images/house.svg" }
                    Text {
                        text: "Home"
                        color: "#2dbcd6"
                        font.family: "Microsoft Uighur"; font.pointSize: 16
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                }
                onClicked: {
                    askAsync("Back to Home Page?")
                        .then(function(ok) {
                            if (ok) backend.backToHome()
                        })
                }

            }

            ToolButton {
                id: saveSplitButton
                background: Rectangle { color: "transparent" }
                Layout.fillWidth: true
                contentItem: Row {
                    spacing: 10
                    anchors.fill: parent
                    anchors.margins: 6
                    Loader { sourceComponent: coloredIcon; onLoaded: item.source = "images/save.svg" }
                    Text { text: "Save as …"; color: "#2dbcd6"; font.family: "Microsoft Uighur"; font.pointSize: 16; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                }
                onClicked: {saveMenu.openAt(saveSplitButton)}
            }

            ToolButton {
                id: saveJsonButton
                background: Rectangle { color: "transparent" }
                Layout.fillWidth: true
                contentItem: Row {
                    spacing: 10
                    anchors.fill: parent
                    anchors.margins: 6
                    Loader { sourceComponent: coloredIcon; onLoaded: item.source = "images/file-json.svg" }
                    Text { text: "Export JSON file"; color: "#2dbcd6"; font.family: "Microsoft Uighur"; font.pointSize: 16; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                }
                onClicked: {
                    askAsync("Export .JSON?")
                        .then(function(ok) {
                            if (ok) backend.saveAsJSON()
                        })
                }
            }

            Item { Layout.fillHeight: true }

            ToolButton {
                id: githubButton
                background: Rectangle { color: "transparent" }
                Layout.fillWidth: true
                contentItem: Row {
                    spacing: 10
                    anchors.fill: parent
                    anchors.margins: 6
                    Loader { sourceComponent: coloredIcon; onLoaded: item.source = "images/github.svg" }
                    Text { text: "GitHub"; color: "#2dbcd6"; font.family: "Microsoft Uighur"; font.pointSize: 16; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                }
                onClicked: { /* TODO: Make an GitHub Repo*/ }
            }

            ToolButton {
                id: exitButton
                background: Rectangle { color: "transparent" }
                Layout.fillWidth: true
                contentItem: Row {
                    spacing: 10
                    anchors.fill: parent
                    anchors.margins: 6
                    Loader { sourceComponent: coloredIcon; onLoaded: item.source = "images/log-out.svg" }
                    Text { text: "Exit"; color: "#2dbcd6"; font.family: "Microsoft Uighur"; font.pointSize: 16; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                }
                onClicked: {
                    saveMenu.close()
                    askAsync("Exit?")
                        .then(function(ok) {
                            if (ok) appWin.close()
                        })
                }
            }

            Popup {
                id: saveMenu
                modal: false
                focus: true
                padding: 8
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

                implicitWidth: contentItem.implicitHeight +64
                implicitHeight: contentItem.implicitHeight + 32

                background: Rectangle {
                    radius: 10
                    color: "#441a222d"
                    layer.enabled: true
                    layer.mipmap: true
                }

                contentItem: ColumnLayout {
                    spacing: 6

                    ToolButton {
                        Layout.fillWidth: true
                        background: Rectangle { color: "transparent" }
                        contentItem: Row {
                            spacing: 10
                            anchors.fill: parent
                            anchors.margins: 6
                            Loader { sourceComponent: coloredIcon; onLoaded: item.source = "images/csv.svg" }
                            Text { text: "Save as .csv"; color: "#2dbcd6"; font.family: "Microsoft Uighur"; font.pointSize: 14; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                        }
                        onClicked: {
                            saveMenu.close()
                            askAsync("Save as .csv?")
                                .then(function(ok) {
                                    if (ok) backend.saveAsCSV()
                                })

                        }
                    }
                    ToolButton {
                        Layout.fillWidth: true
                        background: Rectangle { color: "transparent" }
                        contentItem: Row {
                            spacing: 10
                            anchors.fill: parent
                            anchors.margins: 6
                            Loader { sourceComponent: coloredIcon; onLoaded: item.source = "images/mat.svg" }
                            Text { text: "Save as .mat"; color: "#2dbcd6"; font.family: "Microsoft Uighur"; font.pointSize: 14; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                        }
                        onClicked: {
                            saveMenu.close()
                            askAsync("Save as .mat?")
                                .then(function(ok) {
                                    if (ok) backend.saveAsMAT()
                                })

                        }
                    }

                    ToolButton {
                        Layout.fillWidth: true
                        background: Rectangle { color: "transparent" }
                        contentItem: Row {
                            spacing: 10
                            anchors.fill: parent
                            anchors.margins: 6
                            Loader { sourceComponent: coloredIcon; onLoaded: item.source = "images/mat.svg" }
                            Text { text: "Save as .m"; color: "#2dbcd6"; font.family: "Microsoft Uighur"; font.pointSize: 14; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                        }
                        onClicked: {
                            saveMenu.close()
                            askAsync("Save as .m?")
                                .then(function(ok) {
                                    if (ok) backend.saveAsM()
                                })
                        }
                    }
                }

                enter: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 160; easing.type: Easing.OutCubic }
                    NumberAnimation { property: "x"; from: saveMenu.x + 8; to: saveMenu.x; duration: 160; easing.type: Easing.OutCubic }
                }
                exit: Transition {
                    NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 120; easing.type: Easing.InCubic }
                }

                function openAt(anchorItem) {
                    const pt = anchorItem.mapToItem(root, anchorItem.width + 8, (anchorItem.height - implicitHeight) / 2)
                    x = Math.round(Math.min(root.width - implicitWidth - 8, Math.max(8, pt.x)))
                    y = Math.round(Math.min(root.height - implicitHeight - 8, Math.max(8, pt.y)))
                    open()
                }
            }
        }
    }
}
