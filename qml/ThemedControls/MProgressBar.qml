import QtQuick 2.9
import QtQuick.Templates 2.1 as T

T.ProgressBar {
    id: control
    padding: 2
    property string label: ""

    background: Rectangle {
        anchors.fill: parent
        color: "#1e1e1e"
    }

    contentItem: Item {
        Rectangle {
            width: parent.width * control.visualPosition
            height: parent.height
            color: "#008643"
            visible: !control.indeterminate
        }

        Item {
            clip: true
            anchors.fill: parent
            visible: control.indeterminate
            Rectangle {
                id: bar
                color: "#008643"
                x: -width
                width: parent.width / 4
                height: parent.height

                NumberAnimation on x {
                    from: -bar.width
                    to: control.width + 60
                    loops: Animation.Infinite
                    running: control.indeterminate
                    duration: 1400
                }
            }
        }

        Text {
            text: control.label
            color: "#fff"
            font.pointSize: 10
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
