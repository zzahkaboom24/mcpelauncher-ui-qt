import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "ThemedControls"
import io.mrarm.mcpelauncher 1.0

LauncherBase {
    signal finished
    id: unlockLayout
    spacing: 0

    headerContent: TabBar {
        background: null
        MTabButton {
            text: qsTr("Unlock")
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: 10
        Layout.rightMargin: 10

        Item {
            Layout.fillHeight: true
        }

        Rectangle {
            id: warning
            opacity: 0
            color: "#30ff8000"
            Layout.fillWidth: true
            Layout.bottomMargin: 15
            Layout.minimumHeight: warningText.height
            radius: 4
            Text {
                id: warningText
                padding: 10
                text: qsTr("Warning: Password is invalid")
                color: labelColor
                font.pointSize: labelFontSize
                wrapMode: Text.WordWrap
                width: parent.width
            }

            OpacityAnimator {
                id: warningAnim
                target: warning;
                from: 1;
                to: 0;
                duration: 2000
                running: false
            }
        }

        MTextField {
            id: pwd
            Layout.fillWidth: true
            echoMode: TextInput.Password
        }

        MCheckBox {
            id: continueInvalidCredentials
            text: qsTr("Continue with invalid Credentials")
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.minimumHeight: pbutton.height + 10 * 2
        color: "#242424"
        MButton {
            id: pbutton
            text: qsTr("Continue")
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
            onClicked: {
                googleLoginHelperInstance.unlockkey = pwd.text
                if(googleLoginHelperInstance.account && !googleLoginHelperInstance.hasEncryptedCredentials || continueInvalidCredentials.checked) {
                    unlockLayout.finished()
                } else {
                    warning.opacity = 1
                    warningAnim.restart()
                }
            }
        }
    }
}
