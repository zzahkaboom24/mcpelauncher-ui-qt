import QtQuick 2.9

import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import "ThemedControls"
import io.mrarm.mcpelauncher 1.0

RowLayout {
    Layout.fillWidth: true
    spacing: 2
    id: layout

    property string name: ""
    property var gamepad: null
    property var key: change.active ? "" : btna.text

    Text {
        id: name
        text: layout.name
        color: "#fff"
        Layout.fillWidth: true
    }

    Text {
        id: btna
        text: ""
        color: "#fff"
    }

    MButton {
        id: change
        property bool active: false
        text: "..."
        onClicked: {
            if (active || !gamepad) {
                if (active) {
                    GamepadManager.enabled = true
                }
                active = false
                btna.text = ""
                return ""
            }
            if (GamepadManager.enabled) {
                active = true
                GamepadManager.enabled = false
                var oldButtons = []
                for (var i = 0; i < layout.gamepad.buttons.length; i++) {
                    oldButtons.push(layout.gamepad.buttons[i])
                }
                var oldAxes = []
                for (var i = 0; i < layout.gamepad.axes.length; i++) {
                    oldAxes.push(layout.gamepad.axes[i])
                }
                var oldHats = []
                for (var i = 0; i < layout.gamepad.hats.length; i++) {
                    oldHats.push(layout.gamepad.hats[i])
                }
                btna.text = Qt.binding(function () {
                    if (!gamepad) {
                        active = false
                        btna.text = ""
                        GamepadManager.enabled = true
                        return ""
                    }
                    for (var i = 0; i < layout.gamepad.buttons.length; i++) {
                        if (oldButtons[i] != layout.gamepad.buttons[i]) {
                            active = false
                            btna.text = "b" + i
                            GamepadManager.enabled = true
                            return ""
                        }
                    }
                    for (var i = 0; i < layout.gamepad.axes.length; i++) {
                        if (Math.abs(oldAxes[i] - layout.gamepad.axes[i]) > 0.5) {
                            active = false
                            btna.text = "a" + i
                            GamepadManager.enabled = true
                            return ""
                        }
                    }
                    for (var i = 0; i < layout.gamepad.hats.length; i++) {
                        if (oldHats[i] != layout.gamepad.hats[i]) {
                            active = false
                            btna.text = "h" + i + "." + layout.gamepad.hats[i]
                            GamepadManager.enabled = true
                            return ""
                        }
                    }
                    return "waiting"
                })
            }
        }
    }
}
