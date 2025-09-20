import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: dlg
    modal: true
    focus: true
    anchors.centerIn: parent

    implicitWidth: Math.min(parent ? parent.width - 80 : 420, 420)
    implicitHeight: contentItem.implicitHeight + footer.implicitHeight + 32
    padding: 16

    property string kind: "info"
    property string messageText: ""

    readonly property color accentColor : kind === "error" ? "#ff5252"
                                        : kind === "warn"  ? "#ffb300"
                                        : kind === "ask"   ? "#05f50d"
                                        :                    "#2dbcd6"

    background: Rectangle {
        radius: 12
        color: "#1a222d"
        border.color: dlg.accentColor
        border.width: 1
    }

    Overlay.modal: Rectangle {
        anchors.fill: parent
        color: "#88000000"
        radius: 15
    }

    header: Row {
        spacing: 10
        leftPadding: 8; rightPadding: 8; topPadding: 6; bottomPadding: 6

        Rectangle {
            width: 28; height: 28; radius: 14
            color: Qt.rgba(Qt.colorEqual(dlg.accentColor, "#2dbcd6") ? 0.25 :
                           Qt.colorEqual(dlg.accentColor, "#05f50d") ? 0.25 : 0.23,0, 0, 0.25)

            border.color: dlg.accentColor
            border.width: 1
            Text {
                anchors.centerIn: parent
                text: dlg.kind === "error" ? "!" : (dlg.kind === "warn" ? "!" : (dlg.kind === "ask" ? "?" : "i"))
                color: dlg.accentColor
                font.pixelSize: 16
                font.bold: true
            }
        }
        Label {
            text: dlg.title.length ? dlg.title
                                       : (dlg.kind === "error" ? "Error"
                                       : dlg.kind === "warn" ? "Warning"
                                       : dlg.kind === "ask" ? "Question"
                                       : "Information")
            color: "#e9f1ff"
            font.family: "Microsoft Uighur"
            font.bold: true
            font.pointSize: 24
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    contentItem: ColumnLayout {
        anchors.top: header.bottom
        anchors.bottom: footerRec.top
        Label {
            Layout.fillWidth: true
            text: dlg.messageText
            font.family: "Microsoft Uighur"
            color: "#e0e0e0"
            wrapMode: Text.Wrap
            font.pointSize: 18
        }
    }

    footer: DialogButtonBox {
        id: footerRec
        alignment: Qt.AlignRight
        background: Rectangle{color: "transparent"; border.width: 0}
        Button {
            text: dlg.kind === "ask" ? "Yes" : "OK"
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            background: Rectangle { radius: 8; color: Qt.darker(dlg.accentColor, 1.2) }
            contentItem: Text {
                text:  dlg.kind === "ask" ? "Yes" : "OK"; color: "white"; font.bold: true
                verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
            }
        }
        Button {
            text: "No"
            visible: dlg.kind === "ask"
            background: Rectangle { radius: 8; color: Qt.darker("#ff5252", 1.2) }
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            contentItem: Text {
                text:  "No"; color: "white"; font.bold: true
                verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
            }
        }
        onRejected: dlg.close()
        onAccepted: {
            dlg.close()
            dlg.accepted()
        }
    }

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    onOpened: forceActiveFocus()
}
