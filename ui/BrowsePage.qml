import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    id: root
    anchors.fill: parent

    function resetAndFocus() {
        if (stack.currentItem && stack.currentItem.resetAndFocus)
            stack.currentItem.resetAndFocus()
    }

    function urlToLocalPath(u) {
        var s = String(u);
        if (s.startsWith("file:///")) return s.slice(8);
        if (s.startsWith("file://"))  return s.slice(7);
        return s;
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: firstPage
    }

    Component {
        id: firstPage
        Item {
            Column {
                anchors.centerIn: parent
                width: parent.width - 140
                spacing: 12
                Button { text: "Run HSPICE"; icon.color: "#2dbcd6"; icon.source: "images/run.svg"; font.family: "Microsoft Uighur"; font.pointSize: 15;    onClicked: stack.push(runFilePage);      width: parent.width}
                Button { text: "Extract Data"; icon.color: "#2dbcd6"; icon.source: "images/pickaxe.svg"; font.family: "Microsoft Uighur"; font.pointSize: 15;    onClicked: stack.push(extractDataPage);  width: parent.width}
                Button { text: "Load Data"; icon.color: "#2dbcd6"; icon.source: "images/file-json.svg";    font.family: "Microsoft Uighur"; font.pointSize: 15;    onClicked: stack.push(loadDataPage);     width: parent.width}
            }

            Rectangle {
                id: rectangle1
                y: 50
                width: parent.width
                height: 95
                color: "#121821"
                border.color: "#00000000"

                Image {
                    id: image
                    x: 85
                    y: 5
                    width: 45
                    height: 45
                    source: "images/HScope.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: text2
                    x: 127
                    y: 10
                    width: 31
                    color: "#2dbcd6"
                    text: qsTr("Scope")
                    font.pixelSize: 45
                    font.family: "Microsoft UIghur"
                }

                Text {
                    id: text1
                    x: 15
                    y: 20
                    width: 31
                    height: 60
                    color: "#ffffff"
                    text: qsTr("Welcome to \n \nAnalyze and Visualize HSPICE Data")
                    font.pixelSize: 20
                    font.family: "Microsoft Uighur"
                }
            }
        }
    }

    Component {
        id: runFilePage
        Item {
            property alias path: dirField.text
            function resetAndFocus() { dirField.text = ""; dirField.forceActiveFocus() }

            Rectangle {
                id: rectangle1
                x: -10
                y: 50
                width: parent.width + 20
                height: 95
                color: "#121821"
                border.color: "#00000000"
            }

            TextField {
                id: dirField
                anchors.left: parent.left
                anchors.leftMargin: 50
                y: parent.height/2
                width: parent.width - 300
                color: "#2dbcd6"
                placeholderText: "Select a .sp file…"
                font.family: "Microsoft Uighur"
                font.pointSize: 16
                selectedTextColor: "#070059"
                selectionColor: "#2dbcd6"
                placeholderTextColor: "#2dbcd6"
            }
            Button {
                text: "Browse…"
                anchors.right: parent.right
                anchors.rightMargin: 120
                y: parent.height/2
                onClicked: fileDialog.open()
                font.family: "Microsoft Uighur"
                font.pointSize: 15
            }
            FileDialog {
                id: fileDialog
                title: "Choose your file…"
                onAccepted: {
                    var url = fileDialog.selectedFile.toString()
                    dirField.text = urlToLocalPath(url)
                }
                nameFilters: ["SP files (*.sp)"]
            }
            Button {
                text: "Run"
                anchors.right: parent.right
                anchors.rightMargin: 30
                y: parent.height - 75
                onClicked: {
                    backend.receivePathAndMode(path, 0)
                    if (stack.depth > 1) stack.pop(stack.get(0))
                }
                font.family: "Microsoft Uighur"
                font.pointSize: 15
            }
        }
    }

    Component {
        id: extractDataPage
        Item {
            property alias path: dirField.text
            function resetAndFocus() { dirField.text = ""; dirField.forceActiveFocus() }

            Rectangle {
                id: rectangle3
                x: -20
                y: 50
                width: parent.width + 40
                height: 95
                color: "#121821"
                border.color: "#00000000"
            }

            TextField {
                id: dirField
                anchors.left: parent.left
                anchors.leftMargin: 50
                y: parent.height/2
                width: parent.width - 300
                color: "#2dbcd6"
                placeholderText: "Select a file…"
                font.family: "Microsoft Uighur"
                font.pointSize: 16
                selectedTextColor: "#070059"
                selectionColor: "#2dbcd6"
                placeholderTextColor: "#2dbcd6"
            }
            Button {
                text: "Browse…"
                anchors.right: parent.right
                anchors.rightMargin: 120
                y: parent.height/2
                onClicked: fileDialog.open()
                font.family: "Microsoft Uighur"
                font.pointSize: 15
            }
            FileDialog {
                id: fileDialog
                title: "Choose your data file…"
                onAccepted: {
                    var url = fileDialog.selectedFile.toString()
                    dirField.text = urlToLocalPath(url)
                }
                nameFilters: ["All files (*)", "LIS files (*.lis)", "TR files (*.tr*)", "SW files (*.sw*)", "AC files (*.ac*)"]
            }
            Button {
                text: "OK"
                anchors.right: parent.right
                anchors.rightMargin: 30
                y: parent.height - 75
                onClicked: backend.receivePathAndMode(path, 1)
                font.family: "Microsoft Uighur"
                font.pointSize: 15
            }
        }
    }
    
    Component {
        id: loadDataPage
        Item {
            property alias path: dirField.text
            function resetAndFocus() { dirField.text = ""; dirField.forceActiveFocus() }

            Rectangle {
                id: rectangle4
                x: -10
                y: 50
                width: parent.width + 20
                height: 95
                color: "#121821"
                border.color: "#00000000"
            }

            TextField {
                id: dirField
                anchors.left: parent.left
                anchors.leftMargin: 50
                y: parent.height/2
                width: parent.width - 300
                color: "#2dbcd6"
                placeholderText: "Select a .json file…"
                font.family: "Microsoft Uighur"
                font.pointSize: 16
                selectedTextColor: "#070059"
                selectionColor: "#2dbcd6"
                placeholderTextColor: "#2dbcd6"
            }
            Button {
                text: "Browse…"
                anchors.right: parent.right
                anchors.rightMargin: 120
                y: parent.height/2
                onClicked: fileDialog.open()
                font.family: "Microsoft Uighur"
                font.pointSize: 15
            }
            FileDialog {
                id: fileDialog
                title: "Choose your data file…"
                onAccepted: {
                    var url = fileDialog.selectedFile.toString()
                    dirField.text = urlToLocalPath(url)
                }
                nameFilters: ["JSON files (*.json)"]
            }
            Button {
                text: "OK"
                anchors.right: parent.right
                anchors.rightMargin: 30
                y: parent.height - 75
                onClicked: backend.receivePathAndMode(path, 2)
                font.family: "Microsoft Uighur"
                font.pointSize: 15
            }
        }
    }

    ToolButton {
        id: backButton
        x: 50
        y: 70
        visible: stack.depth > 1
        text: "<-"
        icon.height: 25
        icon.width: 25
        display: AbstractButton.IconOnly
        icon.source: "images/arrow-left.svg"
        icon.color: "#2dbcd6"
        onClicked: if (stack.depth > 1) stack.pop(stack.get(0))
    }
}
