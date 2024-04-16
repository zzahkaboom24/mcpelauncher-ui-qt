import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2

ScrollView {
    property alias content: item.data
    Layout.fillHeight: true
    Layout.fillWidth: true
    contentHeight: item.height + 30
    Keys.forwardTo: item.children[0]

    Item {
        id: item
        anchors.centerIn: parent
        width: Math.min(parent.width - 30, 760)
        height: data[0].height
    }
}
