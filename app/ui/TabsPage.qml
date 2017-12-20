import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Page {
    id: tabsPage
    title: i18n.tr("Tabs")
    visible: false

    property bool expanded: false

    onActiveChanged: {
        if(!active) {
            var lastIndex = tabsModel.selectedIndex
            if(lastIndex == 0 && tabsModel.count > 1) {
                tabsModel.move(0,1,1)
                tabsModel.selectTab(1)
            }
        }
    }

//    onVisibleChanged: {
//        if(visible == true) {
//            flickable.thumbWidth = root.textArea.width
//            flickable.thumbHeight = root.textArea.height
////            root.textArea.enabled = false
//        }
//    }

//    onWidthChanged: {
//        flickable.thumbWidth = root.textArea.width
//    }

//    onHeightChanged: {
//        flickable.thumbHeight = root.textArea.height
//    }

    Flickable {
        id: flickable
        property int thumbWidth: root.textArea.width// - units.gu(5) * (tabsModel.get(0).tab.width/tabsModel.get(0).tab.height)
        property int thumbHeight: root.textArea.height// + units.gu(5)
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent
        contentWidth: (thumbWidth + units.gu(2))// * tabsModel.count + units.gu(2) + units.gu(5) * (tabsModel.get(0).tab.width/tabsModel.get(0).tab.height)
        contentHeight: Math.max((thumbHeight/3) * tabsModel.count, thumbHeight) + units.gu(2)

        onDragEnded: {
            if(newTabIcon.revealed)
                tabsModel.addTab()
        }
        Column {
            anchors.fill: parent
            anchors.margins: units.gu(1)
            Repeater {
                model: tabsModel
                Rectangle {
                    width: flickable.thumbWidth
                    height: (tabsModel.count - 1) == index ? flickable.thumbHeight/3*Math.max(4-tabsModel.count,1) + units.gu(1) : flickable.thumbHeight/3
//                    radius: 10
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(tabsModel.selectedIndex != index) {
                                var lastIndex = tabsModel.selectedIndex
                                tabsModel.selectTab(index)
                                tabsModel.move(lastIndex,0,1)
                                tabsModel.selectTab(index)
                            }

//                            root.textArea.enabled = true
                            root.pageStack.pop()
                            root.header.show()
                        }
                    }
                    Column {
                        height: parent.height
                        spacing: -units.gu(1)
                        Rectangle {
                            z: 1
                            width: flickable.thumbWidth
//                            anchors.horizontalCenter: parent.horizontalCenter
                            height: units.gu(5)
//                            radius: 10
                            color: tabsModel.selectedIndex == index ? "white" : "lightgrey"
                            Rectangle{width: parent.width; height: 1; color: "darkgrey"; anchors.top: parent.bottom}
                            Icon {
                                id: closeIcon
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.margins: units.gu(1)
                                name: "close"
                                height: parent.height/2
                                width: height
                                color: /*tabsModel.selectedIndex == index ? "grey" :*/ "black"
                                MouseArea {
                                    property Action closeAction: Action {
                                        id: closeAction
                                        onTriggered: {
                                            tabsModel.removeTab(index)
                                        }
                                    }
                                    anchors.fill: parent
                                    onClicked: {
                                        if (tabsModel.count > 1) {
                                            tabsModel.selectTab(index)
                                            closeFileDialog.closeAction = closeAction
                                            PopupUtils.open(closeFileDialog)
                                        }
                                    }
                                }
                            }
                            Label {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.margins: units.gu(1)
                                anchors.left: closeIcon.right
                                anchors.right: parent.right
                                text: tabsModel.get(index).title
                                elide: Text.ElideRight
                                color: /*tabsModel.selectedIndex == index ? "grey" :*/ "black"
                            }
                        }
                        ShaderEffectSource {
                            sourceItem: model.tab
                            width: sourceItem.width// - units.gu(5) * (sourceItem.width/sourceItem.height)
                            height: sourceItem.height
                            live: tabsPage.expanded
                        }
                    }
                    Rectangle {
                        z: 2
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: (tabsModel.count - 1) == index ? 0.0 : 0.0; color: "white" }
                            GradientStop { position: (tabsModel.count - 1) == index ? 0.0 : 1.0; color: "black" }
                        }
                        opacity: 0.3
                    }
                }
            }
        }
        Rectangle { //This one is used to hide the text areas bottom parts
            color: Theme.palette.normal.background
            width: flickable.thumbWidth + units.gu(2)
            height: flickable.thumbHeight
            y: flickable.contentHeight
        }
    }

    Rectangle { //Bottom edge shadow
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position:  2/3 ; color: "white" }
            GradientStop { position:  1.0 ; color: "black" }
        }
        opacity: 0.3
    }

    Icon {
        id:newTabIcon
        property bool revealed: width >= flickable.thumbHeight/8

        name: "note-new"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: units.gu(1)
        height: Math.min(flickable.thumbHeight/8,flickable.contentY - flickable.contentHeight + flickable.thumbHeight)//(flickable.contentX - flickable.contentWidth + flickable.thumbWidth)
        width: height

        onRevealedChanged: {
            changeTextAnimation.start()
        }

        Label {
            id: hint
            text: newTabIcon.revealed ? i18n.tr("Release to create a new tab") : i18n.tr("Pull to create a new tab")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.margins: units.gu(5)

            visible: tabsPage.visible

            SequentialAnimation {
                id: changeTextAnimation
                running: false
                UbuntuNumberAnimation {
                    target: hint
                    property: "opacity"
                    from: 1.0
                    to: 0.0
                    duration: UbuntuAnimation.SnapDuration
                }
                ScriptAction { script: hint.text = newTabIcon.revealed ? i18n.tr("Release to create a new tab") : i18n.tr("Pull to create a new tab") }
                UbuntuNumberAnimation {
                    target: hint
                    property: "opacity"
                    from: 0.0
                    to: 1.0
                    duration: UbuntuAnimation.SnapDuration
                }
            }
        }
    }
}
