import QtQuick 2.4

import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import "ThemedControls"
import io.mrarm.mcpelauncher 1.0

Window {

    id: window
    width: 500
    height: layout.implicitHeight
    minimumWidth: 500
    minimumHeight: 300
    flags: Qt.Dialog
    title: qsTr("Launcher Settings")
    property GoogleLoginHelper googleLoginHelper
    property VersionManager versionManager
    property string currentGameDataDir
    property GoogleVersionChannel playVerChannel

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 20

        Image {
            id: title
            smooth: false
            fillMode: Image.Tile
            source: "qrc:/Resources/noise.png"
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.preferredHeight: 85

            Text {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                height: 50
                color: "#ffffff"
                text: qsTr("Launcher Settings")
                font.pixelSize: 24
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                anchors.bottom: parent.bottom
                height: 2
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#000"
            }
            Item {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                height: tabs.implicitHeight

                TabBar {
                    id: tabs
                    background: null

                    MTabButton {
                        text: qsTr("General")
                        width: implicitWidth
                    }
                    MTabButton {
                        text: qsTr("Storage")
                        width: implicitWidth
                    }
                    MTabButton {
                        text: qsTr("Versions")
                        width: implicitWidth
                    }
                    MTabButton {
                        visible: !(DISABLE_DEV_MODE)
                        text: qsTr("Dev")
                        width: !(DISABLE_DEV_MODE) ? implicitWidth : 0
                    }
                    MTabButton {
                        text: qsTr("About")
                        width: implicitWidth
                    }
                }
                Keys.forwardTo: [content]
            }
        }

        StackLayout {
            id: content
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            currentIndex: tabs.currentIndex

            LauncherSettingsGeneral {}

            LauncherSettingsStorage {}

            LauncherSettingsVersions {}

            LauncherSettingsDev {
                playVerChannel: window.playVerChannel
            }

            LauncherSettingsAbout {}
            Keys.forwardTo: children[tabs.currentIndex]
        }

        Image {
            id: buttons
            smooth: false
            fillMode: Image.Tile
            source: "qrc:/Resources/noise.png"
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            RowLayout {
                x: parent.width / 2 - width / 2
                y: parent.height / 2 - height / 2

                spacing: 20

                PlayButton {
                    Layout.preferredWidth: 150
                    text: qsTr("Close")
                    onClicked: close()
                }
            }
        }
    }

    function getCurrentGameDataDir() {
        if (window.currentGameDataDir && window.currentGameDataDir.length > 0) {
            return window.currentGameDataDir
        }
        return launcherSettings.gameDataDir
    }
}
