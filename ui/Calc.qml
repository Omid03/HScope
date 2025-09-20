import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent

    property var dataList: []
    property string expression: ""
    property alias variable_name: newVarName.text

    function insertToken(t) {
        expression += t;
    }

    function backspace() {
        if (expression.length === 0)
            return;

        let lastChar = expression.charAt(expression.length - 1);

        if (lastChar === "`") {
            let openIndex = expression.lastIndexOf("`", expression.length - 2);
            if (openIndex !== -1) {
                expression = expression.slice(0, openIndex);
                return;
            }
        }

        expression = expression.slice(0, expression.length - 1);
    }

    function clearAll() {
        expression = "";
    }

    Rectangle {
        id: rectangle
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10
        anchors.right: parent.horizontalCenter
        height: parent.height / 4 - 20
        color: "#00ffffff"
        border.color: "#00000000"

        Text {
            id: noteText1
            text: qsTr("Note:")
            color: "yellow"
            font.family: "Microsoft Uighur"
            font.pointSize: 18
        }
        Text {
            id: noteText2
            anchors.top:noteText1.bottom
            text: qsTr("    1.Use a unique name for your variable.\n    2.Follow proper mathematical calculation syntax.\n    3.Use \"_\" as delimiter in name of your variable.\n    4.Do not use special characters for name of your variable name.")
            color: "white"
            font.family: "Microsoft Uighur"
            font.pointSize: 18
        }
    }

    TextField {
        id: newVarName
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.horizontalCenter
        anchors.top: rectangle.bottom
        anchors.topMargin: 80

        color: "white"
        font.family: "Microsoft Uighur"
        font.pointSize: 14
        placeholderText: "Write a name for new variable…"

        selectedTextColor: "#070059"
        selectionColor: "#2dbcd6"
        placeholderTextColor: "white"
    }

    Frame {
        id: textFrame
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.horizontalCenter
        anchors.top: rectangle.bottom
        anchors.topMargin: 10
        height: 50

        background: Rectangle {
            color: "white"
            radius: 12
        }

        ScrollView {
            id: scroll
            anchors.fill: parent
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ScrollBar.horizontal:   ScrollBar { id: scrollBar; y: 40; height: 10; width: parent.width; policy: ScrollBar.AsNeeded }

            Text {
                id: frameText
                x: 0
                y: 0
                anchors.fill: parent
                text: expression
                font.family: "Consolas"
                font.pixelSize: 18
                wrapMode: Text.NoWrap
                height: scroll.height
                verticalAlignment: Text.AlignVCenter

                onTextChanged: Qt.callLater(function () {
                    var f = scroll.contentItem;
                    if (f && f.width > 0) {
                        f.contentX = Math.max(0, f.contentWidth - f.width);
                    }
                })
            }
        }
    }



    TextField {
        id: searchField
        anchors.top: parent.top
        anchors.topMargin: 65
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: dataListView.top
        anchors.bottomMargin: 10
        placeholderText: "Search…"

        color: "white"
        font.family: "Microsoft Uighur"
        font.pointSize: 14

        selectedTextColor: "#070059"
        selectionColor: "#2dbcd6"
        placeholderTextColor: "white"
    }

    ListView {
        id: dataListView
        anchors.top: parent.top
        anchors.topMargin: 105
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 95

        spacing: 8
        clip: true
        model: searchField.text.length === 0
               ? dataList
               : dataList.filter(function(item) {
                     var s = String(item);
                     return s.toLowerCase().indexOf(searchField.text.toLowerCase()) !== -1;
                 })

        delegate: Button {
            text: modelData
            width: dataListView.width
            font.family: "Microsoft Uighur"
            font.pixelSize: 18

            background: Rectangle {
                radius: 12
                color: Qt.rgba(0,0,0,0.2)
            }

            onClicked: {insertToken("\`" + text + "\`")}
        }
    }

    GridLayout {
        id: gridLayout
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.top: newVarName.bottom
        anchors.topMargin: 10

        Layout.fillWidth: true
        Layout.fillHeight: true
        columns: 4
        rowSpacing: 8
        columnSpacing: 8

        Button {
            text: "⌫"
            font.family: "Microsoft Uighur"
            font.pixelSize: 12
            Layout.row: 0
            Layout.column: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            background: Rectangle {
                radius: 12
                color: Qt.rgba(0,0,0,0.2)
            }
            onClicked: backspace()
        }

        Repeater {
            model: [{t:"7", op:false}, {t:"8", op:false}, {t:"9", op:false}, {t:"÷", op:true}]
            delegate: Button {
                text: modelData.t
                font.family: "Microsoft Uighur"
                font.pixelSize: modelData.op ? 24 : 18
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    radius: 12
                    color: modelData.op ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0.1)
                }
                onClicked: {insertToken(text)}
            }
        }

        Repeater {
            model: [{t:"4", op:false}, {t:"5", op:false}, {t:"6", op:false}, {t:"×", op:true}]
            delegate: Button {
                text: modelData.t
                font.family: "Microsoft Uighur"
                font.pixelSize: modelData.op ? 24 : 18
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    radius: 12
                    color: modelData.op ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0.1)
                }
                onClicked: {insertToken(text)}
            }
        }

        Repeater {
            model: [{t:"1", op:false}, {t:"2", op:false}, {t:"3", op:false}, {t:"-", op:true}]
            delegate: Button {
                text: modelData.t
                font.family: "Microsoft Uighur"
                font.pixelSize: modelData.op ? 24 : 18
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    radius: 12
                    color: modelData.op ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0.1)
                }
                onClicked: {insertToken(text)}
            }
        }

        Button {
            text: "C"
            font.family: "Microsoft Uighur"
            font.pixelSize: 18
            Layout.fillWidth: true
            Layout.fillHeight: true
            background: Rectangle {
                radius: 12
                color: Qt.rgba(1,0,0,0.5)
            }
            onClicked: clearAll()
        }

        Button {
            text: "0"
            font.family: "Microsoft Uighur"
            font.pixelSize: 18
            Layout.fillWidth: true
            Layout.fillHeight: true
            background: Rectangle {
                radius: 12
                color: Qt.rgba(0,0,0,0.1)
            }
            onClicked: insertToken("0")
        }

        Button {
            text: "."
            font.family: "Microsoft Uighur"
            font.pixelSize: 24
            Layout.fillWidth: true
            Layout.fillHeight: true
            background: Rectangle {
                radius: 12
                color: Qt.rgba(0,0,0,0.2)
            }
            onClicked: insertToken(".")
        }

        Button {
            text: "+"
            font.family: "Microsoft Uighur"
            font.pixelSize: 24
            Layout.fillWidth: true
            Layout.fillHeight: true
            background: Rectangle {
                radius: 12
                color: Qt.rgba(0,0,0,0.2)
            }
            onClicked: insertToken("+")
        }

        Button {
            text: "("
            font.family: "Microsoft Uighur"
            font.pixelSize: 18
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            background: Rectangle {
                radius: 12
                color: Qt.rgba(0,0,0,0.2)
            }
            onClicked: insertToken("(")
        }

        Button {
            text: ")"
            font.family: "Microsoft Uighur"
            font.pixelSize: 18
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            background: Rectangle {
                radius: 12
                color: Qt.rgba(0,0,0,0.2)
            }
            onClicked: insertToken(")")
        }
    }

    Button {
        id: addButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 15
        anchors.bottomMargin: 20
        text: qsTr("Add")
        height: 45
        display: AbstractButton.TextOnly
        focusPolicy: Qt.ClickFocus
        font.family: "Microsoft Uighur"
        font.pointSize: 16
        onClicked: backend.addVariable(expression, variable_name)
        background: Rectangle {
            radius: 12
            color: Qt.rgba(7/255, 0, 89/255, 0.5)
        }
        contentItem: Text {
            text: addButton.text
            font: addButton.font
            color: "#2dbcd6"
            verticalAlignment: Text.AlignVCenter
        }
    }

    Button {
        id: cancelButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 105
        anchors.bottomMargin: 20
        height: 45
        text: qsTr("Cancel")
        display: AbstractButton.TextOnly
        focusPolicy: Qt.ClickFocus
        font.family: "Microsoft Uighur"
        font.pointSize: 14
        onClicked: backend.backToMain()
        background: Rectangle {
            radius: 12
            color:  Qt.rgba(172/255,172/255,172/255,1)
        }
        contentItem: Text {
            text: cancelButton.text
            font: cancelButton.font
            color: "#1a222d"
            verticalAlignment: Text.AlignVCenter
        }
    }
}

