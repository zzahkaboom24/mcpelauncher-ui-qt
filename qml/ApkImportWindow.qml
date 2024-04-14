import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import QtQuick.Controls
import io.mrarm.mcpelauncher 1.0
import "ThemedControls"

Window {

    property VersionManager versionManager

    id: root
    width: 320
    height: layout.implicitHeight + layout.anchors.topMargin + layout.anchors.bottomMargin
    flags: Qt.Dialog
    title: "Minecraft .apk import"
    visible: apkImportHelper.extractingApk
    property var allowIncompatible: false

    onClosing: function () {
        close.accepted = false
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text {
            text: "Extracting the .apk"
            Layout.fillWidth: true
        }

        MProgressBar {
            id: apkExtractionProgressBar
            width: parent.width
            Layout.fillWidth: true
        }
    }

    ApkImportHelper {
        id: apkImportHelper
        versionManager: root.versionManager
        progressBar: apkExtractionProgressBar
        allowIncompatible: root.allowIncompatible
    }

    function pickFile() {
        apkImportHelper.pickFile()
    }
}
