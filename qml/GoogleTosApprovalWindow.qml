import QtQuick 2.9

import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4

Window {

    property string tosText: "By using this application you agree to the Google Play Terms of Service."
    property string marketingText: "I agree to receive Marketing E-Mails"

    property bool tosApproved: false
    property alias marketingApproved: marketingCheck.checked

    signal done(bool approved, bool marketing)

    width: Math.min(layout.implicitWidth + layout.anchors.leftMargin + layout.anchors.rightMargin, 420)
    height: layout.implicitHeight + layout.anchors.topMargin + layout.anchors.bottomMargin
    flags: Qt.Dialog
    title: "Google Play ToS approval"

    onClosing: function () {
        done(tosApproved, marketingApproved)
        tosApproved = false
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text {
            text: tosText
            wrapMode: Text.WordWrap
            Layout.fillWidth: true

            onLinkActivated: Qt.openUrlExternally(link)
        }

        CheckBox {
            id: marketingCheck
            text: marketingText
            visible: marketingText.length > 0
            Layout.topMargin: 10
            Layout.fillWidth: true
            style: CheckBoxStyle {
                label: Text {
                    wrapMode: Text.WordWrap
                    text: control.text
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            Button {
                text: "Agree"
                onClicked: function () {
                    tosApproved = true
                    close()
                }
            }

            Button {
                text: "Disagree"
                onClicked: function () {
                    tosApproved = false
                    close()
                }
            }
        }
    }
}
