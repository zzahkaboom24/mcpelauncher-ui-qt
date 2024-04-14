import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import "ThemedControls"
import io.mrarm.mcpelauncher 1.0

ColumnLayout {
    default property alias content: container.data
    property alias headerContent: baseHeader.content
    property bool hasUpdate: false
    property string updateDownloadUrl: ""
    property bool progressbarVisible: false
    property string progressbarText: ""
    property string warnMessage: ""
    property string warnUrl: ""
    property var setProgressbarValue: function (value) {
        downloadProgress.value = value
    }

    id: rowLayout
    spacing: 0

    BaseHeader {
        id: baseHeader
        Layout.fillWidth: true
        title: qsTr("Unofficial *nix launcher for Minecraft")
    }

    Rectangle {
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
        Layout.preferredHeight: children[0].implicitHeight + 20
        color: hasUpdate && !(progressbarVisible || updateChecker.active) ? "#23a" : "#a22"
        visible: launcherSettings.showNotifications && (hasUpdate && !(progressbarVisible || updateChecker.active) || warnMessage.length > 0)
        Text {
            width: parent.width
            height: parent.height
            text: hasUpdate && !(progressbarVisible || updateChecker.active) ? qsTr("A new version of the launcher is available. Click to download the update.") : warnMessage
            color: "#fff"
            font.pointSize: 9
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: hasUpdate && !(progressbarVisible || updateChecker.active) || rowLayout.warnUrl.length > 0 ? Qt.PointingHandCursor : Qt.Pointer
            onClicked: {
                if (hasUpdate && !(progressbarVisible || updateChecker.active)) {
                    if (updateDownloadUrl.length == 0) {
                        updateCheckerConnectorBase.enabled = true
                        updateChecker.startUpdate()
                    } else {
                        Qt.openUrlExternally(updateDownloadUrl)
                    }
                } else if (rowLayout.warnUrl.length > 0) {
                    Qt.openUrlExternally(rowLayout.warnUrl)
                }
            }
        }
    }

    Rectangle {
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
        Layout.preferredHeight: children[0].implicitHeight + 20
        color: "#a72"
        visible: {
            if (!launcherSettings.showNotifications) {
                return false
            }
            for (var i = 0; i < GamepadManager.gamepads.length; i++) {
                if (!GamepadManager.gamepads[i].hasMapping) {
                    return true
                }
            }
            return false
        }

        Text {
            width: parent.width
            height: parent.height
            text: {
                var ret = []
                for (var i = 0; i < GamepadManager.gamepads.length; i++) {
                    if (!GamepadManager.gamepads[i].hasMapping) {
                        ret.push(GamepadManager.gamepads[i].name)
                    }
                }
                if (ret.length === 1) {
                    return qsTr("One Joystick can not be used as Gamepad Input: %1. Open Settings to configure it.").arg(ret.join(", "))
                }
                return qsTr("%1 Joysticks can not be used as Gamepad Input: %2. Open Settings to configure them.").arg(ret.length).arg(ret.join(", "))
            }
            color: "#fff"
            font.pointSize: 9
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
        }
    }

    ColumnLayout {
        id: container
        Layout.alignment: Qt.AlignCenter
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    MProgressBar {
        Layout.fillWidth: true
        id: downloadProgress
        label: progressbarVisible ? progressbarText : qsTr("Please wait...")
        width: parent.width
        height: 30
        visible: progressbarVisible || updateChecker.active
        indeterminate: value < 0.005
    }

    MessageDialog {
        id: updateError
        title: "Update Error"
    }

    Connections {
        id: updateCheckerConnectorBase
        target: updateChecker
        enabled: false
        onUpdateError: function (error) {
            updateCheckerConnectorBase.enabled = false
            updateError.text = error
            updateError.open()
        }
        onProgress: downloadProgress.value = progress
    }
}
