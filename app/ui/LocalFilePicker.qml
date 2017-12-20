import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.3

Page {
    title: i18n.tr("Local files")

//    property string fileName: ""
//    property int fileIndex: -1
//    property alias fileList: listModel

//    tools: ToolbarItems {
//        back: root.pageStack.pop()
//    }
    visible: false

    property bool exportRequest: false

    onActiveChanged: {
        if(active) {
            root.fileList = fileIO.getLocalFileList(fileIO.getHomePath() + "/.local/share/com.ubuntu.developer.pawstr.edit/")
            listModel.clear();
            for(var i=0; i<root.fileList.length; i++) {
//                console.log(root.fileList[i]);
                listModel.append({"text": root.fileList[i]});
            }
        }
    }
    ListModel {id: listModel}

    UbuntuListView {
        Action {
            property string fileName
            id: closeAction
            onTriggered: {
                root.importItems[0].url = "file://" + fileIO.getHomePath() + "/.local/share/com.ubuntu.developer.pawstr.edit/" + fileName;
                root.textArea.text = fileIO.read(root.importItems[0].url);
                root.title = fileIO.getFullName(root.importItems[0].url);
                tabsModel.updateTabs()
                root.saved = true
            }
        }
        id: ubuntuListView

//        anchors {
//            top: parent.top
//            left: parent.left
//            right: parent.right
//            bottom: buttonRow.top
//        }
        anchors.fill: parent

        model: listModel
        delegate: ListItem.Standard {
            id: standardItem
            text: modelData
            removable: true
            confirmRemoval: true
            backgroundIndicator: Rectangle {
                anchors.fill: parent
                color: UbuntuColors.red//Theme.palette.normal.base
                Icon {
                    id: deleteIcon
                    name: "delete"
                    color: "white"
                    height: parent.height - units.gu(1)
                    width: height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: standardItem.width/4 - width/2
                }
                Text {
                    text: i18n.tr("Remove")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: deleteIcon.right
                    color: "white"
                    font.bold: true
                }
            }
            onClicked: {
//                for(var i=0; i<listModel.count; i++) {
//                    ubuntuListView.currentIndex = i
//                    ubuntuListView.currentItem.selected = false
//                }
//                ubuntuListView.currentIndex = index
//                selected = true
//                fileName = text
//                fileIndex = index
                if(exportRequest) {
                    var url = "file://" + fileIO.getHomePath() + "/.local/share/com.ubuntu.developer.pawstr.edit/" + text;
                    root.activeTransfer.items = [ resultComponent.createObject(root, {"url": url}) ];
                    root.activeTransfer.state = ContentTransfer.Charged;

                    exportRequest = false
                    root.pageStack.pop();
                } else {
                    closeAction.fileName = text
                    root.pageStack.pop();
                    if(!root.saved) {
                        unsavedDialog.closeAction = closeAction
                        PopupUtils.open(unsavedDialog)
                    } else
                        closeAction.trigger()
                }
            }
            onItemRemoved: {
                fileIO.remove(fileIO.getHomePath() + "/.local/share/com.ubuntu.developer.pawstr.edit/" + text)

                if(root.title == text)
                    root.saved = false
            }
        }
    }
//    Rectangle {
//        id: buttonRow
//        anchors {
//            bottom: parent.bottom
//            left: parent.left
//            right: parent.right
//        }
//        height: openButton.height
//        Button {
//            id: openButton
//            anchors.right: buttonRow.horizontalCenter
//            anchors.margins: units.gu(1)
//            text: i18n.tr("Open")
//            onClicked: {
//                if (fileName != "") {
//                    closeAction.fileName = fileName
//                    root.pageStack.pop();
//                    if(!root.saved) {
//                        unsavedDialog.closeAction = closeAction
//                        PopupUtils.open(unsavedDialog)
//                    } else
//                        closeAction.trigger()
//                }
//            }
//        }
//        Button {
//            anchors.left: buttonRow.horizontalCenter
//            anchors.margins: units.gu(1)
//            text: i18n.tr("Remove")
//            onClicked: {
//                if(fileIndex !== -1) {
//                    PopupUtils.open(removeFileDialog)
//                }
//            }
//        }
//    }
}
