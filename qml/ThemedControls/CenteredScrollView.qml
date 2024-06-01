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

    //ScrollBar.vertical.palette.dark: "white"
    // ScrollBar.vertical: ScrollBar {
    //     id: control
    //     orientation: Qt.Vertical
        
    
    //     contentItem: Rectangle {
    //         implicitWidth: 6
    //         implicitHeight: 100
    //         radius: width / 2
    //         color: control.pressed ? "#81e889" : "#c2f4c6"
    //     }
    // }
    Component.onCompleted: {
        ScrollBar.vertical.contentItem.color = Qt.binding(function() { return ScrollBar.vertical.pressed ? "#ffffff" : "#bfbfbf" })
        console.log(ScrollBar.vertical.contentItem)
    }

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
