import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2

ScrollView {
    id: scrollView
    property alias content: childitem.data
    Layout.fillHeight: true
    Layout.fillWidth: true
    contentHeight: childitem.height + 30
    contentWidth: Math.max(childitem.width + 30, scrollView.width)
    Keys.forwardTo: childitem.children[0]

    Item {
        id: item
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: Math.max((scrollView.width - childitem.width) / 2, 15)
        anchors.topMargin: 15
        anchors.bottomMargin: 15
        anchors.rightMargin: (function() {
            var val = Math.max((scrollView.width - childitem.width) / 2, 15);
            console.log("marginr=" + val);
            return val;
        })()
        Item {
            id: childitem
            width: Math.min(Math.max(children[0].Layout.minimumWidth, scrollView.width - 30), 720)
            height: data[0].height
        }
    }
}
