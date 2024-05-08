import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "ThemedControls"

ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 0

    BaseHeader {
        Layout.fillWidth: true
        title: qsTr("News")
        content: TabBar {
            id: tabs
            background: null
            MTabButton {
                text: qsTr("Minecraft")
            }
        }
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentHeight: Math.max(gridLayout.height + 2 * gridLayout.padding, availableHeight)

        GridLayout {
            id: gridLayout
            property int cellSize: Math.min(Math.max(250, window.height / 3), 400)
            property int padding: 15
            anchors.centerIn: parent
            width: parent.width - padding * 2
            columns: Math.max(Math.round(width / cellSize), 2)
            columnSpacing: padding
            rowSpacing: padding

            Repeater {
                id: newsGrid
                model: null

                Rectangle {
                    id: contentBox
                    Layout.minimumHeight: gridLayout.cellSize
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.columnSpan: newsImage.ratio > 1.5 ? 2 : 1
                    Layout.rowSpan: newsImage.ratio < 0.5 ? 2 : 1
                    color: "#222"

                    Image {
                        id: newsImage
                        property real ratio: sourceSize.width / sourceSize.height
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: modelData.image
                        smooth: false
                        anchors.bottom: parent.bottom
                    }

                    Rectangle {
                        id: descriptionBox
                        width: parent.width
                        height: 40
                        anchors.bottom: parent.bottom
                        color: "#B0000000"
                        Text {
                            anchors.fill: parent
                            text: modelData.name
                            color: "#fff"
                            font.pointSize: 10
                            font.weight: Font.Bold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            padding: 8
                        }
                    }

                    FocusBorder {
                        visible: mouseArea.activeFocus
                    }

                    states: State {
                        name: "hovered"
                        when: mouseArea.hovered
                    }

                    transitions: [
                        Transition {
                            to: "hovered"
                            NumberAnimation {
                                target: contentBox
                                property: "scale"
                                to: 1.0 + (12 / contentBox.width)
                                duration: 180
                                easing.type: Easing.OutCubic
                            }
                        },
                        Transition {
                            to: "*"
                            NumberAnimation {
                                target: contentBox
                                property: "scale"
                                to: 1.0
                                duration: 100
                                easing.type: Easing.OutSine
                            }
                        }
                    ]

                    MouseArea {
                        id: mouseArea
                        property bool hovered: false
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        hoverEnabled: true
                        focus: true
                        activeFocusOnTab: true

                        onEntered: hovered = true
                        onExited: hovered = false
                        onClicked: {
                            hovered = false
                            openArticle()
                        }
                        Keys.onSpacePressed: openArticle()

                        function openArticle() {
                            Qt.openUrlExternally(modelData.url)
                        }
                    }
                }
            }
        }

        MBusyIndicator {
            anchors.centerIn: parent
            visible: newsGrid.model === null
        }
    }

    function loadNews() {
        var req = new XMLHttpRequest()
        req.open("GET", "https://launchercontent.mojang.com/news.json", true)
        req.onerror = function () {
            console.log("Failed to load news")
        }
        req.onreadystatechange = function () {
            if (req.readyState === XMLHttpRequest.DONE) {
                if (req.status === 200)
                    parseNewsResponse(JSON.parse(req.responseText))
                else
                    req.onerror()
            }
        }
        req.send()
    }

    function parseNewsResponse(resp) {
        var entries = []
        for (var i = 0; i < resp.entries.length; i++) {
            var e = resp.entries[i]
            if (!e)
                continue
            entries.push({
                             "name": e.title || e.text,
                             "image": "https://launchercontent.mojang.com/" + e.newsPageImage.url,
                             "url": e.readMoreLink
                         })
            console.log(e.title)
        }
        newsGrid.model = entries
    }

    Component.onCompleted: loadNews()
}
